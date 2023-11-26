//module processor ( input logic Clk, Reset_h, ClearA_LoadB_h, Run_h,
//input logic [9:0] S,
//output logic [7:0] Aval, Bval, 
//output logic [6:0] Ahexl, Bhexl, AhexU, BhexU,
//output logic X, ss);
//
//
//// create local variables here
//logic ClearA_loadB, reset, add, sub, clr_ld, shift, run, M ;
//logic [7:0] A, B, S_S;
////logic ss;
//logic [8:0] add_out;
//logic x;
////assign x = X;
//logic FN;
//assign reset = Reset_h;
////assign ClearA_loadB = ~Reset_h;
//assign M = B[0];
//// instantiation 
//HexDriver        HexAL (
//                        .In0(A[3:0]),
//                        .Out0(AhexL) ); 
//	 HexDriver        HexBL (
//                        .In0(B[3:0]),
//                        .Out0(BhexL) );
//
//HexDriver        HexAU (
//                        .In0(A[7:4]),
//                        .Out0(AhexU) );	
//	 HexDriver        HexBU (
//                       .In0(B[7:4]),
//                        .Out0(BhexU) );
//                        
//controlunit          control_unit (
//                        .Clk(Clk),
//                        .Reset(reset),
//                        .Run(Run_h),
//                        .ClearA_LoadB(ClearA_LoadB_h),
//                        .Shift(shift),
//                        .Add(add),
//                        .Sub(sub),
//                        
//								.Clr_Ld(clr_ld),
//                        .M(M)
//								);
//
//
//
//
//register_unit     reg_unitB (
//                        .Clk(Clk),
//                        .Reset(),
//                        .Shift_In(ss), 
//                        .load(ClearA_loadB_h),
//                        .Shift_En(shift),
//                        .D({A[0], B[6:0]}),
//                        .Shift_out(),
//                        .Data_out(B) );
//								
//nine_bit  ninebitadd(
//								.A(A),
//                        .B(S[7:0]),
//								.fn(FN),
//								.S(add_out[8:0])
//								);
//								
//register_unit     reg_unitA (
//                        .Clk(Clk),
//                        .Reset(reset /*| ClearA_loadB_h | clr_ld */),
//                        .Shift_In(x), 
//                        .Shift_En(shift),
//                        .D(add_out[7:0]),
//                        .Shift_out(ss),
//                        .Data_out(A), 
//								.load(add)
//								 );
//								 
//x_reg			X_unit  (
//								.Clk(Clk),
//								.load(add),
//								.Reset(reset | ClearA_loadB_h | clr_ld),
//								.D(add_out[8]),
//								.Q(x)
//									);
//
//
//
//
////	  sync b[2:0] (Clk, {~Reset_h, ~ClearA_LoadB_h, ~Run_h},     {reset, ClearA_loadB, run});
////	  sync Din_sync[7:0] (Clk, S, S_S);
//	  
//
////      assign Aval = A;
//		assign Aval = A;
//      assign Bval = B;
//
//
//endmodule

//4-bit logic processor top level module
//for use with ECE 385 Spring 2021
//last modified by Zuofu Cheng


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

//module Processor (input logic   Clk,     // Internal
//                                Reset,   // Push button 0
//                                LoadA,   // Push button 1
//                                LoadB,   // Push button 2
//                                Execute, // Push button 3
//                  input  logic [7:0]  Din,     // input data
//				  //Hint for SignalTap, you want to comment out the following 2 lines to hardwire values for F and R
//                  // input  logic [2:0]  F,       // Function select 
//                  // input  logic [1:0]  R,       // Routing select
//                  output logic [3:0]  LED,     // DEBUG
//                  output logic [7:0]  Aval,    // DEBUG
//                                Bval,    // DEBUG
//                  output logic [6:0]  AhexL,
//                                AhexU,
//                                BhexL,
//                                BhexU);
//
//	 //local logic variables go here
//	 logic Reset_SH, LoadA_SH, LoadB_SH, Execute_SH;
//	 logic [2:0] F_S;
//	 logic [1:0] R_S;
//	 logic Ld_A, Ld_B, newA, newB, opA, opB, bitA, bitB, Shift_En,
//	       F_A_B;
//	 logic [7:0] A, B, Din_S;
//	 
//	 logic [2:0]  F;
//	 logic [1:0]  R;
//
//	 //We can use the "assign" statement to do simple combinational logic
//	 assign Aval = A;
//	 assign Bval = B;
//	 assign LED = {Execute_SH,LoadA_SH,LoadB_SH,Reset_SH}; //Concatenate is a common operation in HDL
//	 
//	 //logic [2:0]  F;
//	 //logic [1:0]  R;
//	 //assign F = 3'b010;
//	 //assign R = 2'b10;
//	 
//	 //Note that you can hardwire F and R here with 'assign'. What to assign them to? Check the demo points!
//	 //Remember that when you comment out the ports above, you will need to define F and R as variables
//	 //uncomment the following lines when you hardwaire F and R (This was the solution to the problem during Q/A)
//	 //logic [2:0] F;
//	 //logic [1:0] R;
//	 //assign F = something;
//	 //assign R = something;
//	 
//	 //Instantiation of modules here
//	 register_unit    reg_unit (
//                        .Clk(Clk),
//                        .Reset(Reset_SH),
//                        .Ld_A, //note these are inferred assignments, because of the existence a logic variable of the same name
//                        .Ld_B,
//                        .Shift_En,
//                        .D(Din_S),
//                        .A_In(newA),
//                        .B_In(newB),
//                        .A_out(opA),
//                        .B_out(opB),
//                        .A(A),
//                        .B(B) );
//    compute          compute_unit (
//								.F(F_S),
//                        .A_In(opA),
//                        .B_In(opB),
//                        .A_Out(bitA),
//                        .B_Out(bitB),
//                        .F_A_B );
//    router           router (
//								.R(R_S),
//                        .A_In(bitA),
//                        .B_In(bitB),
//                        .A_Out(newA),
//                        .B_Out(newB),
//                        .F_A_B );
//	 control          control_unit (
//                        .Clk(Clk),
//                        .Reset(Reset_SH),
//                        .LoadA(LoadA_SH),
//                        .LoadB(LoadB_SH),
//                        .Execute(Execute_SH),
//                        .Shift_En,
//                        .Ld_A,
//                        .Ld_B );
//	 HexDriver        HexAL (
//                        .In0(A[3:0]),
//                        .Out0(AhexL) );
//	 HexDriver        HexBL (
//                        .In0(B[3:0]),
//                        .Out0(BhexL) );
//								
//	 //When you extend to 8-bits, you will need more HEX drivers to view upper nibble of registers, for now set to 0
//	 HexDriver        HexAU (
//                        .In0(A[7:4]),
//                        .Out0(AhexU) );	
//	 HexDriver        HexBU (
//                       .In0(B[7:4]),
//                        .Out0(BhexU) );
//								
//	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
//	  //These are array module instantiations
//	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
//	  //Note: We can invert the levels inside the port assignments
//	  sync button_sync[3:0] (Clk, {~Reset, LoadA, LoadB, ~Execute}, {Reset_SH, LoadA_SH, LoadB_SH, Execute_SH});
//	  sync Din_sync[7:0] (Clk, Din, Din_S);
//	  sync F_sync[2:0] (Clk, F, F_S);
//	  sync R_sync[1:0] (Clk, R, R_S);
//	  
//endmodule

