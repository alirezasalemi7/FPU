`define M_IN_SIZE 53
`define M_OUT_SIZE 106
`define EXP_SIZE 11
`define REPEAT 512

module TB();
	reg clk = 1, rst = 1;
	reg [`M_IN_SIZE - 1 : 0] in_mantisa;
	reg [`EXP_SIZE - 1 : 0] in_exp;
	reg [2 : 0] in_flags;
	reg in_type, start, ready, sign;
	wire [`M_OUT_SIZE - 1 : 0] out_mantisa;
	wire [`EXP_SIZE - 1 : 0] out_exp;
	wire [2 : 0] out_flags;
	wire start_sqrt, out_type;
	integer f;
	input_wrapper #(.OUT_M_SIZE(`M_OUT_SIZE), .IN_M_SIZE(`M_IN_SIZE), .EXP_SIZE(`EXP_SIZE)) 
		Input_wrapper(.clk(clk), .rst(rst), .in_exp(in_exp), .in_flags(in_flags), .in_mantisa(in_mantisa)
					, .in_type(in_type), .start(start), .ready(ready), .sign(sign), .out_exp(out_exp)
					, .out_flags(out_flags), .out_mantisa(out_mantisa), .out_type(out_type), .start_sqrt(start_sqrt));

	initial begin
		#200 rst = 0;
		#300000 $stop;
	end
	always #50 clk = ~clk;
	initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "in exp,in flags,in mantisa,in type,start,ready,sign,out exp,out flags,out mantisa,out type,start sqrt\n");
		#200
		repeat(`REPEAT) begin
			#100
			$fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n", in_exp, in_flags, in_mantisa, in_type
						, start, ready, sign, out_exp, out_flags, out_mantisa, out_type, start_sqrt); 
			in_mantisa = {$random, $random, $random, $random};
			in_exp = $random;
			in_flags = 3'b100;
			{in_type, ready, sign} = $random % 8;
			start = 1;
			#200 start = 0;
			#200;
		end
		$fwrite(f, "%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n", in_exp, in_flags, in_mantisa, in_type
					, start, ready, sign, out_exp, out_flags, out_mantisa, out_type, start_sqrt);
		$fclose(f);
	end

endmodule