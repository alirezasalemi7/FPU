`include "div_unit.v"

module combinational_div(N, D, R, Q, I, NO, QO, RO, IO);

    /*
        combinational_div
        this module connects 4 instances of div_unit module together
        this is the critical path of FP_divider module
    */

    parameter INPUT_SIZE = 10; // size of wires, inputs and outputs

    input [INPUT_SIZE-1 : 0] N, D, R, Q; // dividend, divisor, remainder, quotient
    input [INPUT_SIZE-1 : 0] I; // counter

    output [INPUT_SIZE-1 : 0] NO, RO, QO; // out dividend, out remainder, out quotient
    output [INPUT_SIZE-1 : 0] IO; // out counter


    wire [INPUT_SIZE-1 : 0] NO1, NO2, NO3; // wires for interconnection of instances of div_unit module
    wire [INPUT_SIZE-1 : 0] QO1, QO2, QO3; // wires for interconnection of instances of div_unit module
    wire [INPUT_SIZE-1 : 0] RO1, RO2, RO3; // wires for interconnection of instances of div_unit module
    wire [INPUT_SIZE-1 : 0] IO1, IO2, IO3; // wires for interconnection of instances of div_unit module

    /*
        4 instances of div_unit module connected in serial
        output of each instance, is the input of the next instance
    */
    div_unit #(INPUT_SIZE) D1(N, D, R, Q, I, NO1, QO1, RO1, IO1);
    div_unit #(INPUT_SIZE) D2(NO1, D, RO1, QO1, IO1, NO2, QO2, RO2, IO2);
    div_unit #(INPUT_SIZE) D3(NO2, D, RO2, QO2, IO2, NO3, QO3, RO3, IO3);
    div_unit #(INPUT_SIZE) D4(NO3, D, RO3, QO3, IO3, NO, QO, RO, IO);

endmodule