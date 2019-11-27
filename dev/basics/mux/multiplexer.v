module multiplexer(first_value, second_value, select, out);
/*
0 -> first_value
1 -> second_value
*/
parameter SIZE = 32;
input[SIZE - 1 : 0] first_value;
input[SIZE - 1 : 0] second_value;
input select;
output reg[SIZE - 1 : 0] out;

always @* begin
    if(select == 0)
        out = first_value;
    else
        out = second_value;
end

endmodule