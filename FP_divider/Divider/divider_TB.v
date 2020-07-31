`define SIZE 32
`define REPEAT 20

module dividerTB();

    reg clock, reset, en;
    reg [2*`SIZE - 1 : 0] dividend, divisor, initi;

    wire [2*`SIZE - 1 : 0] Q, R;
    wire rd;

    integer f;

    divider #(2*`SIZE) D1(
        .clk            (clock),
        .rst            (reset),
        .initCounter    (initi),
        .enable         (en),
        .N              (dividend),
        .D              (divisor),
        .QO             (Q),
        .RO             (R),
        .ready          (rd)
    );
    always  #10 clock = ~clock;
    initial begin
        f = $fopen("divideTB.csv", "w");
        $fwrite(f, "dividend, divisor, result, ready\n");
        clock = 1'b0;
        repeat(`REPEAT) begin
            #600
            $fwrite(f, "%d,%d,%d,%d\n", dividend, divisor, Q, rd);
            dividend = {$random, $random};
            divisor = {$random, $random};
            initi = 64'b01000000;
            en = 1'b0;
            #10
            en = 1'b1;
            #10
            en = 1'b0;
        end
        $fwrite(f, "%d,%d,%d,%d\n", dividend, divisor, Q, rd);
        $fclose(f);
        $stop;
    end
endmodule