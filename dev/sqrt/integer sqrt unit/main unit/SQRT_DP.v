`include "sqrt_unit.v"
`include "first_one_finder.v"
`include "multiplexer.v"
`include "register.v"

module SQRT_DP(in_num, res, ld, ld_out, mux_select, finished, clk, rst);
parameter SIZE = 32;
input mux_select, ld, ld_out, clk, rst;
input [SIZE - 1 : 0] in_num;
output [SIZE - 1 : 0] res;
output finished;

/*
	DataPath
	It has 3 parts described below:
		MUXes -> they play the role of entry gates of registers and used to
				select which one should be stored, inputs or previous calculations
		REGs -> They store the result of previous evaluations or input values
		sqrt units -> They're used to calculate sqrt, each unit calculates 1 bit of answer and because of
				clock cycle limits, we used 6 level of this unit
*/

wire [SIZE - 1 : 0] res_reg, in_res, res0, res1, res2, res3, res4, res5, res6
					, num_reg, num0, num1, num2, num3, num4, num5, num6
					, max_power_reg, in_max_power, max_power0, max_power1, max_power2
					, max_power3, max_power4, max_power5, max_power6
					;


assign in_res = 0;

first_one_finder #(SIZE) FOF(.number(in_num), .max_power(in_max_power));
multiplexer #(SIZE) res_mux(.first_value(res6), .second_value(in_res), .select(mux_select), .out(res0));
multiplexer #(SIZE) num_mux(.first_value(num6), .second_value(in_num), .select(mux_select), .out(num0));
multiplexer #(SIZE) max_power_mux(.first_value(max_power6), .second_value(in_max_power), .select(mux_select), .out(max_power0));

register #(SIZE) result_reg(.clk(clk), .rst(rst), .ld(ld), .din(res0), .qout(res_reg));
register #(SIZE) number_reg(.clk(clk), .rst(rst), .ld(ld), .din(num0), .qout(num_reg));
register #(SIZE) power_reg(.clk(clk), .rst(rst), .ld(ld), .din(max_power0), .qout(max_power_reg));

sqrt_unit #(SIZE) sqrt_level1(.prev_result(res_reg), .prev_num(num_reg), .prev_biggest_power(max_power_reg),
					.cur_result(res1), .cur_num(num1), .cur_biggest_power(max_power1));
sqrt_unit #(SIZE) sqrt_level2(.prev_result(res1), .prev_num(num1), .prev_biggest_power(max_power1),
					.cur_result(res2), .cur_num(num2), .cur_biggest_power(max_power2));
sqrt_unit #(SIZE) sqrt_level3(.prev_result(res2), .prev_num(num2), .prev_biggest_power(max_power2),
					.cur_result(res3), .cur_num(num3), .cur_biggest_power(max_power3));
sqrt_unit #(SIZE) sqrt_level4(.prev_result(res3), .prev_num(num3), .prev_biggest_power(max_power3),
					.cur_result(res4), .cur_num(num4), .cur_biggest_power(max_power4));
sqrt_unit #(SIZE) sqrt_level5(.prev_result(res4), .prev_num(num4), .prev_biggest_power(max_power4),
					.cur_result(res5), .cur_num(num5), .cur_biggest_power(max_power5));
sqrt_unit #(SIZE) sqrt_level6(.prev_result(res5), .prev_num(num5), .prev_biggest_power(max_power5),
					.cur_result(res6), .cur_num(num6), .cur_biggest_power(max_power6));

assign finished = ~(|max_power6);

register #(SIZE) out_reg(.clk(clk), .rst(rst), .ld(ld_out), .din(res_reg), .qout(res));

endmodule