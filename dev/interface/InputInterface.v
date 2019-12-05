`include "../defs/header.h"


module InputInterface(inpA,inpB,operation,outA,outB,expA,expB,signA,signB,infA,infB,zeroA,zeroB,nanA,nanB,normalA,normalB,op);

    /*
        InputInterface
        this module decode the input IEEE754 number and sends out signals that other module need for their works;
    */
    
    input[`REG_SIZE-1:0] inpA,inpB;      // input num A,B; in sqrt just A has value input but for divide both
    input[`OP_BITS-1:0] operation;       // ther operation that should be do
    output[`INPUT_INTERFACE_INT_OUT-1:0] outA,outB;      // the integer value of input A,B
    output[`INPUT_INTERFACE_EXP_OUT-1:0] expA,expB;      // the exponent of A,B
    output[`OP_BITS-1:0] op;     // operation that helps other module detect their works
    output signA,signB,infA,infB,zeroA,zeroB,nanA,nanB,normalA,normalB;
    /*
        sign -> 0 for + | 1 for -
        inf -> 1 if inf 0 if finite 
        note: if sign == 1 -> -inf else +inf
        zero -> 1 if input is 0
        nan -> 1 if input is not a number
        normal -> if input is normal number
    */
    // out op
    assign op = operation;
    
    // signals 
    assign signA = (operation[1]==`S_MODE) ? inpA[`MODE_S_SIGN_BIT] : inpA[`MODE_D_SIGN_BIT];
    assign signB = (operation[1]==`S_MODE) ? inpB[`MODE_S_SIGN_BIT] : inpB[`MODE_D_SIGN_BIT];
    assign infA = (operation[1]==`S_MODE) ? (inpA[`MODE_S_EXP_START:`MODE_S_EXP_END]==8'b11111111)&(inpA[`MODE_S_MAN_START:`MODE_S_MAN_END]==0):(inpA[`MODE_D_EXP_START:`MODE_D_EXP_END]==11'b11111111111)&(inpA[`MODE_D_MAN_START:`MODE_D_MAN_END]==0);
    assign infB = (operation[1]==`S_MODE) ? (inpB[`MODE_S_EXP_START:`MODE_S_EXP_END]==8'b11111111)&(inpB[`MODE_S_MAN_START:`MODE_S_MAN_END]==0):(inpB[`MODE_D_EXP_START:`MODE_D_EXP_END]==11'b11111111111)&(inpB[`MODE_D_MAN_START:`MODE_D_MAN_END]==0);
    assign zeroA = (operation[1]==`S_MODE) ? (inpA[`MODE_S_EXP_START:0]==0) : (inpA[`MODE_D_EXP_START:0]==0);
    assign zeroB = (operation[1]==`S_MODE) ? (inpB[`MODE_S_EXP_START:0]==0) : (inpB[`MODE_D_EXP_START:0]==0);
    assign nanA = (operation[1]==`S_MODE) ? (inpA[`MODE_S_EXP_START:`MODE_S_EXP_END]==8'b11111111)&(inpA[`MODE_S_MAN_START:`MODE_S_MAN_END]!=0):(inpA[`MODE_D_EXP_START:`MODE_D_EXP_END]==11'b11111111111)&(inpA[`MODE_D_MAN_START:`MODE_D_MAN_END]!=0);
    assign nanB = (operation[1]==`S_MODE) ? (inpB[`MODE_S_EXP_START:`MODE_S_EXP_END]==8'b11111111)&(inpB[`MODE_S_MAN_START:`MODE_S_MAN_END]!=0):(inpB[`MODE_D_EXP_START:`MODE_D_EXP_END]==11'b11111111111)&(inpB[`MODE_D_MAN_START:`MODE_D_MAN_END]!=0);
    assign normalA = (operation[1]==`S_MODE) ? (inpA[`MODE_S_EXP_START:`MODE_S_EXP_END]==0) : (inpA[`MODE_D_MAN_START:`MODE_D_MAN_END]==0);
    assign normalB = (operation[1]==`S_MODE) ? (inpB[`MODE_S_EXP_START:`MODE_S_EXP_END]==0) : (inpB[`MODE_D_MAN_START:`MODE_D_MAN_END]==0);
    
    //exp
    assign expA = (operation[1]==`S_MODE) ? inpA[`MODE_S_EXP_START:`MODE_S_EXP_END]: inpA[`MODE_D_EXP_START:`MODE_D_EXP_END];
    assign expB = (operation[1]==`S_MODE) ? inpB[`MODE_S_EXP_START:`MODE_S_EXP_END]: inpB[`MODE_D_EXP_START:`MODE_D_EXP_END];

    //ints
    assign outA = (operation[1]==`S_MODE) ? {20'b0,~normalA,inpA[`MODE_S_MAN_START:0]} : {~normalA,inpA[`MODE_D_MAN_START:0]};
    assign outB = (operation[1]==`S_MODE) ? {20'b0,~normalB,inpB[`MODE_S_MAN_START:0]} : {~normalB,inpB[`MODE_D_MAN_START:0]};

endmodule