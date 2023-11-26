//module register_unit (
//  input logic Clk, Reset, Shift_In, load, Shift_En,
//  input logic [7:0] D,
//  output logic Shift_out,
//  output logic [7:0] Data_out
//);
//
//  always_ff @(posedge Clk) begin
//    if (Reset) begin
//      Data_out <= 8'h0;
//    end else if (load) begin
//      Data_out <= D;
//    end else if (Shift_En) begin
//      Data_out <= {Shift_In, Data_out[7:1]};
//    end
//  end
//
//  always_comb begin
//    Shift_out = Data_out[0];
//  end 
//
//endmodule
//In summary, this module describes a simple 8-bit register with synchronous reset, load, and shift functionality that can be used in larger digital designs. When the "Shift_En" signal is asserted, the register shifts out its contents and shifts in a new value from the "Shift_In" input signal.
//Clk: a clock signal that is used to synchronize the register updates.
//Reset: a synchronous reset signal that resets the register to the value 8'h0 (hexadecimal 0) when asserted.
//Shift_In: a control signal that determines whether the register should shift in a new data value.
//load: a control signal that determines whether the register should be updated with the input data D.
//Shift_En: a control signal that determines whether the register should shift out the data value.
//D: an 8-bit input data signal that is loaded into the register when the "load" signal is asserted.
// Shift_out: a single-bit output signal that represents the shifted-out bit value from the register.
//Data_out: an 8-bit output signal that represents the current value stored in the register.

//Shift_out: a single-bit output signal that represents the shifted-out bit value from the register.
//Data_out: an 8-bit output signal that represents the current value stored in the register.


//module x_reg (
//  input logic Clk, Reset, load,
//  input logic [7:0] D,
//  output logic Q
//);
//
//  always_ff @(posedge Clk) begin
//    if (Reset) begin
//      Q <= 1'b0;
//    end else if (load) begin
//      Q <= D;
//    end
//  end
//
//endmodule

//The always_ff block is a sequential block that executes on the rising edge of the clock signal. The block contains a conditional statement that updates the value of Q based on the values of the input signals.
//
//When the "Reset" signal is asserted, the register is cleared to 1'b0. When the "load" signal is asserted, the input data D is loaded into the register. Otherwise, the register retains its current value.
//
//In summary, this module describes a simple 8-bit register with synchronous reset and load functionality that can be used in larger digital designs.
//


module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'h0;
		 else if (Load)
			  Data_Out <= D;
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
    end
	
    assign Shift_Out = Data_Out[0];

endmodule


module reg_1 (input  logic Clk, Reset, Load,
              input  logic  D,
              output logic  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 1'h0;
		 else if (Load)
			  Data_Out <= D;
//		 else if (Shift_En)
//		 begin
//			  //concatenate shifted in data to the previous left-most 3 bits
//			  //note this works because we are in always_ff procedure block
//			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
//	    end
    end


endmodule


