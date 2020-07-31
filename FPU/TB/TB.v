`include "header.h"

`define NULL 0

module TB();
	reg rst = 1, clk = 1, start;
    reg [`REG_SIZE - 1 : 0] inpA, inpB;
	reg [`OP_BITS - 1 : 0] operation;
	reg [5 : 0] clocks;

	wire [`REG_SIZE - 1 : 0] res;
	integer input_file, output_file;
	wire ready;

	parameter FILENAME = "input.csv";
	parameter REPEAT = 512;
	parameter DELAY = 100 * 37 * REPEAT;

	integer num; //this is a dummy var for eliminating the fscanf's warning
	FPU fpu(.clk(clk), .rst(rst), .start(start), .inpA(inpA), .inpB(inpB), .operation(operation), .res(res), .ready(ready));

	initial begin
		#200 rst = 0;
		#DELAY $finish;
	end
	always #32 clk = ~clk;
	initial begin
		input_file = $fopen(FILENAME, "r");
		if (input_file == `NULL) begin
			$display("input_file handle was NULL");
			$finish;
		end
		output_file = $fopen("output.csv", "w");
		num = $fscanf(input_file, "%b,", operation);
		if (operation[0]) num = $fscanf(input_file, "%b\n", inpA);
		else num = $fscanf(input_file, "%b,%b\n", inpA, inpB);
		repeat (REPEAT) begin
			#200
			start = 1;
			#200 start = 0;
			@(posedge ready);
			@(posedge clk);
			// if (operation[0]) begin
			// 	$display("sqrt");
			// end else begin
			// 	$display("divide");
			// end
			$fwrite(output_file, "%b,", operation);
			if (operation[0]) $fwrite(output_file, "%b,%b,%b\n", inpA, res, clocks);
			else $fwrite(output_file, "%b,%b,%b,%b\n", inpA, inpB, res, clocks);
			// $display("res : %b",res);
			num = $fscanf(input_file, "%b,", operation);
			if (operation[0]) num = $fscanf(input_file, "%b\n", inpA);
			else num = $fscanf(input_file, "%b,%b\n", inpA, inpB);
			@(posedge clk);
		end
		$fclose(input_file);
		$fclose(output_file);
	end
	always @(posedge clk, posedge rst, posedge start, posedge ready) begin
        if (rst) clocks <= 6'b0;
        else if (start) clocks <= 6'b0;
        else if (ready) clocks <= clocks;
        else clocks <= clocks + 1;
    end

endmodule