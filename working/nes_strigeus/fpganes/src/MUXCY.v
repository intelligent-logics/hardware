//MUXCY
/*
Author(s): Steven Miller
Date created: September 19 2024
Purpose: replacement for xilinx MUXCY hard IP

Notes:
	$ Steven 9/19/2024: initial creation
*/

module MUXCY
(
	input DI,
	input CI,
	input S,
	output reg O
	
);

always @ (DI or CI or S)
begin
	case(S)
		0: O <= DI;
		1: O <= CI;
	endcase
end

endmodule