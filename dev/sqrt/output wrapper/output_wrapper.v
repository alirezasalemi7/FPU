`define M_QNAN 53'b1_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111
`define M_SNAN 53'b1
`define M_INF 53'b0
`define M_ZERO 53'b0
`define EXP_QNAN 11'b111_1111_1111
`define EXP_SNAN 11'b111_1111_1111
`define EXP_INF 11'b111_1111_1111
`define EXP_ZERO 11'b0

module output_wrapper(in_mantisa, in_exp, in_flags, out_mantisa, out_exp, out_sign);
/*
output wrapper module:
	inputs:
		in_mantisa -> input mantisa(53 bits)
		in_exp -> input exponent(11 bits)
		in_flags -> it's used to send some informations about mantisa and exponent(like zero, nan, infinite, ...)
	outputs:
		out_mantisa -> output mantisa
		out_exp -> output exponent 
		out_sign -> output signal( it's always zero because for nonzero it outputs QNAN)
*/
	parameter M_SIZE = 53;
	parameter EXP_SIZE = 11;
	input [M_SIZE - 1 : 0] in_mantisa;
	input [EXP_SIZE - 1 : 0] in_exp;
	input [2 : 0] in_flags;
	output [M_SIZE - 1 : 0] out_mantisa;
	output [EXP_SIZE - 1 : 0] out_exp;
	output out_sign;
	
	assign out_sign = 1'b0;
	assign out_mantisa = (in_flags == 3'b111) ? `M_QNAN : //sign error
					((in_flags == 3'b1) || (in_flags == 3'b0)) ? `M_ZERO : //zero or denormal numbers
					(in_flags == 3'b10) ? `M_INF : //infinite number
					(in_flags == 3'b100) ? in_mantisa : `M_SNAN; //normal output : others
	assign out_exp = (in_flags == 3'b111) ? `EXP_QNAN : //sign error
					((in_flags == 3'b1) || (in_flags == 3'b0)) ? `EXP_ZERO : //zero or denormal numbers
					(in_flags == 3'b10) ? `EXP_INF : //infinite number
					(in_flags == 3'b100) ? in_exp : `EXP_SNAN; //normal output : others

endmodule