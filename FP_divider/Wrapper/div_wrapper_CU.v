module div_wrapper_CU(clock, reset, startOp, readyDiv, load, finishOp);

	/*
        div_wrapper_CU
        this module is the control unit of the wrapper
    */

	input clock, reset;
	input startOp; // startOp signal is issued by FPU
	input readyDiv; // readyDiv is issued by div_wrapper_DP

	output reg load; // load signal is sent to div_wrapper_CU
	output reg finishOp; // finishOp is sent to main module

	reg [1:0] ps, ns;

	/*
		IDLE : start signal is not recieved yet
		RESET : loading into the registers to start division
		CALCLATE : calculating the division's result
	*/
	parameter IDLE = 0, RESET = 1, CALCULATE = 2;

	always @(posedge clock, posedge reset) begin
		if (reset) ps <= IDLE;
		else ps <= ns;
	end

	always @(ps) begin
		{load, finishOp} = 2'b0;
		case (ps)
			IDLE : begin
				finishOp = 1'b1;
			end
			RESET : begin
				load = 1'b1;
			end
			CALCULATE : begin
                load = 1'b0;
			end
            default : begin
                finishOp = 1'b1;
            end
		endcase
	end

	always @(ps, startOp, readyDiv) begin
		ns = IDLE;
		case (ps)
			IDLE : ns = (startOp) ? RESET : IDLE;
			RESET : ns = CALCULATE;
			CALCULATE : ns = (readyDiv == 1'b1) ? IDLE : CALCULATE;
			default : ns = IDLE;
		endcase
	end

endmodule
