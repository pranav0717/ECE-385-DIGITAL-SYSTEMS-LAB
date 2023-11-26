//module datapath( 
//input logic Clk, Reset, GateALU, GateMARMUX, GateMDR, GatePC,LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,); 
//logic [15:0] PC_OUT, MAR, IR, MDR;
//logic [15:0] bus;
//logic [15:0] PC_NEXT;

//always_comb begin
//if(GatePC)begin
//    bus = PC_OUT;
//end
//
//else if(GateMDR)begin
//    bus = MDR_OUT;
//end
//else if(GateALU)begin
////    bus = ALU_OUT;//aasign bus = // think
//end
//else if(GateMARMUX)begin
////    bus = MARMUX_OUT;//assign bus =  // think
//end
//end
//
//reg_16_bits MAR(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .Din(bus), .Dout(MAR));
//reg_16_bits MDR(.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .Din(MDR_INPUT), .Dout(MDR));
//reg_16_bits PC(.Clk(Clk), .Reset(Reset), .Load(LD_PC), .Din(PC_INPUT), .Dout(PC_OUT));
//reg_16_bits IR(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .Din(bus), .Dout(IR));
//
//logic [15:0] MDR_INPUT;
//logic [15:0] PC_INPUT;
//assign PC_NEXT = PC_OUT + 1;
//PCMUX pc_mux(.select(2'b10), .PC_1(PC_NEXT), .bus(bus), .Adder_out(ADDR), .m4(PC_INPUT));
//MEMMUX mem_mux(.select(MIO_EN), .bus(bus), .mem_in(MRD_IN), .m4(MDR_INPUT));


//endmodule

