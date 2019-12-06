module SQRT_CU(start, finished, ld, ld_out_reg, select, ready, clk, rst);
/*
Controller of integer sqrt unit:
inputs : 
	finished -> is a status signal that is used to mention end of calcualtion
	start -> comes from input interface and to say user pushed an input.
outputs :
	ld -> load pin of registers of integer sqrt unit
	ld_out -> load pin of output register
	ready -> To say that output is ready
	select -> selector of input MUXes
*/

	input start, finished, clk, rst;
	output reg ld, ready, ld_out_reg, select;

	reg [2:0] ps, ns;
	parameter [2:0] IDLE = 0, START = 1, SELECT = 2, LOAD = 3, FINISH = 4;

	always @(posedge clk, posedge rst) begin
		if (rst) ps <= IDLE;
		else ps <= ns;
	end

	always @(ps) begin
		{ld, ld_out_reg, select, ready} = 4'b0;
		case (ps)
			IDLE : begin
				ready = 1'b1;
				select = 1'b1;
			end
			START : begin
				ld = 1'b1;
				select = 1'b1;
			end
			SELECT : begin
				select = 1'b0;
			end
			LOAD : begin
				ld = 1'b1;
				select = 1'b0;
			end
			FINISH : begin
				ld_out_reg = 1'b1;
			end
		endcase
	end

	always @(ps, start, finished) begin
		ns = IDLE;
		case (ps)
			IDLE : ns = (start) ? START : IDLE;
			START : ns = SELECT;
			SELECT : ns = LOAD;
			LOAD : ns = (finished) ? FINISH : SELECT; 
			FINISH : ns = IDLE;
			default : ns = IDLE;
		endcase
	end

endmodule