module register(clk, rst, init, din, qout);
    parameter INPUT_SIZE = 10;
    input clk, rst;
    input[INPUT_SIZE-1 : 0] din, init;
    output reg[INPUT_SIZE-1 : 0] qout;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            qout <= init;
        end
        else begin
            qout <= din; 
        end
    end

endmodule

