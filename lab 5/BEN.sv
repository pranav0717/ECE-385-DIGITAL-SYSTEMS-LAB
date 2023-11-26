module BEN(
	input logic LD_CC, LD_BEN, Clk, Reset,
	input logic [2:0] IR,
    input logic [15:0] bus,
	output logic Dout
);

    logic n, z, p, n_out, z_out, p_out, logic_out;

    always_ff @ (posedge Clk) begin
            if(Reset)
                Dout <= 1'b0;
            else if(LD_CC) begin
                n_out <= n;
					 z_out <= z;
					 p_out <= p;
			  end
			  if(LD_BEN)
                Dout <= ((IR[2] && n_out) || (IR[1] && z_out) || (IR[0] &&p_out));

            
    end
	 

    always_comb begin
		if(bus == 16'h0000) begin
			n = 1'b0;
			z = 1'b1;
			p = 1'b0;
		end 
		
		else if(bus[15] == 1'b1) begin
			n = 1'b1;
			z = 1'b0;
			p = 1'b0;
		end 
		
		else 
		begin
			n = 1'b0;
			z = 1'b0;
			p = 1'b1;
		end 
	end 
endmodule