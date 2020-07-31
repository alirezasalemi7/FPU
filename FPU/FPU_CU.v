module FPU_CU(clk, rst, operation, operation_ready, start, operation_load, sqrt_start, div_start, ready);
	input clk, rst, operation, start, operation_ready;
	output reg operation_load, sqrt_start, div_start, ready;

	reg [2 : 0] ps, ns;
	parameter IDLE = 0, RUN_DIV = 1, RUN_SQRT = 2, WAIT0 = 3, WAIT1 = 4, WAIT2 = 5, LOAD = 6;

	always @(posedge clk, posedge rst) begin
		if (rst) ps <= IDLE;
		else ps <= ns;
	end

	always @(ps) begin
		{operation_load, sqrt_start, div_start, ready} = 4'b0;
		case (ps)
			IDLE : begin
				ready = 1'b1;
			end
			LOAD: begin
				operation_load = 1'b1;
			end
			RUN_DIV : begin
				div_start = 1'b1;
			end
			// CU does not issue any signal in WAIT states
			RUN_SQRT : begin
				sqrt_start = 1'b1;
			end
			default : {operation_load, sqrt_start, div_start, ready} = 4'b0;
		endcase
	end

	always @(ps, operation, operation_ready, start) begin
		ns = IDLE;
		case (ps)
			IDLE : ns = (start) ? LOAD : IDLE;
			LOAD : ns = (operation_ready & ~operation) ? RUN_DIV : ((operation_ready & operation) ? RUN_SQRT : IDLE);
			RUN_DIV : ns = WAIT0;
			RUN_SQRT : ns = WAIT0;
			WAIT0 : ns = WAIT1;
			WAIT1 : ns = WAIT2;
			WAIT2 : ns = (operation_ready) ? IDLE : WAIT2;
			default: ns = IDLE;
		endcase
	end

endmodule