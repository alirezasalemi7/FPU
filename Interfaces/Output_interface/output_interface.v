`include "header.h"

module output_interface(mode,intA,expA,signA,outA);

    /*
        output_interface
        this module gathers the result of other parts in a specific format and converts it
        to IEEE754 format.
    */
    output reg [`REG_SIZE-1:0] outA;                          // output in IEEE754 format
    input mode;
                                                        /* type of operation :
                                                        0 indicates single precision and 1 indicates double precision
                                                        */
    input[`OUTPUT_INTERFACE_INT_IN-1:0] intA;            // integer part of A and B
    input[`OUTPUT_INTERFACE_EXP_IN-1:0] expA;            // exponent of A and B
    input signA;                      // sign: 0 indicates positive and 1 indicates negative
    // outA
    always @(*) begin
        if (mode==`S_MODE) begin
            outA = {signA,expA[`MODE_S_EXP_SIZE-1:0],intA[`MODE_S_MAN_START:0]};
        end
        else begin
            outA = {signA,expA,intA[`MODE_D_EXP_END-1:0]};
        end
    end

endmodule