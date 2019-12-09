module divider(clk, rst, initCounter, enable, N, D, QO, RO);

    parameter INPUT_SIZE = 10;

    input clk, rst, enable;
    input [INPUT_SIZE-1 : 0] N, D, initCounter;
    output [INPUT_SIZE-1 : 0] QO, RO;
    wire [INPUT_SIZE-1 : 0] NO;
    wire [INPUT_SIZE-1 : 0] IO;
    wire [INPUT_SIZE-1 : 0] Q, R;

    wire [INPUT_SIZE-1 : 0] combinationalQout;
    wire [INPUT_SIZE-1 : 0] combinationalRout;
    wire [INPUT_SIZE-1 : 0] combinationalNout;
    wire [INPUT_SIZE-1 : 0] combinationalIout;
    register #(INPUT_SIZE) r1(clk, rst, {INPUT_SIZE{1'b0}}, combinationalQout, Q);
    register #(INPUT_SIZE) r2(clk, rst, {INPUT_SIZE{1'b0}}, combinationalRout, R);
    register #(INPUT_SIZE) r3(clk, rst,  N, combinationalNout, NO);
    register #(INPUT_SIZE) r4(clk, rst, initCounter, combinationalIout, IO);
    _4divider #(INPUT_SIZE) C1(NO, D, R, Q, IO, combinationalNout, combinationalQout, combinationalRout, combinationalIout);
    assign QO = enable ? Q : QO;
    assign RO = enable ? R : RO;

endmodule