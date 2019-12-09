module _4dividerTB();
    reg [9:0] n, d, r, q;
    reg [9:0] i;
    wire [9:0] no, qo, ro;
    wire [9:0] io;

    _4divider #(10) M1(
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
        n = 10'b0000001010;
        d = 10'b0000000101;
        r = 10'b0000000000;
        q = 10'b0000000000;
        i = 10'b0000001001;
        #30
        n = 10'b0001010110;
        d = 10'b0000001110;
        r = 10'b0000001111;
        i = 10'b0000000000;
        #30
	$stop;
    end
endmodule