module full_adder (input x, y, z,
output logic s, c);
assign s = x^y^z;
assign c = (x&y)|(y&z)|(x&z);
endmodule   

module nine_bit (input [7:0] A, B,
input fn,
output  [8:0] S
);

logic A_new, B_new;
logic [7:0] B_NOT;

logic c0,c1,c2,c3,c4,c5,c6,c7;

assign B_NOT[7:0]= (B ^ {8{fn}});
//The module uses full adders to perform the addition or subtraction. 
//The input B is first complemented based on the value of Fn using the XOR operator with a vector of 8 bits having the same value as Fn.

assign A_new = A[7];
assign B_new = B_NOT[7];




//logic [8:0] A_sign_extended, B_sign_extended;

//assign A_sign_extend = {A[7], A_sign_extended[7:0]};

//assign B_sign_extended = {A[7], A_sign_extended[7:0]};

// if (sub)
// begin
// b_not = {8{fn}}^b[7:0]
// end
// else
// begin
// b_not = b;
// end
// whatever cin = sub
full_adder FA0 (.x (A[0]), .y (B_NOT[0]), .z (fn), .s (S[0]), .c (c0));
full_adder FA1 (.x (A[1]), .y (B_NOT[1]), .z (c0), .s (S[1]), .c (c1));
full_adder FA2 (.x (A[2]), .y (B_NOT[2]), .z (c1), .s (S[2]), .c (c2));
full_adder FA3 (.x (A[3]), .y (B_NOT[3]), .z (c2), .s (S[3]), .c (c3));
full_adder FA4 (.x (A[4]), .y (B_NOT[4]), .z (c3), .s (S[4]), .c (c4));
full_adder FA5 (.x (A[5]), .y (B_NOT[5]), .z (c4), .s (S[5]), .c (c5));
full_adder FA6 (.x (A[6]), .y (B_NOT[6]), .z (c5), .s (S[6]), .c (c6));
full_adder FA7 (.x (A[7]), .y (B_NOT[7]), .z (c6), .s (S[7]), .c (c7));
full_adder FA8 (.x (A_new), .y (B_new), .z (c7), .s (S[8]));

endmodule   

//The carry-out bit of the last full adder is not used, and the sum bit produced by the last full adder is stored in the most significant bit of the output, S[8]




// In the final add/shift cycle, if M=1, then you subtract instead of add. 
// To subtract, negate B and set cin = 1
// 