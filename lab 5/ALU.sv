module ALU(
			input  logic 	[15:0]	A, B, 
			input logic 	[1:0]	ALUK,
			output logic 	[15:0] 	ALU_OUT
		   );

	always_comb begin
		case(ALUK) 
			2'b00	:	ALU_OUT= A + B;
			2'b01	:	ALU_OUT = A & B;
			2'b10	:	ALU_OUT = ~A;
			2'b11	:	ALU_OUT = A;
		  default: 	ALU_OUT = 16'hX;
		endcase
	end 
endmodule 