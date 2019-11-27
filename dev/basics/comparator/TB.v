`define SIZE 32
`define REPEAT 100

module TB();
    reg [`SIZE - 1 : 0] a, b;
	wire equal, lower, greater;
	integer f;
    comparator #(.SIZE(`SIZE)) Comparator(.a(a), .b(b), .equal(equal), .lower(lower), .greater(greater));
    initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "a,b,a>b,a=b,a<b\n");
        repeat(`REPEAT) begin
            #100 
			$fwrite(f, "%b,%b,%b,%b,%b\n", a, b, greater, equal, lower);
			a = $random;
			b = $random;
        end
		$fwrite(f, "%b,%b,%b,%b,%b\n", a, b, greater, equal, lower);
		$fclose(f);
    end
endmodule // TB