`include "header.h"


module input_interface(inpA, inpB, operation, outA, outB, expA, expB, signA, signB, flagsA, flagsB, op);

    /*
        input_interface
        this module decodes the input (an IEEE754 number) and sends proper signals to other modules
    */

    input [`REG_SIZE-1:0] inpA,inpB;      // input num A,B; in sqrt just A has value but in divide both have
    input [`OP_BITS-1:0] operation;       // the operation that should be done
    output [`INPUT_INTERFACE_INT_OUT-1:0] outA,outB;      // the integer value of input A,B
    output [`INPUT_INTERFACE_EXP_OUT-1:0] expA,expB;      // the exponent of A,B
    output [`OP_BITS-1:0] op;     // the operation that should be done
    output [2 : 0] flagsA, flagsB;
    output signA,signB;
    /*
      sign: 0 indicates positive and 1 indicates negative

    flags:
      00 -> denormal
      01 -> zero
      10 -> inf
      11 -> nan
      100 -> input is normal
    */
    // out op
    assign op = operation;

    // signs
    assign signA = (operation[1]==`S_MODE) ? inpA[`MODE_S_SIGN_BIT] : inpA[`MODE_D_SIGN_BIT];
    assign signB = (operation[1]==`S_MODE) ? inpB[`MODE_S_SIGN_BIT] : inpB[`MODE_D_SIGN_BIT];

  // flags
  assign flagsA = (operation[1] == `S_MODE) ?
          ( //single
            (inpA[`MODE_S_EXP_START : 0] == 0) ? 3'b01 : //zero
            (inpA[`MODE_S_EXP_START : `MODE_S_EXP_END] == 8'b11111111) & (inpA[`MODE_S_MAN_START : `MODE_S_MAN_END] == 0) ? 3'b10 : //inf
            (inpA[`MODE_S_EXP_START : `MODE_S_EXP_END] == 8'b11111111) & (inpA[`MODE_S_MAN_START : `MODE_S_MAN_END] != 0) ? 3'b11 : //nan
            (inpA[`MODE_S_EXP_START : `MODE_S_EXP_END] == 0) ? 3'b00 : 3'b100 //denormal : normal
          ) : ( //double
            (inpA[`MODE_D_EXP_START : 0] == 0) ? 3'b01 : //zero
            (inpA[`MODE_D_EXP_START : `MODE_D_EXP_END] == 11'b11111111111) & (inpA[`MODE_D_MAN_START : `MODE_D_MAN_END] == 0) ? 3'b10 : //inf
            (inpA[`MODE_D_EXP_START : `MODE_D_EXP_END] == 11'b11111111111) & (inpA[`MODE_D_MAN_START : `MODE_D_MAN_END] != 0) ? 3'b11 : //nan
            (inpA[`MODE_D_EXP_START : `MODE_D_EXP_END] == 0) ? 3'b00 : 3'b100 //denormal : normal
          );
  assign flagsB = (operation[1] == `S_MODE) ?
          ( //single
            (inpB[`MODE_S_EXP_START : 0] == 0) ? 3'b01 : //zero
            (inpB[`MODE_S_EXP_START : `MODE_S_EXP_END] == 8'b11111111) & (inpB[`MODE_S_MAN_START : `MODE_S_MAN_END] == 0) ? 3'b10 : //inf
            (inpB[`MODE_S_EXP_START : `MODE_S_EXP_END] == 8'b11111111) & (inpB[`MODE_S_MAN_START : `MODE_S_MAN_END] != 0) ? 3'b11 : //nan
            (inpB[`MODE_S_EXP_START : `MODE_S_EXP_END] == 0) ? 3'b00 : 3'b100 //denormal : normal
          ) : ( //double
            (inpB[`MODE_D_EXP_START : 0] == 0) ? 3'b01 : //zero
            (inpB[`MODE_D_EXP_START : `MODE_D_EXP_END] == 11'b11111111111) & (inpB[`MODE_D_MAN_START : `MODE_D_MAN_END] == 0) ? 3'b10 : //inf
            (inpB[`MODE_D_EXP_START : `MODE_D_EXP_END] == 11'b11111111111) & (inpB[`MODE_D_MAN_START : `MODE_D_MAN_END] != 0) ? 3'b11 : //nan
            (inpB[`MODE_D_EXP_START : `MODE_D_EXP_END] == 0) ? 3'b00 : 3'b100 //denormal : normal
          );

    //exp
    assign expB = (operation[1] == `S_MODE) ? inpB[`MODE_S_EXP_START : `MODE_S_EXP_END] : inpB[`MODE_D_EXP_START : `MODE_D_EXP_END];
    assign expA = (operation[1] == `S_MODE) ? inpA[`MODE_S_EXP_START : `MODE_S_EXP_END] : inpA[`MODE_D_EXP_START : `MODE_D_EXP_END];

    //ints
    assign outA = (operation[1] == `S_MODE) ? {20'b0, |{inpA[`MODE_S_EXP_START : `MODE_S_EXP_END]}, inpA[`MODE_S_MAN_START : 0]} : {|{inpA[`MODE_D_EXP_START : `MODE_D_EXP_END]}, inpA[`MODE_D_MAN_START : 0]};
    assign outB = (operation[1] == `S_MODE) ? {20'b0, |{inpB[`MODE_S_EXP_START : `MODE_S_EXP_END]}, inpB[`MODE_S_MAN_START : 0]} : {|{inpB[`MODE_D_EXP_START : `MODE_D_EXP_END]}, inpB[`MODE_D_MAN_START : 0]};

endmodule