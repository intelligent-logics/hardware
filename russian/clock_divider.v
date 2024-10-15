//clock_divider.v
/*
Author(s): Steven Miller
Date created: October 14 2024
Purpose: slows the clock wayyyy down
Notes:https://www.chipverify.com/verilog/verilog-modn-counter
log:
	$ Steven 10/14/2024: initial creation
*/

module clock_divider
#(parameter N= 2147727, parameter width = 28) //number of cycles before clock changes
(
	input clk,
	input rstn,
	output reg out
);
reg[width-1:0] counter;
always@(posedge clk or negedge rstn)
begin
//reset divider
	if(!rstn)
		begin
			counter<=0;
			out <=0;
		end
	else 
		begin
		//if we reach the set count
			if(counter == N-1)
				begin
				//switch to opposite edge
					out<=~out;
					counter <=0;
				end
			else
				begin
				//keep edge
					out<=out;
					counter <= counter+1;
				end
		end
end

endmodule
