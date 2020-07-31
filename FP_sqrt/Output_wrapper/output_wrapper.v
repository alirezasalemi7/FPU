`include "register_sqrt.v"
`include "header.h"

module output_wrapper(in_mantisa, in_exp, in_flags, out_mantisa, out_exp, out_sign);
/*
output wrapper module:
	This module prepares data for output interface based on received flags
	inputs:
		in_mantisa -> input mantissa
		in_exp -> input exponent
		in_flags -> it is used to send some information about the mantissa and the exponent (zero, nan, infinite, etc.) These flags are:
			00 -> denormal
			01 -> zero
			10 -> inf
			11 -> nan
			100 -> input is normal
			111 -> sign error (sign is negative)
	outputs:
		out_mantisa -> output mantissa
		out_exp -> output exponent
		out_sign -> output signal( it is always zero because in normal situation output is positive; for negative inputs, it outputs QNAN to indicate an error)
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
	assign out_mantisa = ((in_flags == 3'b111) || (in_flags == 3'b11)) ? `M_QNAN : //sign error
					((in_flags == 3'b1) || (in_flags == 3'b0)) ? `M_ZERO : //zero or denormal number
					(in_flags == 3'b10) ? `M_INF : //infinite number
					(in_flags == 3'b100) ? in_mantisa : `M_SNAN; //normal output : others
	assign out_exp = ((in_flags == 3'b111) || (in_flags == 3'b11)) ? `EXP_QNAN : //sign error
					((in_flags == 3'b1) || (in_flags == 3'b0)) ? `EXP_ZERO : //zero or denormal number
					(in_flags == 3'b10) ? `EXP_INF : //infinite number
					(in_flags == 3'b100) ? in_exp : `EXP_SNAN; //normal output : others


endmodule