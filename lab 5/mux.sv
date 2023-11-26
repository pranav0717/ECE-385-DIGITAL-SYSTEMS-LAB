


//PCMUX
module PCMUX( input [1:0] select,
    input logic [15:0] PC_1,
    input logic [15:0] bus,
    input logic [15:0] Adder_out,
    output logic [15:0] m_4

   
);

 always_comb begin
       case(select)
            2'b00: m_4 = PC_1;
            2'b01: m_4 = bus;
            2'b10: m_4 = Adder_out;
              default: m_4 = 16'hXXXX;

       endcase
    end

endmodule



//MEMMUX
module MEMMUX( 
    input logic select,
    input logic [15:0] bus,
    input logic [15:0] mem_in,
    output logic [15:0] m_4

   
);

 always_comb begin
       case(select)
            1'b0: m_4 = bus;
            1'b1: m_4 = mem_in;
            default: m_4 = 16'hXXXX;
       endcase
  end

endmodule



//ADDR2MUX
module ADDR2_MUX(
        input logic [1:0] select,
        input logic [15:0] SEXT_6, SEXT_9, SEXT_11,
        input logic zero,
        output logic [15:0] m_4


);

 always_comb begin
       case(select)
            2'b00: m_4 = zero;
            2'b01: m_4 = SEXT_6;
            2'b10: m_4 = SEXT_9 ;
            2'b11: m_4 = SEXT_11;
            default: m_4 = 16'hXXXX;
       endcase
  end

endmodule



//ADD1RMUX
module ADDR1_MUX(
        input logic select,
        input logic [15:0] SR1_OUT, PC_OUT,
        output logic [15:0] m_4


);

 always_comb begin
       case(select)
            1'b0: m_4 = PC_OUT;
            1'b1: m_4 = SR1_OUT;
            default: m_4 = 16'hXXXX;
       endcase
  end

endmodule


//SR1MUX
module SR1MUX(
        input logic  select,
        input logic [2:0] IR_9_11,IR_6_8,
        output logic [2:0] m_4


);

 always_comb begin
       case(select)
            1'b0: m_4 = IR_9_11;
            1'b1: m_4 = IR_6_8;
            default: m_4 = 3'bXXX;
       endcase
  end

endmodule


// SR2MUX
module SR2MUX(
        input logic  select,
        input logic [15:0] SR2_OUT, SEXT_5,
        output logic [15:0] m_4


);

 always_comb begin
       case(select)
            1'b0: m_4 = SR2_OUT;
            1'b1: m_4 = SEXT_5;
            default: m_4 = 16'hXXXX;
       endcase
  end

endmodule


// DRMUX
module DRMUX(
        input logic select,
        input logic [2:0] IR_9_11,
        output logic [2:0] m_4


);

 always_comb begin
       case(select)
            1'b0: m_4 = IR_9_11;
            1'b1: m_4 = 3'b111;
            default: m_4 = 3'bXXX;
       endcase
  end

endmodule