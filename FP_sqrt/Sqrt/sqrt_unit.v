`include "comparator.v"
`include "eraser.v"
`include "multiplexer.v"
`include "subtractor.v"


module sqrt_unit(prev_result, prev_num, prev_biggest_power, cur_result, cur_num, cur_biggest_power);
/*
	sqrt_unit
	this module is used as a building block for sqrt, it calculates one bit of sqrt of prev_num
	and stores it in cur_result
	inputs:
		prev_num: The number that the module should calculate one bit of its sqrt
		prev_biggest_power: The biggest power of 4 that is less than prev_num (based on the algorithm, we need this to calculate sqrt)
		prev_result: previous result; this module appends the new calculated bit to the end of this number
	outputs:
		cur_num: Updated number after calculation
		cur_biggest_power: The biggest power of 4 that is less than cur_num
		cur_result: Updated result after appending the last calculated bit to prev_result
*/
parameter SIZE = 32;
input [SIZE - 1 : 0] prev_result, prev_num, prev_biggest_power;
output [SIZE - 1 : 0] cur_result, cur_num, cur_biggest_power;

wire [SIZE - 1 : 0] sum, sub_result, erased, middle_result;
wire equal, greater, lower, equal_or_greater, res_select;

assign sum = prev_biggest_power | prev_result;
comparator #(.SIZE(SIZE)) Comparator(.a(prev_num), .b(sum), .greater(greater), .equal(equal), .lower(lower));
assign equal_or_greater = equal | greater;
subtractor #(.SIZE(SIZE)) Subtactor(.a(prev_num), .b(sum), .res(sub_result));
multiplexer #(.SIZE(SIZE)) Mux(.first_value(prev_num), .second_value(sub_result), .select(equal_or_greater), .out(cur_num));
eraser #(.SIZE(SIZE)) Eraser(.value(prev_biggest_power), .erase(equal_or_greater), .result(erased));
assign middle_result = erased | {1'b0, prev_result[SIZE - 1 : 1]};
assign res_select = |prev_biggest_power;
multiplexer #(.SIZE(SIZE)) Result_mux(.first_value(prev_result), .second_value(middle_result), .select(res_select), .out(cur_result));
assign cur_biggest_power = {2'b0, prev_biggest_power[SIZE - 1 : 2]};

endmodule // sqrt_unit