`include "sqrt_unit.v"
`include "first_one_finder.v"
`include "multiplexer.v"
`include "register.v"

module SQRT_DP(num0, res_reg, ld, mux_select, finished, clk, rst);
parameter SIZE = 32;
input mux_select, ld clk, rst;
input [SIZE - 1 : 0] num0;
output [SIZE - 1 : 0] res;
output finished;

wire [SIZE - 1 : 0] res0, res1, res2, res3, res4
					, num_reg, num1, num2, num3
					, max_power_reg, max_power0, max_power1, max_power2, max_power3
					;


assign res0 = SIZE'b0;

first_one_finder #(SIZE) FOF(.number(num0), .max_power(max_power0));
multiplexer #(SIZE) num_mux(.first_value(num_reg), .second_value(num0), .select(mux_select), .out(num1));
multiplexer #(SIZE) res_mux(.first_value(res_reg), .second_value(res0), .select(mux_select), .out(res1));
multiplexer #(SIZE) max_power_mux(.first_value(max_power_reg), .second_value(max_power0), .select(mux_select), .out(max_power1));

sqrt_unit #(SIZE) sqrt_level1(.prev_result(res1), .prev_num(num1), .prev_biggest_power(max_power1),
					.cur_result(res2), .cur_num(num2), .cur_biggest_power(max_power2));
sqrt_unit #(SIZE) sqrt_level2(.prev_result(res2), .prev_num(num2), .prev_biggest_power(max_power2),
					.cur_result(res3), .cur_num(num3), .cur_biggest_power(max_power3));

assign finished = |max_power3;

register #(SIZE) result_reg(.clk(clk), .rst(rst), .ld(ld), .din(res4), .qout(res_reg));
register #(SIZE) max_power_reg(.clk(clk), .rst(rst), .ld(ld), .din(max_power3), .qout(max_power_reg));
register #(SIZE) num_reg(.clk(clk), .rst(rst), .ld(ld), .din(), .qout(num_reg));

endmodule



register(.clk(clk), .rst(rst), .ld(ld), .din(), .qout());