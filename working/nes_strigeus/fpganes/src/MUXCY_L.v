//MUXCY_L
/*
Author(s): Steven Miller
Date created: September 19 2024
Purpose: replacement for xilinx MUXCY_L hard IP

Notes:
	$ Steven 9/19/2024: initial creation
*/

module MUXCY_L
(
	input DI,
	input CI,
	input S,
	output reg LO
	
);

always @ (DI or CI or S)
begin
	case(S)
		0: LO <= DI;
		1: LO <= CI;
	endcase
end

endmodule