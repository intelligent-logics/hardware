/*
Author(s): Steven Miller
Date created: August 28 2024
Purpose: outputs cpu control signals for when game is changed

Notes:
	$ Steven Miller 8/27/2024: initial creation
*/

module gamecountercontroller
(
input count, 
input clk, 
input rst_n,
output reg reset_cpu,
output [3:0] out
);
fourbitcounter counter
(
	.count(count), 
	.clk(clk), 
	.rst_n(rst_n), 
	.out(out[3:0])
);

 reg current_state;
 parameter hold = 0, reset_cpu_state =1;
 
always @ (posedge clk, negedge rst_n)

begin
	if (!rst_n)
		current_state = reset_cpu_state;
	else
		case(current_state)

		hold:
				if(count)
					current_state = reset_cpu_state;
				else
					current_state = hold;
				
		reset_cpu_state:
	
				current_state = hold;
				
		endcase
end 

always @ (current_state)
begin
	case(current_state)
	
	reset_cpu_state:
	
		reset_cpu <= 0;
		
	hold:
	
		reset_cpu <= 1;
		
	endcase
end
endmodule