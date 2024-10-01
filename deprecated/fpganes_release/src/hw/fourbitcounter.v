//usbtouart
/*
Author(s): Steven Miller
Date created: August 27 2024
Purpose: general purpose 4 bit counter

Notes:
	$ Steven Miller 8/27/2024: initial creation
*/
module fourbitcounter
(
input count, 
input clk, 
input rst_n, 
output reg [3:0] out
);

always @ (posedge clk) 

begin

if(!rst_n)

	out <= 0; //reset counter
	
else if (count)

	out <= out + 1;
	
end

endmodule