`define SIZE 31
`define REPEAT 100

module TB();
	wire [`SIZE - 1 : 0] ans;
    reg [`SIZE - 1 : 0] input_num;
	integer f;
    first_one_finder #(.SIZE(`SIZE)) FOF(.number(input_num), .max_power(ans));
    initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "input,max_power\n");
        repeat(`REPEAT) begin
            #100 
			$fwrite(f, "%b,%b\n", input_num, ans);
			input_num = $random;
        end
		$fwrite(f, "%b,%b\n", input_num, ans);
		$fclose(f);
    end
endmodule // TB