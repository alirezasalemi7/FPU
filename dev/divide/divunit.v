module divunit(N, D, R, Q, I, NO, QO, RO, IO);
    
    parameter INPUT_SIZE = 10;
    
    input [INPUT_SIZE-1 : 0] N, D, R, Q;
    input [INPUT_SIZE-1 : 0] I;
    
    output [INPUT_SIZE-1 : 0] QO, NO, RO;
    output [INPUT_SIZE-1 : 0] IO;
    
    wire qBit;
    wire [INPUT_SIZE-1 : 0] shiftTemp;

    assign shiftTemp = {R[INPUT_SIZE-2 : 0], N[INPUT_SIZE-1]};
    assign NO = (I == {INPUT_SIZE{1'b0}}) ? N : N << 1;
    assign qBit = (shiftTemp >= D) ? 1'b1 : 1'b0;
    assign QO = (I == {INPUT_SIZE{1'b0}}) ? Q : {Q[INPUT_SIZE-2 : 0], qBit};
    assign RO = (I == {INPUT_SIZE{1'b0}}) ? R : (shiftTemp >= D) ? (shiftTemp - D) : shiftTemp;
    assign IO = (I == {INPUT_SIZE{1'b0}}) ? I : I - 1'b1;
endmodule