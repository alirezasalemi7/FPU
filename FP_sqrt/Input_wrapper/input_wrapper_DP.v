`include "multiplexer.v"
`include "register_sqrt.v"

module input_wrapper_DP(clk, rst, in_type, in_exp, in_mantisa, start, ready, sign, ld_reg, in_flags, out_type, out_exp, out_mantisa, out_flags, run);
/*
input wrapper of the sqrt unit:
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
		ld_reg: load signal of the registers (a control signal)
		sign: input sign, 0 indicates positive and 1 indicates negative
		start and ready: handshaking signals
	outputs:
		run: a status signal indicating whether or not to run the controller
		out_exp: output exponent
		out_flags: output flags, same as input flags
		out_mantisa: output mantissa
		out_type: output type, same as in_type
		start_sqrt: a status signal indicating whether or not to run the main module
*/


parameter OUT_M_SIZE = 106;
parameter IN_M_SIZE = 53;
parameter EXP_SIZE = 11;
input in_type, start, ready, sign, ld_reg, clk, rst;
input [EXP_SIZE - 1 : 0] in_exp;
input [2 : 0] in_flags;
input [IN_M_SIZE - 1 : 0] in_mantisa;
output out_type, run;
output [2 : 0] out_flags;
output [EXP_SIZE - 1 : 0] out_exp;
output [OUT_M_SIZE - 1 : 0] out_mantisa;
	// preparing mantisa
	wire [OUT_M_SIZE - 1 : 0] single_out_mux, double_out_mux, mantisa_reg_in;
	multiplexer #(.SIZE(OUT_M_SIZE)) Single_MUX(.first_value({29'b0, in_mantisa, 24'b0}), .second_value({30'b0, in_mantisa, 23'b0}), .select(in_exp[0]), .out(single_out_mux));
	multiplexer #(.SIZE(OUT_M_SIZE)) Double_MUX(.first_value({in_mantisa, 53'b0}), .second_value({1'b0, in_mantisa, 52'b0}), .select(in_exp[0]), .out(double_out_mux));
	multiplexer #(.SIZE(OUT_M_SIZE)) Total_MUX(.first_value(single_out_mux), .second_value(double_out_mux), .select(in_type), .out(mantisa_reg_in));
	register_sqrt #(.SIZE(OUT_M_SIZE)) mantis_register(.clk(clk), .rst(rst), .ld(ld_reg), .din(mantisa_reg_in), .qout(out_mantisa));
	register_sqrt #(.SIZE(EXP_SIZE)) exponent_register(.clk(clk), .rst(rst), .ld(ld_reg), .din(in_exp), .qout(out_exp));
	// generating run signal
	assign run = &{start, ready, ~sign, in_flags[2], ~(in_flags[1] | in_flags[0])};
	// preparing other outputs
	assign out_flags = {sign, sign, sign} | in_flags;
	assign out_type = in_type;


endmodule