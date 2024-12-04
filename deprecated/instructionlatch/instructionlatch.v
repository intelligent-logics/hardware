//instructionlatch.v
/*
Author(s): Steven Miller
Date created: november 15 2024
Purpose: basic n bit latch
log:
	$ Steven 11/15/2024: initial creation
*/

module instructionlatch
#(parameter length = 8)
(
	input[length-1:0] i_data,
	input i_latch_enable,
	//input outputenablen,
	output reg[length-1:0] o_Q
);

always@(i_latch_enable)

begin
	if(i_latch_enable == 1)
		begin
			o_Q <=i_data;
		end
	else
		begin
			o_Q <= o_Q;
		end
end

endmodule