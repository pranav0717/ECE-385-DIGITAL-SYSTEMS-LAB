/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registers
//put other local variables here

//vga controller ports
logic [9:0] drawxsig, drawysig;
logic vga_clk, blank, sync;

//COPIED FROM PDF DOC
logic sprite_on;
logic [9:0] sprite_x, sprite_y;
logic [31:0] sprite_index;

//word retrieval logic
logic [31:0] word_address;
logic [1:0] word_offset;
logic [7:0] font_code;


//font_rom interface logic;
logic [10:0] sprite_addr;
logic [7:0] sprite_data;
logic inverse;

//RGB next state
logic [3:0] red_next, green_next, blue_next;


//Declare submodules..e.g. VGA controller, ROMS, etc

font_rom font_handler (.addr(sprite_addr), .data(sprite_data));
vga_controller vga_controller_71 (.Clk(CLK), .Reset(RESET), .DrawX(drawxsig), .DrawY(drawysig), .hs(hs), .vs(vs), .pixel_clk(vga_clk), .blank(blank), .sync(sync));
   
// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) begin

	if(AVL_CS && AVL_WRITE) begin //write logic
		LOCAL_REG[AVL_ADDR][7:0] <= AVL_BYTE_EN[0] ? AVL_WRITEDATA[7:0] : LOCAL_REG[AVL_ADDR][7:0];
		LOCAL_REG[AVL_ADDR][15:8] <= AVL_BYTE_EN[1] ? AVL_WRITEDATA[15:8] : LOCAL_REG[AVL_ADDR][15:8];
		LOCAL_REG[AVL_ADDR][23:16] <= AVL_BYTE_EN[2] ? AVL_WRITEDATA[23:16] : LOCAL_REG[AVL_ADDR][23:16];
		LOCAL_REG[AVL_ADDR][31:24] <= AVL_BYTE_EN[3] ? AVL_WRITEDATA[31:24] : LOCAL_REG[AVL_ADDR][31:24];
	end

	else if( AVL_READ && AVL_CS) begin //read logic
		AVL_READDATA <= LOCAL_REG[AVL_ADDR];
	end

end


//handle drawing (may either be combinational or sequential - or both).

always_comb begin: ASSIGN_LOGICS
	sprite_x = drawxsig >> 3;
	sprite_y = drawysig >> 4;
	sprite_index = (sprite_y * 80) + sprite_x;
	word_address = sprite_index >> 2;
	word_offset = sprite_index[1:0];
	sprite_addr = {font_code,drawysig[3:0]};
	inverse = font_code[7];
	 
end

always_comb begin: WORD_LOCATING
	case (word_offset)
		2'b00:	font_code = LOCAL_REG[word_address][7:0];
		2'b01:	font_code = LOCAL_REG[word_address][15:8];
		2'b10:	font_code = LOCAL_REG[word_address][23:16];
		2'b11:	font_code = LOCAL_REG[word_address][31:24];
	endcase
	
end



	//RGB display handler. NEEDS TO BE MODIFIED!!!!!!!!!!!!!!
	always_comb begin: RGB_Display
		if (blank == 0) begin
		//cond: if boundary touched
			red_next = 4'h0;
			green_next = 4'h0;
			blue_next = 4'h0;
		end
		
		else begin
		//cond: not at boundary, starting a nested if
			if((sprite_data[7-drawxsig[2:0]] ^ inverse) == 0) begin
			//cond: foreground
			red_next = LOCAL_REG[`CTRL_REG][24:21];
			green_next = LOCAL_REG[`CTRL_REG][20:17];
			blue_next = LOCAL_REG[`CTRL_REG][16:13];
			end
			
			else begin // inv !0
			//cond: background
			red_next = LOCAL_REG[`CTRL_REG][12:9];
			green_next = LOCAL_REG[`CTRL_REG][8:5];
			blue_next = LOCAL_REG[`CTRL_REG][4:1];
			end
			
		end
	
	end
	
	//RGB display update.
	always_ff @ (posedge vga_clk) begin: UPDATING_RGB
		red <= red_next;
		green <= green_next;
		blue <= blue_next;
	end
	
endmodule
