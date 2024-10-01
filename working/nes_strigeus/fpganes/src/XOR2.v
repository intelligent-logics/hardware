//XOR2
/*
Author(s): Steven Miller
Date created: September 19 2024
Purpose: replacement for xilinx XOR2 hard IP

Notes:
	$ Steven 9/19/2024: initial creation
*/

module XOR2
(
	input I0,
	input I1,
	output O
	
);

assign O = I0 ^ I1;
endmodule