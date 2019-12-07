
`include "InputInterface.v"
`include "header.h"
`define NUM_OF_TEST 512 

/*
To run this TB in your Modelsim, first config this by right click on file and 
go to properties -> Verliog & System verilog -> Other Verilog Options
Here click "Include Directory..." button and add all folders of your include files.
*/

//alireza

module TB_ii();
    reg[`REG_SIZE-1:0] inpA,inpB;
    reg[`OP_BITS-1:0] operation;
    wire[`INPUT_INTERFACE_INT_OUT-1:0] outA,outB;
    wire[`INPUT_INTERFACE_EXP_OUT-1:0] expA,expB;
    wire[`OP_BITS-1:0] op;
    wire signA,signB;
    wire[2:0] flagsA, flagsB;
    integer f,i;
    InputInterface ii(inpA,inpB,operation,outA,outB,expA,expB,signA,signB,flagsA,flagsB,op);

    initial begin
        f = $fopen("output_ii.csv","w");
        $fwrite(f,"inputA,inputB,ops_in,intA,intB,expA,expB,signA,signB,flagsA,flagsB,ops_out\n");
        for (i = 0; i<`NUM_OF_TEST+1; i=i+1) begin
            $fwrite(f,"%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n",inpA,inpB,operation,outA,outB,expA,expB,signA,signB,flagsA,flagsB,op);
            if(i<`NUM_OF_TEST/2)begin
                inpA = $random()%32;
                inpB = $random()%32;
                operation = 2'b00;
            end
            else begin
                inpA = $random()%64;
                inpB = $random()%64;
                operation = 2'b10;
            end
            #100;
        end
        // special cases
        inpA = 32'b01111111100000000000000000000000;
        inpB = 32'b01111111100000000000000000000100;
        operation = 2'b00;
        #100
        $fwrite(f,"%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n",inpA,inpB,operation,outA,outB,expA,expB,signA,signB,flagsA,flagsB,op);
        inpA = 32'b0111111111110000000000000000000000000000000000010000000000000000;
        inpB = 32'b0111111111110000000000000000000000000000000000000000000000000000;
        operation = 2'b10;
        #100
        $fwrite(f,"%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n",inpA,inpB,operation,outA,outB,expA,expB,signA,signB,flagsA,flagsB,op);
    end

    
endmodule