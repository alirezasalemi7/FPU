`define INPUT_MODULE_M_SIZE 53
`define INPUT_SQRT_M_SIZE 106
`define EXP_SIZE 11
`define REPEAT 32


module TB();
    reg [`INPUT_MODULE_M_SIZE - 1 : 0] in_mantisa;
	reg [`EXP_SIZE - 1 : 0] in_exp;
	reg [20 : 0] temp;
	reg in_sign, in_type, start,rst=1,clk=0;
	reg [2 : 0] in_flags;
	wire [`INPUT_MODULE_M_SIZE - 1 : 0] out_mantisa;
	wire [`EXP_SIZE - 1 : 0] out_exp;
	wire out_sign,ready;
    integer f;

    fp_sqrt fps(in_mantisa, in_exp, in_sign, in_type, in_flags, start, rst, clk, out_mantisa, out_exp, out_sign,ready);

    initial begin
		#200 rst = 0;
		#300000 $stop;
	end
	always #50 clk = ~clk;
	initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "in_mantisa,in_exp,in_sign,in_type,in_flags,out_mantisa,out_exp,out_sign\n");
		#200
		repeat(`REPEAT) begin
			#100;
			$fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b\n", in_mantisa,in_exp,in_sign,in_type,in_flags,out_mantisa,out_exp,out_sign);
			temp = $random;
			in_mantisa = {1'b1,{temp[19:0], $random}};
            in_exp = $random%`EXP_SIZE;
            in_flags = 3'b100;
            in_sign = 0;
            in_type = 1;
			start = 1;
			#200 start = 0;
			@(posedge ready);
		end
		$fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b\n", in_mantisa,in_exp,in_sign,in_type,in_flags,out_mantisa,out_exp,out_sign);
		$fclose(f);
	end

endmodule