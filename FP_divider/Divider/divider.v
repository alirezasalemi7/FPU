`include "register_div.v"
`include "combinational_div.v"

module divider(clk, rst, initCounter, enable, N, D, QO, RO, ready);


    /*
        divider
        this module is the main divide module.
        It gets to input N and D and return quotient and remainder of N / D
    */

    parameter INPUT_SIZE = 10; // size of wires, inputs and outputs


    input clk, rst, enable; // wires and registers change just if enable == 1
    input [INPUT_SIZE-1 : 0] N, D, initCounter; // dividend, divisor, counter
    
    output [INPUT_SIZE-1 : 0] QO, RO; // out quotient, out remainder
    output ready; // changes to one when the output is ready

    wire [INPUT_SIZE-1 : 0] NO, DO; // output of registers and input of combinational part
    wire [INPUT_SIZE-1 : 0] IO; // output of registers and input of combinational part
    wire [INPUT_SIZE-1 : 0] Q, R; // output of registers and input of combinational part

    wire [INPUT_SIZE-1 : 0] combinationalQout; // output of combinational part that should be registered
    wire [INPUT_SIZE-1 : 0] combinationalRout; // output of combinational part that should be registered
    wire [INPUT_SIZE-1 : 0] combinationalNout; // output of combinational part that should be registered
    wire [INPUT_SIZE-1 : 0] combinationalIout; // output of combinational part that should be registered

    /*
        N, D, I, Q and R registered after each combinational part.
    */
    
    register_div #(INPUT_SIZE) r1(clk, rst, enable, {INPUT_SIZE{1'b0}}, combinationalQout, Q);
    register_div #(INPUT_SIZE) r2(clk, rst, enable, {INPUT_SIZE{1'b0}}, combinationalRout, R);
    register_div #(INPUT_SIZE) r3(clk, rst, enable, initCounter, combinationalIout, IO);
    register_div #(INPUT_SIZE) r4(clk, rst, enable, N, combinationalNout, NO);
    register_div #(INPUT_SIZE) r5(clk, rst, enable, D, D, DO);
    
    combinational_div #(INPUT_SIZE) C1(NO, DO, R, Q, IO, combinationalNout, combinationalQout, combinationalRout, combinationalIout);
    
    assign QO = Q;
    assign RO = R;

    /*
        ready is one when IO = 0 and algorithm is finished.
    */
    assign ready = (IO == 0) ? 1 : 0;

endmodule