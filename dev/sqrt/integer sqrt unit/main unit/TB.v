`define SIZE 64
`define REPEAT 32 

/*
To run this TB in your Modelsim, first config this by right click on file and 
go to properties -> Verliog & System verilog -> Other Verilog Options
Here click "Include Directory..." button and add all folders of your include files.
*/


/*
Notes for defines :
	SIZE -> used to set size of numbers, if you wanna change it, 
		notice that you should generate proper random numbers in line 38
	REPEAT -> it used to set how many numbers should be calculated by the SQRT unit
*/

module TB();
	reg [`SIZE - 1 : 0] number;
	wire [`SIZE - 1 : 0] out;
	reg clk = 1, rst = 1, start = 0;
	wire ready;
	integer f;
	SQRT #(`SIZE) sqrt(.clk(clk), .rst(rst), .start(start), .num(number), .ready(ready), .out(out));

	initial begin
		#200 rst = 0;
		#3000000 $stop;
	end
	always #50 clk = ~clk;
	initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "value,sqrt\n");
		#200
		repeat(`REPEAT) begin
			#100
			$fwrite(f, "%d,%d\n", number, out); 
			number = {$random, $random};
			start = 1;
			#200 start = 0;
			@(posedge ready);
		end
		$fwrite(f, "%d,%d\n", number, out);
		$fclose(f);
	end

endmodule