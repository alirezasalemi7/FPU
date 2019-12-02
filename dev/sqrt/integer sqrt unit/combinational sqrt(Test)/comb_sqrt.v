`include "sqrt_unit.v"
`include "first_one_finder.v"

module comb_sqrt(value, sqrt);
/*
Its a combinationa sqrt just for test
*/
parameter SIZE = 4;
input [SIZE - 1 : 0] value;
output [SIZE - 1 : 0] sqrt;

wire [SIZE - 1 : 0] biggest_power1, biggest_power2, biggest_power3, biggest_power4
					, res1, res2, res3//	, res4
					, value1, value2, value3;

assign res1 = 0;
first_one_finder #(SIZE) FOF(.number(value), .max_power(biggest_power1));
sqrt_unit #(SIZE) su1(.prev_result(res1), .prev_num(value), .prev_biggest_power(biggest_power1),
					.cur_result(res2), .cur_num(value1), .cur_biggest_power(biggest_power2));
sqrt_unit #(SIZE) su2(.prev_result(res2), .prev_num(value1), .prev_biggest_power(biggest_power2),
					.cur_result(res3), .cur_num(value2), .cur_biggest_power(biggest_power3));
sqrt_unit #(SIZE) su3(.prev_result(res3), .prev_num(value2), .prev_biggest_power(biggest_power3),
					.cur_result(sqrt), .cur_num(value3), .cur_biggest_power(biggest_power4));
// assign sqrt = (|biggest_power2) ? (|biggest_power3) ? res4 : res3 : res2;


endmodule