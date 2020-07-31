`include "input_wrapper_DP.v"
`include "input_wrapper_CU.v"

module input_wrapper(clk, rst, in_exp, in_flags, in_mantisa, in_type, start, ready, sign, out_exp, out_flags, out_mantisa, out_type, start_sqrt);
/*
input wrapper of sqrt unit:
	it gets splitted values from input_interface and preapares them for the main module and the exponent handler
	inputs:
		in_exp: input exponent
		in_mantisa: input mantissa
		in_flags: input flags; it is used to identify special cases. These flags are:
			00 -> denormal
			01 -> zero
			10 -> inf
			11 -> nan
			100 -> input is normal
			111 -> sign error (sign is negative)
		in_type: input type (single precision or double precision)
		sign: input sign, 0 indicates positive and 1 indicates negative
		start and ready: handshaking signals
	outputs:
		out_exp: output exponent
		out_flags: output flags, as same as the input flags
		out_mantisa: output mantissa
		out_type: output type, same as in_type
		start_sqrt: a status signal indicating whether or not to run the main module
*/
	parameter OUT_M_SIZE = 106;
	parameter IN_M_SIZE = 53;
	parameter EXP_SIZE = 11;
	input clk, rst, in_type, start, ready, sign;
	input [EXP_SIZE - 1 : 0] in_exp;
	input [IN_M_SIZE - 1 : 0] in_mantisa;
	input [2 : 0] in_flags;
	output out_type, start_sqrt;
	output [EXP_SIZE - 1 : 0] out_exp;
	output [OUT_M_SIZE - 1 : 0] out_mantisa;
	output [2 : 0] out_flags;
	wire run, ld_reg;

	input_wrapper_DP #(.OUT_M_SIZE(OUT_M_SIZE), .IN_M_SIZE(IN_M_SIZE), .EXP_SIZE(EXP_SIZE)) DP(.clk(clk), .rst(rst)
						, .in_type(in_type), .in_exp(in_exp), .in_mantisa(in_mantisa), .start(start)
						, .ready(ready), .sign(sign), .ld_reg(ld_reg), .in_flags(in_flags), .out_type(out_type)
						, .out_exp(out_exp), .out_mantisa(out_mantisa), .out_flags(out_flags), .run(run));

	input_wrapper_CU CU(.clk(clk), .rst(rst), .run(run), .start_sqrt(start_sqrt), .ld_reg(ld_reg));

endmodule