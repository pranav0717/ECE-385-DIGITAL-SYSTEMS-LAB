module controlunit(input logic Clk, Run, ClearA_LoadB, M,
			   output logic Clr_Ld, Shift, Add, Sub  );


enum logic [4:0] {clear, start, halt, A1, A2, A3, A4, A5, A6, A7, A8, S1, S2,S3,S4,S5,S6,S7,S8} curr_state , next_state;

always_ff @ (posedge Clk)  
    begin
        if (ClearA_LoadB)
            curr_state <= clear;
        else 
            curr_state <= next_state;
    end

always_comb 
      begin
		next_state = curr_state ;

		unique case(curr_state)
//			default:
//			next_state = curr_state;
			clear : if (~ClearA_LoadB)
				next_state = start;
			start : if(Run)
					next_state = A1; 

			
			A1 : next_state = S1;

			A2 : next_state = S2;
			A3 : next_state = S3;
			A4 : next_state = S4;
			A5 : next_state = S5;
			A6 : next_state = S6;
			A7 : next_state = S7;
			A8 : next_state = S8;
			S1 : next_state = A2;
			S2 : next_state = A3;
			S3 : next_state = A4;
			S4 : next_state = A5;
			S5 : next_state = A6;
			S6 : next_state = A7;
			S7 : next_state = A8;
			S8 : next_state = halt;
			halt: if(~Run) 
					next_state = start;

	endcase
	
	//end

//always_comb 
	//begin
	Clr_Ld = 1'b0;
	Shift = 1'b0;
	Add = 1'b0;
	Sub = 1'b0;
	case(curr_state)
			
	      start : begin 
					Clr_Ld = 1'b0;
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					
			end
		
		A1,A2,A3,A4,A5,A6,A7 : begin 
					Clr_Ld = 1'b0;
					Shift = 1'b0;
					
					Sub = 1'b0;
					Add = M;

					
			end

				A8 : begin 
					Clr_Ld = 1'b0;
					Shift = 1'b0;
					Add = M;
						
					Sub = 1'b1;

			end 
		
		S1,S2,S3,S4,S5,S6,S7,S8 : begin 
					Clr_Ld = 1'b0;
					Shift = 1'b1;
					Add = 1'b0;
					Sub = 1'b0;
					
			end

		clear : begin 
					Clr_Ld = 1'b1;
					Shift = 1'b0;
					Add = 1'b0;
					Sub = 1'b0;
					

			end

				
	
	endcase
	 
	end 

	
endmodule
