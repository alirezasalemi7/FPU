`include "header.h"
`include "divider.v"
`include "register_sqrt.v"

module div_wrapper_DP(clock, reset, ldin, inA, inB, expA, expB, signA, signB, mode, flagsA, flagsB, result, exp, sign, ready);

    /*
        div_wrapper_DP
        this module is the datapath of the wrapper
    */

    input clock, reset;
    input[`INPUT_INTERFACE_INT_OUT-1:0] inA, inB; //inA and inB are the mantissas of the dividend and the divisor, respectively
    input[`INPUT_INTERFACE_EXP_OUT-1:0] expA,expB; //expA and expB are the exponents of the dividend and the divisor, respectively
    input mode; //0 indicates single precision and 1 indicates double precision
    input[2:0] flagsA, flagsB;
    input signA,signB,ldin;
    /*
        sign: 0 indicates positive and 1 indicates negative

    flags:
      00 -> denormal
      01 -> zero
      10 -> inf
      11 -> nan
      100 -> input is normal

    ldin: the load signal of the registers
    */

    output[`INPUT_INTERFACE_INT_OUT-1:0] result;
    output[`INPUT_INTERFACE_EXP_OUT-1:0] exp;
    output sign, ready; // sign: the sign of the output, ready: is issued when the operation is done

    wire[`INPUT_INTERFACE_INT_OUT*2-1:0] initCounter, dividend, divisor, QO, RO;
    wire[`INPUT_INTERFACE_EXP_OUT - 1 : 0] expA_reg_out, expB_reg_out;

// Input wrapper

    register_sqrt #(`INPUT_INTERFACE_EXP_OUT) expA_reg(.clk(clock), .rst(reset), .ld(ldin), .din(expA), .qout(expA_reg_out));
    register_sqrt #(`INPUT_INTERFACE_EXP_OUT) expB_reg(.clk(clock), .rst(reset), .ld(ldin), .din(expB), .qout(expB_reg_out));
    assign initCounter = ldin ? ((mode == 1'b0) ? 106'b110000: 106'b1101010) : 0;


    assign dividend = (mode == 1'b0) ? ({inA[`MODE_S_EXP_END:0], 82'b0})
        : ((mode == 1'b1) ? {inA[`MODE_D_EXP_END:0], 53'b0} : 106'b0);
    assign divisor = (mode == 1'b0) ? ({82'b0, inB[`MODE_S_EXP_END:0]})
        : ((mode == 1'b1) ? {53'b0, inB[`MODE_D_EXP_END:0]} : 106'b0);


    divider #(106) M1(clock, reset, initCounter, ldin, dividend, divisor, QO, RO, ready);


// Output wrapper
    wire[`INPUT_INTERFACE_INT_OUT-1:0] tempResult;
    wire[`INPUT_INTERFACE_EXP_OUT + 1:0] tempExp;

    assign tempResult = (mode) ?
                            ((QO[53]) ? QO[53 : 1] : QO[52 : 0])
                            : ((QO[24]) ? QO[53 : 1] : QO[52 : 0]);

    wire nan, zero, inf, underflow, overflow;

    assign nan = ((flagsA == 3'b001) && (flagsB == 3'b001)) || ((flagsA == 3'b010) && (flagsB == 3'b010)) || (flagsA == 3'b011) || (flagsB == 3'b011);
    assign zero = nan ? 0 : (flagsA == 3'b001) || (flagsB == 3'b010);
    assign inf = nan ? 0: ((flagsB == 3'b001) || (flagsA == 3'b010));

    wire[`INPUT_INTERFACE_EXP_OUT + 1:0] expShiftedA;
    assign expShiftedA = (mode == 1'b0) ? {13'b0000111111, QO[24]} : {13'b0111111111, QO[53]};
    assign tempExp = {2'b0, expA_reg_out} - {2'b0, expB_reg_out} + expShiftedA;
    assign overflow = (expA_reg_out > expB_reg_out) & ((~tempExp[12] & (mode ? tempExp[11] : tempExp[8])) | (mode ? &tempExp[10 : 0] : &tempExp[7 : 0]));
    assign underflow = (expA_reg_out < expB_reg_out) & (tempExp[12] | (tempExp == 13'b0));

    assign exp = nan ? `EXP_QNAN : (inf | overflow) ? `EXP_INF : (zero | underflow) ? `EXP_ZERO : tempExp[10 : 0];
    assign result = nan ? `M_QNAN : (zero | underflow) ? `M_ZERO : (inf | overflow) ? `M_INF : tempResult;


    assign sign = nan ? 1'b0 : signA ^ signB;

endmodule