`define SIZE 32
`define REPEAT 100

module TB();
	wire [`SIZE - 1 : 0] res;
    reg [`SIZE - 1 : 0] a, b;
	reg sel;
	integer f;
    multiplexer #(.SIZE(`SIZE)) MUX(.first_value(a), .second_value(b), .select(sel), .out(res));
    initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "firstValue,secondValue,select,output\n");
        repeat(`REPEAT) begin
            #100
			$fwrite(f, "%b,%b,%b,%b\n", a, b, sel, res);
			a = $random;
			b = $random;
			sel = $random%2;
        end
		$fwrite(f, "%b,%b,%b,%b\n", a, b, sel, res);
		$fclose(f);
    end
endmodule // TB