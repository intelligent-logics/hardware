//latch.v
/*
Author(s): Steven Miller
Date created: October 14 2024
Purpose: basic n bit latch
log:
	$ Steven 10/14/2024: initial creation
*/

module latch
#(parameter length = 8)
(
	input[length-1:0] data,
	input latch_enable,
	input outputenablen,
	output reg[length-1:0] Q
);

always@(latch_enable)

begin
	if(latch_enable == 1)
		begin
			Q <=data;
		end
	else
		begin
			Q <= Q;
		end
end

endmodule