//Top level for ECE 385 adders lab
//modified for Spring 2023

//Note: lowest 2 HEX digits will reflect lower 8 bits of switch input
//Upper 4 HEX digits will reflect value in the accumulator


module processor  (input Clk, Reset_Clear, Run_Accumulate, 
						input [9:0]			SW,
						output logic [9:0]	LED,
						output logic [6:0]	HEX0, 
											HEX1, 
											HEX2, 
											HEX3, 
											HEX4,
											HEX5,
						output logic [7:0]  A_out, A_cont, M, x_out,
						output logic add
										);

		// Declare temporary values used by other modules\
		logic clr_ld;
		logic shift;
		//logic add;
		logic sub, a_shifted;
		//logic [7:0] A_out; // data out from the register
		logic [8:0] adderres;
		logic [16:0] In, Out;
		logic Run_h;
	
		
		// Misc logic that inverts button presses and ORs the Load and Run signal
		always_comb	
		begin
				//Reset_h = ~Reset_Clear;
				Run_h = ~Run_Accumulate;

		end
		
		// Control unit allows the register to load once, and not during full duration of button press
		controlunit cu ( .Clk(Clk), .Run(Run_h), .ClearA_LoadB(~Reset_Clear), .M(M[0]), .Clr_Ld(clr_ld), .Shift(shift), .Add(add), .Sub(sub));
		//(input logic Reset, Clk, Run, ClearA_LoadB, M,
			   //output logic Clr_Ld, Shift, Add, Sub  );
				
		// adder
		
		nine_bit adder (.A(A_cont), .B(SW[7:0]), .fn(sub), .S(adderres));
		assign m_out = M[0];
		
//		(input [7:0] A, B,
//output  [8:0] S,
//
//input fn
//);
	
		// registers
		
		reg_8 A_reg (.Clk(Clk), .Reset(clr_ld), .Shift_In(x_out), .Load(add), .Shift_En(shift), .D(adderres[7:0]), .Shift_Out(a_shifted), .Data_Out(A_cont[7:0]));
		reg_8 B_reg (.Clk(Clk), .Reset(0), .Shift_In(a_shifted), .Load(clr_ld), .Shift_En(shift), .D(SW[7:0]), .Data_Out(M[7:0]));
		reg_1 X_reg (.Clk(Clk), .Reset(clr_ld), .Load(add), .D(adderres[8]), .Data_Out(x_out));
//(input  logic Clk, Reset, Shift_In, Load, Shift_En,
//              input  logic [7:0]  D,
//              output logic Shift_Out,
//              output logic [7:0]  Data_Out);

		// Hex units that display contents of SW and register R in hex
		HexDriver		AHex0 (
								.In0(SW[3:0]),
								.Out0(HEX0) );
								
		HexDriver		AHex1 (
								.In0(SW[7:4]),
								.Out0(HEX1) );
								
		HexDriver		BHex0 (
								.In0(M[3:0]),
								.Out0(HEX2) );
								
		HexDriver		BHex1 (
								.In0(M[7:4]),
								.Out0(HEX3) );
		
		HexDriver		BHex2 (
								.In0(A_cont[7:0]),
								.Out0(HEX4) );
								
		HexDriver		BHex3 (
								.In0(A_cont[7:4]),
								.Out0(HEX5) );
								
		
		assign LED[1:0] = SW[9:8];
		assign LED[9] = Out[16];
		assign LED[8:2] = 7'h00;
		
endmodule



