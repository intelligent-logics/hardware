//XORCY
/*
Author(s): Steven Miller
Date created: September 19 2024
Purpose: replacement for xilinx XORCY hard IP

Notes:
	$ Steven 9/19/2024: initial creation
*/

module XORCY
(
	input LI,
	input CI,
	output O
	
);

assign O = LI ^ CI;
endmodule