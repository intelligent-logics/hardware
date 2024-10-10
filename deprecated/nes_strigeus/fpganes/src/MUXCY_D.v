//MUXCY_D
/*
Author(s): Steven Miller
Date created: September 19 2024
Purpose: replacement for xilinx MUXCY hard IP

Notes:
	$ Steven 9/19/2024: initial creation
*/

module MUXCY_D
(
	input DI,
	input CI,
	input S,
	output reg LO,
	output reg O
	
);

always @ (DI or CI or S)
begin
	case(S)
		0: LO <= DI;
		1: LO <= CI;
	endcase
	O <= LO;
end

endmodule