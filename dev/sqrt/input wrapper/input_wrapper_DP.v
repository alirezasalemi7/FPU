`include "multiplexer.v"
`include "register.v"

module input_wrapper_DP(clk, rst, in_type, in_exp, in_mantisa, start, ready, sign, ld_reg, in_flags, out_type, out_exp, out_mantisa, out_flags, run);
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
	register #(.SIZE(OUT_M_SIZE)) Register(.clk(clk), .rst(rst), .ld(ld_reg), .din(mantisa_reg_in), .qout(out_mantisa));
	// generating run signal
	assign run = &{start, ready, ~sign, in_flags[2], ~(in_flags[1] | in_flags[0])};
	// preparing other outputs
	assign out_flags = {sign, sign, sign} | in_flags;
	assign out_exp = in_exp;
	assign out_type = in_type;


endmodule