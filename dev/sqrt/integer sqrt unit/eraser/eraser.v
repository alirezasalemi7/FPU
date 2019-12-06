module eraser(value, erase, result);
/*
	Eraser
	it's used to erase or pass the input value based on erase signal
	if erase is 1 then it passes value otherwise it erases
*/
parameter SIZE = 32;
input [SIZE - 1 : 0] value;
input erase;	//low active input, erase signal
output [SIZE - 1 : 0] result;

assign result = (erase) ? value : 0;

endmodule // Eraser