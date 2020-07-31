module div_unit(N, D, R, Q, I, NO, QO, RO, IO);

    /*
        div_unit
        this module is the basic unit of dividing
        it is fully combinational and does one iteration of overall algorithm
    */

    parameter INPUT_SIZE = 10; // size of wires, inputs and outputs

    input [INPUT_SIZE-1 : 0] N, D, R, Q; // dividend, divisor, remainder, quotient
    input [INPUT_SIZE-1 : 0] I; // counter

    output [INPUT_SIZE-1 : 0] NO, RO, QO; // out dividend, out remainder, out quotient
    output [INPUT_SIZE-1 : 0] IO; // out counter

    wire qBit;  // bit that will be assigned to Q(i)
    wire [INPUT_SIZE-1 : 0] shiftTemp; // wire for shifted R

    /*
        if (I == 0)
            enable is 0 and nothing happens
        else
            the algorithm runs!
    */

    assign shiftTemp = {R[INPUT_SIZE-2 : 0], N[INPUT_SIZE-1]};

    assign NO = (I == {INPUT_SIZE{1'b0}}) ? N : N << 1;

    assign qBit = (shiftTemp >= D) ? 1'b1 : 1'b0;
    assign QO = (I == {INPUT_SIZE{1'b0}}) ? Q : {Q[INPUT_SIZE-2 : 0], qBit};
    assign RO = (I == {INPUT_SIZE{1'b0}}) ? R : (shiftTemp >= D) ? (shiftTemp - D) : shiftTemp;
    assign IO = (I == {INPUT_SIZE{1'b0}}) ? I : I - 1'b1;
endmodule