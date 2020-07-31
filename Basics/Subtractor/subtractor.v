module subtractor(a, b, res);
/*
	res = a - b
	!NOTICE : this module subtracts b from a in 2's complement system, first ensure that a >= b to get proper result.
*/
parameter SIZE = 32;
input[SIZE - 1 : 0] a;
input[SIZE - 1 : 0] b;
output reg[SIZE - 1 : 0] res;

always @* begin
    res = a - b;    
end

endmodule