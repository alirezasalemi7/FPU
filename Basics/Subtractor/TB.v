`define SIZE 32
`define REPEAT 100

module TB();
	wire [`SIZE - 1 : 0] res;
    reg [`SIZE - 1 : 0] a, b;
	integer f;
    subtractor #(.SIZE(`SIZE)) Subtractor(.a(a), .b(b), .res(res));
    initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "a,b,a-b\n");
        repeat(`REPEAT) begin
            #100 
			$fwrite(f, "%b,%b,%b\n", a, b, res);
			a = $random;
			b = $random;
        end
		$fwrite(f, "%b,%b,%b\n", a, b, res);
		$fclose(f);
    end
endmodule // TB