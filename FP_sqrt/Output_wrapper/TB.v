`define M_SIZE 53
`define REPEAT 32 
`define EXP_SIZE 11

// `include "output_wrapper.v"

module TB();
	reg clk = 0, rst = 1;
	reg [`M_SIZE - 1 : 0] in_mantisa;
	reg [`EXP_SIZE - 1 : 0] in_exp;
	reg [2 : 0] in_flags;
	wire sign;
	wire [`M_SIZE - 1 : 0] out_mantisa;
	wire [`EXP_SIZE - 1 : 0] out_exp;
	integer f;

	output_wrapper #(.M_SIZE(`M_SIZE), .EXP_SIZE(`EXP_SIZE)) 
					Output_rapper(.in_mantisa(in_mantisa), .in_exp(in_exp), .in_flags(in_flags)
								, .out_mantisa(out_mantisa), .out_exp(out_exp), .out_sign(sign));

	initial begin
		#200 rst = 0;
		#100000 $stop;
	end
	always #50 clk = ~clk;
	initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "input mantisa,input exponent,input flags,sign,output mantisa, output exponent\n");
		#200
		repeat(`REPEAT) begin
			#100
			$fwrite(f, "%b,%b,%b,%b,%b,%b\n", in_mantisa, in_exp, in_flags, sign, out_mantisa, out_exp);
			in_flags = $random % 8;
			in_exp = $random;
			in_mantisa = {$random, $random}; 
		end
		$fwrite(f, "%b,%b,%b,%b,%b,%b\n", in_mantisa, in_exp, in_flags, sign, out_mantisa, out_exp);
		$fclose(f);
	end

endmodule
