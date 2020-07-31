`include "header.h"
`include "FPU_CU.v"
`include "FPU_DP.v"

module FPU(clk, rst, start, inpA, inpB, operation, res, ready);
	input clk, rst, start;
	input [`REG_SIZE-1:0] inpA, inpB;
    input [`OP_BITS-1:0] operation;
    output [`REG_SIZE-1:0] res;
    output ready;

	wire operation_load, sqrt_start, div_start, operation_ready;
	FPU_DP DP(.clk(clk), .rst(rst), .operation_load(operation_load), .sqrt_start(sqrt_start), .div_start(div_start)
				, .inpA(inpA), .inpB(inpB), .operation(operation), .res(res), .ready(operation_ready));
	FPU_CU CU(.clk(clk), .rst(rst), .operation(operation[0]), .operation_ready(operation_ready), .start(start)
				, .operation_load(operation_load), .sqrt_start(sqrt_start), .div_start(div_start), .ready(ready));
endmodule