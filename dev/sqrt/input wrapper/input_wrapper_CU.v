module input_wrapper_CU(clk, rst, run, start_sqrt, ld_reg);
/*
Controller of sqrt input wrapper:
inputs:
	run -> a status signal that says we should run main module
outputs:
	ld_reg -> load pin of mantisa register in input wrapper
	start_sqrt -> a signal that is used for handshaking with sqrt module
*/

input clk, rst, run;
output reg start_sqrt, ld_reg;

	reg [1 : 0] ps, ns;
	parameter IDLE = 0, LOAD = 1, RUN = 2;

	always @(posedge clk, posedge rst) begin
		if (rst) ps <= IDLE;
		else ps <= ns;
	end

	always @(ps) begin
		{ld_reg, start_sqrt} = 2'b0;
		case (ps)
			// We don't issue any signal in IDLE state
			IDLE : begin
				ld_reg = 1'b0;
			end
			LOAD : begin
				ld_reg = 1'b1;
			end
			RUN : begin
				start_sqrt = 1'b1;
			end
		endcase
	end

	always @(ps, run) begin
		ns = IDLE;
		case (ps)
			IDLE : ns = (run == 1'b1) ? LOAD : IDLE;
			LOAD : ns = RUN;
			RUN : ns = IDLE;
			default: ns = IDLE;
		endcase
	end

endmodule