`include "header.h"

`define REPEAT 100

module wrapperTB();
    reg clock, reset;
    reg[`INPUT_INTERFACE_INT_OUT-1:0] dividend, divisor;
    reg[`INPUT_INTERFACE_EXP_OUT-1:0] expA,expB;
    reg startOp, mode;
    reg[2:0] flagsA, flagsB;
    reg signA,signB;
    wire[`INPUT_INTERFACE_INT_OUT-1:0] result;
    wire[`INPUT_INTERFACE_EXP_OUT-1:0] exp;
    wire sign, ready;

    integer f;
    reg [50:0] temp;

    wrapper UUT1(
        .clk        (clock),
        .rst        (reset),
        .start      (startOp),
        .inputA     (dividend),
        .inputB     (divisor),
        .exponentA  (expA),
        .exponentB  (expB),
        .sgnA       (signA),
        .sgnB       (signB),
        .modeBit    (mode),
        .flgA       (flagsA),
        .flgB       (flagsB),
        .res        (result),
        .exponent   (exp),
        .sgn        (sign),
        .finished   (ready)
    );

    always  #10 clock = ~clock;
    initial begin
        clock = 1'b0;
        reset = 1'b0;
        #1
        reset = 1'b1;
        #1
        reset = 1'b0;
        #1
        dividend = 53'b0;
        divisor = 53'b0;
        signA = 1'b0;
        signB = 1'b1;
        f = $fopen("wrapperTB.csv", "w");
        $fwrite(f, "dividend, divisor, signA, signB, falgA, flagB, result, exp, sign\n");
        #200
        flagsA = 3'b001;
        flagsB = 3'b001;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b001;
        flagsB = 3'b100;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b001;
        flagsB = 3'b010;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b001;
        flagsB = 3'b011;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b010;
        flagsB = 3'b001;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b010;
        flagsB = 3'b100;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b010;
        flagsB = 3'b010;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b010;
        flagsB = 3'b011;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b011;
        flagsB = 3'b001;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b011;
        flagsB = 3'b100;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b011;
        flagsB = 3'b010;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b011;
        flagsB = 3'b011;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b100;
        flagsB = 3'b001;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b100;
        flagsB = 3'b010;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        flagsA = 3'b100;
        flagsB = 3'b011;
        #10
        $fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b\n", dividend, divisor, signA, signB, flagsA, flagsB, result, exp, sign);
        #20
        $fclose(f);      
    end
    
endmodule