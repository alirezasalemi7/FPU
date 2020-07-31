module sqrt_CU(start, finished, ld, ld_out_reg, select, ready, clk, rst);
/*
Controller of the integer sqrt unit:
inputs :
	clk and rst: clock and asynchronous reset
	finished: is a status signal indicating the end of the calculation
	start: is a signal indicating the arrival of an input
outputs:
	ld: load pin of the registers of the integer sqrt unit
	ld_out: load pin of the output register
	ready: indicates that the output is ready
	select: selector of input MUXes
*/

	input start, finished, clk, rst;
	output reg ld, ready, ld_out_reg, select;

	reg [2:0] ps, ns;
	parameter [2:0] IDLE = 3'b0, START = 3'b1, SELECT = 3'b10, LOAD = 3'b11, FINISH = 3'b100;

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