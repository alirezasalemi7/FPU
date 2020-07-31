`include"FPU.v"

module FPU_TOP(clk, rst, start, inpA, inpB, operation, res, ready);
    
    input clk, rst, start;
	input [`REG_SIZE-1:0] inpA, inpB;
    input [`OP_BITS-1:0] operation;
    output [`REG_SIZE-1:0] res;
    output ready;
    wire outClk,locked;
    
    FPU fpu(.clk(outClk), .rst(rst), .start(start), .inpA(inpA), .inpB(inpB), .operation(operation), .res(res), .ready(ready));
    clk_wiz_0 clkGenarator(.clk_out1(outClk),.reset(rst),.locked(locked),.clk_in1(clk));

endmodule