module register_div(clk, rst, enable, init, din, qout);
    /*
        Register
        this module used to save values
        default size of register is 10 but can be modified using parameters
    */
    parameter INPUT_SIZE = 10;
    input clk, rst, enable;
    input[INPUT_SIZE-1 : 0] din, init;
    output reg[INPUT_SIZE-1 : 0] qout;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            qout <= {INPUT_SIZE{1'b0}};
        end
        else if(enable) begin
            qout <= init;
        end
        else begin
            qout <= din;
        end
    end
endmodule
