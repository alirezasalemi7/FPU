// `include "header.h"


module first_one_finder(number, max_power);
/*
    it's used to find the biggest power of 4 that is less than the input number
    default size is 32 bit and it can be changed by modifying SIZE paramenter
    Input : number
    Output : max_power

	!NOTICE : Check that is it synthesizable to implement different logics based on even or odd parameters?
*/
parameter SIZE = 32;
input [SIZE - 1 : 0] number;
output [SIZE - 1 : 0] max_power;

wire [SIZE - 1 : 0] middle_wires;
wire [SIZE - 1 : 0] or_wires;

genvar i;
generate for (i = 0; i < SIZE - 1; i = i + 1) begin
        assign or_wires[i] = or_wires[i + 1] | number[i];
        assign middle_wires[i] = or_wires[i + 1] ^ or_wires[i];
    end
endgenerate
assign or_wires[SIZE - 1] = number[SIZE - 1];
assign middle_wires[SIZE - 1] = number[SIZE - 1];
/* 
    To detect whether first one is located in an odd stage or even one
*/
genvar j;
generate for (j = 0; j < SIZE - 1; j = j + 2) begin
        assign max_power[j] = middle_wires[j] ^ middle_wires[j + 1];
        assign max_power[j + 1] = middle_wires[j] & middle_wires[j + 1];
    end
	if(SIZE[0])
		assign max_power[SIZE - 1] = middle_wires[SIZE - 1];
endgenerate

// assign max_power[SIZE - 1] = (SIZE[0]) ?middle_wires[SIZE - 1] : max_power[SIZE - 1];


endmodule