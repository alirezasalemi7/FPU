module register_sqrt(clk, rst, ld, din, qout);
    /*
        Register 
        this module used to save values
        default size of register is 32 but can be modified using parameters
    */
    parameter SIZE = 32;
    input clk, rst, ld;
    input[SIZE - 1 : 0] din;
    output reg[SIZE - 1 : 0] qout;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            qout <= 0;
        end
        else if(ld) begin
            qout <= din; 
        end
        else begin
            qout <= qout; 
        end
    end

endmodule

