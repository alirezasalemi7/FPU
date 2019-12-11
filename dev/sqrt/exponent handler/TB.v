`define SIZE 11
`define REPEAT 32


module TB();
	reg clk = 0, rst = 1, type;
	reg [`SIZE - 1 : 0] in_exp;
	wire [`SIZE - 1 : 0] out_exp;
	integer f;
	exponent_handler Exponent_handler(.type(type), .exp(in_exp), .out_exp(out_exp));

	initial begin
		#200 rst = 0;
		#100000 $stop;
	end
	always #50 clk = ~clk;
	initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "in exponent, type, out exponent\n");
		#200
		repeat(`REPEAT) begin
			#100	
			$fwrite(f, "%b,%b,%b\n", in_exp, type, out_exp);
			type = $random % 2;
			in_exp = $random;
		end
		$fwrite(f, "%b,%b,%b\n", in_exp, type, out_exp);
		$fclose(f);
	end
	
endmodule