`include "header.h"
`include "input_interface.v"
`include "register_sqrt.v"
`include "fp_sqrt.v"
`include "output_interface.v"
`include "multiplexer.v"
`include "wrapper.v"

module FPU_DP(clk, rst, operation_load, sqrt_start, div_start, inpA, inpB, operation, res, ready);

    input clk, rst, operation_load, sqrt_start, div_start;
    input [`REG_SIZE-1:0] inpA, inpB;
    input [`OP_BITS-1:0] operation;
    output [`REG_SIZE-1:0] res;
    output ready;

    wire [`INPUT_INTERFACE_INT_OUT - 1 : 0] outA, outB;
    wire [`INPUT_INTERFACE_EXP_OUT - 1 : 0] expA, expB;
    wire [`OP_BITS - 1 : 0] op, opOut;
    wire [2 : 0] flagsA, flagsB;
    wire signA, signB;
    wire sqrtReady, divideReady;

    wire [`OUTPUT_INTERFACE_INT_IN - 1 : 0] sqrt_mantisa_out,intA_output_interface,div_mantisa_out;
	wire [`OUTPUT_INTERFACE_EXP_IN - 1 : 0] sqrt_exp_out,expA_output_interface,div_exp_out;
	wire sqrt_sign_out,div_sign_out,signA_output_interface;

    // input interface
    input_interface inputInterface(.inpA(inpA), .inpB(inpB), .operation(operation), .outA(outA), .outB(outB), .expA(expA), .expB(expB), .signA(signA), .signB(signB), .flagsA(flagsA), .flagsB(flagsB), .op(op));

    // operation register
    register_sqrt #(2) operationRegister(.clk(clk), .rst(rst), .ld(operation_load), .din(op), .qout(opOut));

    // sqrt
    fp_sqrt Fp_sqrt(.in_mantisa(outA), .in_exp(expA), .in_sign(signA), .in_type(opOut[1]), .in_flags(flagsA), .start(sqrt_start), .rst(rst), .clk(clk), .out_mantisa(sqrt_mantisa_out), .out_exp(sqrt_exp_out), .out_sign(sqrt_sign_out),.out_ready(sqrtReady));

    // divide
    wrapper fp_divide(.clk(clk), .rst(rst), .start(div_start), .inputA(outA), .inputB(outB), .exponentA(expA), .exponentB(expB), .sgnA(signA), .sgnB(signB), .modeBit(opOut[1]), .flgA(flagsA), .flgB(flagsB), .res(div_mantisa_out), .exponent(div_exp_out), .sgn(div_sign_out), .finished(divideReady));

    // ouput interface
    multiplexer #(53) intASrc(.first_value(div_mantisa_out), .second_value(sqrt_mantisa_out), .select(opOut[0]), .out(intA_output_interface));
    multiplexer #(11) expAsrc(.first_value(div_exp_out), .second_value(sqrt_exp_out), .select(opOut[0]), .out(expA_output_interface));
    multiplexer #(1) signAsrc(.first_value(div_sign_out), .second_value(sqrt_sign_out), .select(opOut[0]), .out(signA_output_interface));

    output_interface outputInterface(.mode(opOut[1]),.intA(intA_output_interface),.expA(expA_output_interface),.signA(signA_output_interface),.outA(res));

    assign ready = sqrtReady & divideReady & ~sqrt_start & ~div_start;

endmodule