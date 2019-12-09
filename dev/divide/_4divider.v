module _4divider(N, D, R, Q, I, NO, QO, RO, IO);

    parameter INPUT_SIZE = 10;

    input [INPUT_SIZE-1 : 0] N, D, R, Q;
    input [INPUT_SIZE-1 : 0] I;
    output [INPUT_SIZE-1 : 0] NO, QO, RO;
    output [INPUT_SIZE-1 : 0] IO;
    
    wire [INPUT_SIZE-1 : 0] NO1, NO2, NO3;
    wire [INPUT_SIZE-1 : 0] QO1, QO2, QO3;
    wire [INPUT_SIZE-1 : 0] RO1, RO2, RO3;
    wire [INPUT_SIZE-1 : 0] IO1, IO2, IO3;

    divunit #(INPUT_SIZE) D1(N, D, R, Q, I, NO1, QO1, RO1, IO1);
    divunit #(INPUT_SIZE) D2(NO1, D, RO1, QO1, IO1, NO2, QO2, RO2, IO2);
    divunit #(INPUT_SIZE) D3(NO2, D, RO2, QO2, IO2, NO3, QO3, RO3, IO3);
    divunit #(INPUT_SIZE) D4(NO3, D, RO3, QO3, IO3, NO, QO, RO, IO);

endmodule