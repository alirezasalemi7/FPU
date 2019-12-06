// `include "/eraser/eraser.v"
`define SIZE 32
`define REPEAT 100


module TB();
    wire [SIZE - 1:0] res;
    reg [SIZE - 1:0] input_num;
	reg erase;
	integer f;
    eraser #(.SIZE(`SIZE)) Eraser(.value(input_num), .erase(erase), .result(res));
    initial begin
		f = $fopen("output.csv", "w");
		$fwrite(f, "input,erase,result\n");
        repeat(`REPEAT) begin
            #100
			$fwrite(f, "%b,%b,%b\n", input_num, erase, res);
			input_num = $random;
			erase = $random%2;
        end
		$fwrite(f, "%b,%b,%b\n", input_num, erase, res);
		$fclose(f);
    end
endmodule // TB