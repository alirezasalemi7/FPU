`include "sqrt_CU.v"
`include "sqrt_DP.v"

module sqrt(clk , rst, start, num, ready, out);
/*
This unit calculates square root (for integer numbers):
	out = sqrt(num)
inputs:
	clk and rst: clock and asynchronous reset
	start: A signal that is used for starting the operation (it is a handshaking signal)
	num: input number
outputs:
	out: square root of num
	ready: A signal indicating that the output is ready
*/
	parameter SIZE = 32;
	input clk, rst, start;
	input [SIZE - 1 : 0] num;
	output ready;
	output [SIZE - 1 : 0] out;

	wire finished, select, ld, ld_out;

	sqrt_DP #(SIZE) Datapath(.in_num(num), .res(out), .ld(ld), .ld_out(ld_out)
							, .mux_select(select), .finished(finished), .clk(clk), .rst(rst));
	sqrt_CU Controller(.start(start), .finished(finished), .ld(ld), .ld_out_reg(ld_out)
						, .select(select), .ready(ready), .clk(clk), .rst(rst));
endmodule