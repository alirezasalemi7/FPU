
`include "InputInterface.v"
`include "header.h"
`define NUM_OF_TEST 512 

/*
To run this TB in your Modelsim, first config this by right click on file and 
go to properties -> Verliog & System verilog -> Other Verilog Options
Here click "Include Directory..." button and add all folders of your include files.
*/

//alireza

module TB_oi();
    wire err;
    wire[`REG_SIZE-1:0] outA,outB;                     
    reg mode;                                             
    reg[`OUTPUT_INTERFACE_INT_IN-1:0] intA,intB;            
    reg[`OUTPUT_INTERFACE_EXP_IN-1:0] expA,expB;            
    reg signA,signB,nanA,nanB,infA,infB,errA,errB;        
    integer f,i;
    OutputInterface oi(mode,intA,intB,expA,expB,signA,signB,nanA,nanB,infA,infB,errA,errB,outA,outB,err);

    initial begin
        f = $fopen("output_oi.csv","w");
        $fwrite(f,"intA,intB,mode,expA,expB,signA,signB,nanA,nanB,infA,infB,errA,errB,outA,outB,err\n");
        for (i = 0; i<`NUM_OF_TEST+1; i=i+1) begin
            $fwrite(f,"%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,\n",intA,intB,mode,expA,expB,signA,signB,nanA,nanB,infA,infB,errA,errB,outA,outB,err);
            if(i<`NUM_OF_TEST/2)begin
                intA = $random()%24;
                intB = $random()%24;
                expA = $random()%8;
                expB = $random()%8;
                mode = 0;
                signA = $random()%1;
                signB = $random()%1;
                nanA = $random()%1;
                nanB = $random()%1;
                infA = $random()%1;
                infB = $random()%1;
                errA = $random()%1;
                errB = $random()%1;
            end
            else begin
                intA = $random()%53;
                intB = $random()%53;
                expA = $random()%11;
                expB = $random()%11;
                mode = 1;
                signA = $random()%1;
                signB = $random()%1;
                nanA = $random()%1;
                nanB = $random()%1;
                infA = $random()%1;
                infB = $random()%1;
                errA = $random()%1;
                errB = $random()%1;
            end
            #100;
        end
        // special cases
    end
    
endmodule