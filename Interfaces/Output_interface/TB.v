
`include "output_interface.v"
`include "header.h"
`define NUM_OF_TEST 512 

/*
To run this TB in your Modelsim, first config this by right click on file and 
go to properties -> Verliog & System verilog -> Other Verilog Options
Here click "Include Directory..." button and add all folders of your include files.
*/

module TB_oi();
    wire [`REG_SIZE-1:0] outA;
    integer f,i;
    reg signA;
    reg[`OUTPUT_INTERFACE_INT_IN-1:0] intA;
    reg[`OUTPUT_INTERFACE_EXP_IN-1:0] expA;
    output_interface oi(mode,intA,expA,signA,outA);

    initial begin
        f = $fopen("output_oi.csv","w");
        $fwrite(f,"mode,intA,expA,signA,outA\n");
        for (i = 0; i<`NUM_OF_TEST+1; i=i+1) begin
            $fwrite(f,"%b,%b,%b,%b,%b\n",mode,intA,expA,signA,outA);
            if(i<`NUM_OF_TEST/2)begin
                mode = `S_MODE;
                intA = $random();
                expA = $random();
            end
            else begin
                mode = `D_MODE;
                intA = {$random(),$random()};
                expA = $random();
            end
            #100;
        end
    end
    
endmodule