module dividerTB();
    reg clock, reset, en;
    reg [29:0] divisor, dividend, initi;
    wire [29:0] Q, R;

    divider #(30) D1(
        .clk(clock),
        .rst(reset),
        .initCounter(initi),
        .enable(en),
        .N(divisor),
        .D(dividend),
        .QO(Q),
        .RO(R)
    );
    always  #10 clock = ~clock;
    initial begin
        clock = 1'b0;
        en = 1'b1;
	divisor = 30'b000000111000000011100111001110;
        dividend = 30'b000000010100000011100000000000;
        initi = 30'b000000000000000000000000011110;
        reset = 1'b0;
        #1
        reset = 1'b1;
        #1
        reset = 1'b0;
        #600
        
        divisor = 30'b111111111000000011100111001110;
        dividend = 30'b000000010100000011100000001110;
        initi = 30'b000000000000000000000000011110;
        reset = 1'b1;
        #1
        reset = 1'b0;
        #600


	$stop;
    end
endmodule 