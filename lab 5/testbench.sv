module testbench();


timeunit 10ns;
timeprecision 1ns;

logic [9:0] SW;
logic Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic [15:0] PC, MDR, IR, MAR;

assign PC = testtop1.slc.PC_OUT;
assign IR = testtop1.slc.IR;
assign MDR = testtop1.slc.MDR;
assign MAR = testtop1.slc.MAR;



slc3_testtop testtop1(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_vectors

Continue = 1;
Run = 1;

#2 Continue = 0;

    Run = 0;
 
#2 Continue = 1;
    Run = 1;

#2 SW = 10'h9C;

#10 Run = 0;


end
endmodule