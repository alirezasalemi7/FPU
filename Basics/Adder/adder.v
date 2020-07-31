module adder(a, b, cin, out, cout);
parameter SIZE = 32;
input [SIZE - 1 : 0] a, b;
input cin;
output [SIZE - 1 : 0] out;
output cout;
	assign {cout, out} = a + b + cin;
endmodule