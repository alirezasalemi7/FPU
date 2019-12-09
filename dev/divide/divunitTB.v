module divunitTB();
    
    reg [9:0] n, d, r, q;
    reg [9:0] i;
    wire [9:0] no, qo, ro;
    wire [9:0] io;

    divunit #(10) M1(
        .N   (n),
        .D   (d),
        .R   (r),
        .Q   (q),
	    .I   (i),
        .NO  (no),
        .QO  (qo),
        .RO  (ro),
	    .IO  (io)
    );

    initial begin
        n = 10'b0101100000;
        d = 10'b0000001101;
        r = 10'b0000001000;
	q = 10'b0010101100;
	i = 10'b0000000010;
        #30
        n = 10'b1000000000;
        d = 10'b0000001110;
        r = 10'b0000011110;
	i = 10'b0000000000;
        #30
        n = 10'b0000000100;
        d = 10'b0000001110;
        r = 10'b0000001000;
	i = 10'b0000001111;
        #30
	$stop;
    end
endmodule