`include "SQRT_CU.v"
`include "SQRT_DP.v"

module SQRT(clk , rst, start, num, ready, out);
	parameter SIZE = 32;
	input clk, rst, start;
	input [SIZE - 1 : 0] num;
	output ready;
	output [SIZE - 1 : 0] out;

	wire finished, select, ld, ld_out;

	SQRT_DP #(SIZE) Datapath(.in_num(num), .res(out), .ld(ld), .ld_out(ld_out)
							, .mux_select(select), .finished(finished), .clk(clk), .rst(rst));
	SQRT_CU Controller(.start(start), .finished(finished), .ld(ld), .ld_out_reg(ld_out)
							, .select(select), .ready(ready), .clk(clk), .rst(rst));
endmodule