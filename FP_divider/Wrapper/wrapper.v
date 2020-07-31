`include "header.h"
`include "div_wrapper_DP.v"
`include "div_wrapper_CU.v"

module wrapper(clk, rst, start, inputA, inputB, exponentA, exponentB, sgnA, sgnB, modeBit, flgA, flgB, res, exponent, sgn, finished);
    
    /*
        wrapper
        this module work as a wrapper for divider
        connect div_wrapper_CU to div_wrapper_Dp.
    */
    
    input clk, rst;
    input[`INPUT_INTERFACE_INT_OUT-1:0] inputA, inputB;
    input[`INPUT_INTERFACE_EXP_OUT-1:0] exponentA,exponentB;
    input start; // start signal come from FPU and start division.
    input modeBit; // 0 for single precision and 1 for double precision.
    input[2:0] flgA, flgB;
    input sgnA,sgnB;

    output[`INPUT_INTERFACE_INT_OUT-1:0] res;
    output[`INPUT_INTERFACE_EXP_OUT-1:0] exponent;
    output sgn;
    output finished; // finish go to main module and show finishing the divishion.

    wire ld, divideReady;

    div_wrapper_CU cu(.clock(clk), .reset(rst), .startOp(start), .readyDiv(divideReady), .load(ld), .finishOp(finished));

    div_wrapper_DP DP(.clock(clk), .reset(rst), .ldin(ld), .inA(inputA), .inB(inputB), .expA(exponentA),
     .expB(exponentB), .signA(sgnA), .signB(sgnB), .mode(modeBit), .flagsA(flgA), .flagsB(flgB), .result(res)
     , .exp(exponent), .sign(sgn), .ready(divideReady));

endmodule