`include "exponent_handler.v"
`include "input_wrapper.v"
`include "output_wrapper.v"
`include "sqrt.v"


module fp_sqrt(in_mantisa, in_exp, in_sign, in_type, in_flags, start, rst, clk, out_mantisa, out_exp, out_sign,out_ready);
/*
this module calculates square root of floating point numbers (both single and double precision)
inputs:
	clk and rst: clock and asynchronous reset
	in_mantisa: input mantissa
	in_exp: input exponent
	in_sign: // 0 indicates positive and 1 indicates negative
	in_type: // 0 indicates single precision and 1 indicates double precision
	in_flags: input flags indicating some information about mantissa and exponent. these flags are:
		00 -> denormal
		01 -> zero
		10 -> inf
		11 -> nan
		100 -> input is normal
		111 -> sign error (sign is negative)
	start: a signal indicating the start of the operation (used in handshaking)
outputs:
	out_mantisa: output mantissa
	out_exp: output exponent
	out_sign: output sign (same as in_sign)
	out_ready: indicating that the output is ready (used in handshaking)
*/
	parameter INPUT_MODULE_M_SIZE = 53;
	parameter INPUT_SQRT_M_SIZE = 106;
	parameter EXP_SIZE = 11;
	input [INPUT_MODULE_M_SIZE - 1 : 0] in_mantisa;
	input [EXP_SIZE - 1 : 0] in_exp;
	input in_sign, in_type, start, rst, clk;
	input [2 : 0] in_flags;
	output [INPUT_MODULE_M_SIZE - 1 : 0] out_mantisa;
	output [EXP_SIZE - 1 : 0] out_exp;
	output out_sign,out_ready;

	wire start_sqrt, ready, type;
	wire [EXP_SIZE - 1 : 0] in_exp_handler, out_exp_handler;
	wire [2 : 0] flags;
	wire [INPUT_SQRT_M_SIZE - 1 : 0] main_module_in_num, main_module_out_num;

	input_wrapper #(.OUT_M_SIZE(INPUT_SQRT_M_SIZE), .IN_M_SIZE(INPUT_MODULE_M_SIZE), .EXP_SIZE(EXP_SIZE))
		Input_wrapper(.clk(clk), .rst(rst), .in_exp(in_exp), .in_flags(in_flags), .in_mantisa(in_mantisa), .in_type(in_type), .start(start), .ready(ready)
		, .sign(in_sign), .out_exp(in_exp_handler), .out_flags(flags), .out_mantisa(main_module_in_num), .out_type(type), .start_sqrt(start_sqrt));

	sqrt #(.SIZE(INPUT_SQRT_M_SIZE)) Main_module(.clk(clk), .rst(rst), .start(start_sqrt), .num(main_module_in_num), .ready(ready), .out(main_module_out_num));

	exponent_handler #(.SIZE(EXP_SIZE)) Exponent_handler(.type(type), .exp(in_exp_handler), .out_exp(out_exp_handler));

	assign out_ready = ready;

	output_wrapper #(.M_SIZE(INPUT_MODULE_M_SIZE), .EXP_SIZE(EXP_SIZE))
		Output_wrapper(.in_mantisa(main_module_out_num[INPUT_MODULE_M_SIZE - 1 : 0]), .in_exp(out_exp_handler)
		, .in_flags(flags), .out_mantisa(out_mantisa), .out_exp(out_exp), .out_sign(out_sign));

endmodule