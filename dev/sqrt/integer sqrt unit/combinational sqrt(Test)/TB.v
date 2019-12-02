`define SIZE 5
`define REPEAT 31 

/*
To run this TB in your Modelsim, first config this by right click on file and 
go to properties -> Verliog & System verilog -> Other Verilog Options
Here click "Include Directory..." button and add all folders of your include files.
*/

module TB();
	reg[`SIZE - 1 : 0] value;
	wire[`SIZE - 1 : 0] sqrt;
	comb_sqrt #(`SIZE) c_sqrt(value, sqrt);
	integer f;
	initial begin
		value = 0;
		f = $fopen("output.csv", "w");
		$fwrite(f, "value,sqrt\n");
        repeat(`REPEAT) begin
            #100 
			$fwrite(f, "%b,%b\n", value, sqrt);
			value = value + 1'b1;
        end
		$fwrite(f, "%b,%b\n", value, sqrt);
		$fclose(f);
	end
endmodule