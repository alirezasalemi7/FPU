`include "../defs/header.h"

module OutputInterface(mode,intA,intB,expA,expB,signA,signB,nanA,nanB,infA,infB,errA,errB,outA,outB,err);

    /*
        OutputInterface
        this module used to take result of other parts in specific format and convert it
        to IEEE754 format.
    */
    output err;                                             // if error occured during operation this will be set to 1
    output reg [`REG_SIZE-1:0] outA,outB;                          // outputs in IEEE754 format
    input mode;                                             // type of operation : S or D
    input[`OUTPUT_INTERFACE_INT_IN-1:0] intA,intB;            // integer part of A and B
    input[`OUTPUT_INTERFACE_EXP_IN-1:0] expA,expB;            // exponent of A and B
    input signA,signB,nanA,nanB,infA,infB,errA,errB;        // some control signals
    /*
        sign -> 0 for + | 1 for -
        inf -> 1 if inf 0 if finite 
        note: if sign == 1 -> -inf else +inf
        zero -> 1 if input is 0
        nan -> 1 if input is not a number
        normal -> if input is normal number
    */

    //err
    assign err = errA | errB;

    // outA
    always@(*)begin
        if(nanA)begin
            if(mode==`S_MODE)begin
                outA = {signA,8'b11111111,23'b1};
            end
            else begin
                outA = {signA,11'b11111111111,52'b1};
            end
        end
        else if(infA)begin
            if(mode==`S_MODE)begin
                outA = {signA,8'b11111111,23'b0};
            end
            else begin
                outA = {signA,11'b11111111111,52'b0};
            end
        end
        else begin
            if(mode==`S_MODE)begin
                outA = {signA,expA[`MODE_S_EXP_SIZE-1:0],intA[`MODE_S_MAN_START:0]};
            end
            else begin
                outA = {signA,expA,intA[`MODE_D_EXP_END-1:0]};
            end 
        end
    end
    
    // outB
    always@(*)begin
        if(nanB)begin
            if(mode==`S_MODE)begin
                outB = {signB,8'b11111111,23'b1};
            end
            else begin
                outB = {signB,11'b11111111111,52'b1};
            end
        end
        else if(infB)begin
            if(mode==`S_MODE)begin
                outB = {signB,8'b11111111,23'b0};
            end
            else begin
                outB = {signB,11'b11111111111,52'b0};
            end
        end
        else begin
            if(mode==`S_MODE)begin
                outB = {signB,expB[`MODE_S_EXP_SIZE-1:0],intB[`MODE_S_MAN_START:0]};
            end
            else begin
                outB = {signB,expB,intB[`MODE_D_EXP_END-1:0]};
            end 
        end
    end
    
endmodule