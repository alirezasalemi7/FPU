`include "adder.v"
`include "multiplexer.v"


module exponent_handler(type, exp, out_exp);
/*
	This module is used for preparing the output exponent based on the input exponent in SQRT module
	inputs:
		exp: input exponent
		type: input type (single precision or double precision)
	output:
		out_exp: output exponent
*/
parameter SIZE = 11;
input [SIZE - 1 : 0] exp; //exponent
input type; // 0 indicates single precision and 1 indicates double precision
output [SIZE - 1 : 0] out_exp;

wire [SIZE - 1 : 0] offset;
wire cout;
// offset : double -> 511 , single -> 63
multiplexer #(11) MUX(.first_value(11'b11_1111), .second_value(11'b1_1111_1111), .select(type), .out(offset));
// formula is : out = 1/2 (exp - exp[0]) + offset + exp[0];
adder #(11) Adder(.a({1'b0, exp[SIZE - 1 : 1]}), .b(offset), .cin(exp[0]), .out(out_exp), .cout(cout));

endmodule