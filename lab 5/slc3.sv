//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 5 Given Code - SLC-3 top-level (Physical RAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//------------------------------------------------------------------------------


module slc3(
	input logic [9:0] SW, //LEAVE SWITHCHES AT 0 WHEN MAKING TESTBENCH
	input logic	Clk, Reset, Run, Continue,
	output logic [9:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);


// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; 
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules




// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC_OUT, ALU_OUT;

 // LOCAL VARIABLE STUFF
logic [2:0] DR_MUX_OUT, SR1_MUX_OUT;
logic [15:0] SR1_REG_OUT, SR2_REG_OUT, SR2_MUX_OUT;
logic [15:0] ADDR_1_MUX_OUT, ADDR_2_MUX_OUT;
logic [15:0] ADDR_SUM_OUT;
assign ADDR_SUM_OUT = ADDR_1_MUX_OUT + ADDR_2_MUX_OUT;

// Connect MAR to ADDR, which is also connected, as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;
logic [15:0] MDR_INPUT;
logic [15:0] PC_INPUT;
logic [15:0] PC_NEXT;
assign PC_NEXT = PC_OUT + 16'b1;
// Connect everything to the data path (you have to figure out this part)

//datapath d0 (.*);


//BUS LOGIC
logic [15:0] bus;

always_comb begin
	if(GatePC)
		 bus = PC_OUT;

	else if(GateMDR)
		 bus = MDR;

	else if(GateALU)
		bus = ALU_OUT;

	else if(GateMARMUX)
	    bus = ADDR_SUM_OUT;

	else
		bus = 'X;
end

// REGISTERS
reg_16_bits MAR_REG(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .Din(bus), .Dout(MAR));
reg_16_bits MDR_REG(.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .Din(MDR_INPUT), .Dout(MDR));
reg_16_bits PC_REG(.Clk(Clk), .Reset(Reset), .Load(LD_PC), .Din(PC_INPUT), .Dout(PC_OUT));
reg_16_bits IR_REG(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .Din(bus), .Dout(IR));

Regfile reg_file(.Clk(Clk), .Reset(Reset), .LD_REG(LD_REG), .bus(bus), .DR(DR_MUX_OUT), .SR1_IN(SR1_MUX_OUT), .SR1_OUT(SR1_REG_OUT), .SR2_IN(IR[2:0]), .SR2_OUT(SR2_REG_OUT));


//MUXS
PCMUX pc_mux(.select(PCMUX), .PC_1(PC_NEXT), .bus(bus), .Adder_out(ADDR_SUM_OUT), .m_4(PC_INPUT));
MEMMUX mem_mux(.select(MIO_EN), .bus(bus), .mem_in(MDR_In), .m_4(MDR_INPUT));

ADDR2_MUX addr2_mux(.select(ADDR2MUX), .SEXT_6({{10{IR[5]}}, IR[5:0]}),.SEXT_9({{7{IR[8]}}, IR[8:0]}), .SEXT_11({{5{IR[10]}}, IR[10:0]}), .zero(16'h0000), .m_4(ADDR_2_MUX_OUT));
ADDR1_MUX addr1_mux(.select(ADDR1MUX), .SR1_OUT(SR1_REG_OUT), .PC_OUT(PC_OUT), .m_4(ADDR_1_MUX_OUT));
SR1MUX sr1_mux(.select(SR1MUX), .IR_9_11(IR[11:9]), .IR_6_8(IR[8:6]), .m_4(SR1_MUX_OUT));
SR2MUX sr2_mux(.select(SR2MUX), .SR2_OUT(SR2_REG_OUT), .SEXT_5({{11{IR[4]}}, IR[4:0]}), .m_4(SR2_MUX_OUT));
DRMUX dr_mux(.select(DRMUX), .IR_9_11(IR[11:9]), .m_4(DR_MUX_OUT));


// ALU
ALU alu(.A(SR1_REG_OUT), .B(SR2_MUX_OUT), .ALUK(ALUK), .ALU_OUT(ALU_OUT));

// BIG BOY BEN
BEN ben(.Clk(Clk), .Reset(Reset), .LD_CC(LD_CC), .LD_BEN(LD_BEN), .bus(bus), .IR(IR[11:9]), .Dout(BEN));

// Our SRAM and I/O controller (note, this plugs into MDR/MAR)
Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]),
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   	.Mem_OE(OE), .Mem_WE(WE)
);


always_comb
begin
	case(LD_LED)
	1'b0: LED = 10'b0; 
	1'b1: LED = IR[9:0];
	endcase
end


endmodule
