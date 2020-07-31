`define SIZE 32
`define REPEAT 10

module combinational_div_TB();

    reg [`SIZE - 1 : 0] n, d, r, q;
    reg [`SIZE - 1 : 0] i;

    wire [`SIZE - 1 : 0] no, qo, ro;
    wire [`SIZE - 1 : 0] io;

    combinational_div #(`SIZE) M1(
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
        repeat(`REPEAT) begin
	        #100
            n = $random;
            d = $random;
            r = $random;
            q = $random;
            i = $random;
        end
    end
endmodule