module reg_16_bits
(
    input logic Clk, Reset, Load,
    input logic [15:0] Din,
    output logic [15:0] Dout
);
always_ff @ (posedge Clk) begin
    if (Reset) 
        Dout <= 16'h0;
    else if (Load)
        Dout <= Din[15:0];
end
endmodule
