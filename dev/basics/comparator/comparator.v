module comparator(a, b, equal, lower, greater);
/*
a > b -> greater
a < b -> lower
otherwise -> equal
*/
parameter SIZE = 32;
input[SIZE - 1 : 0] a;
input[SIZE - 1 : 0] b;
output reg equal, lower, greater;

always @* begin
    if (a < b) begin
        equal = 0;
        lower = 1;
        greater = 0;
    end
    else if (a == b) begin
        equal = 1;
        lower = 0;
        greater = 0;
    end
    else begin
        equal = 0;
        lower = 0;
        greater = 1;
    end
end

endmodule