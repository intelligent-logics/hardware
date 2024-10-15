//singleportram.v
/*
Author(s): Steven Miller
Date created: October 14 2024
Purpose: single port ram, created for cross platform compatibility
Notes: taken from https://www.chipverify.com/verilog/verilog-single-port-ram

Note that the default behavior for this is to be a latch, this is an odd design
choice by nintendo but a choice nonetheless.
To make the ram clocked, uncomment out the clocked section, and comment out the 
latched section

log:
	$ Steven 10/14/2024: initial creation
*/

module singleportram
#(	parameter addr_width = 11,
	parameter data_width = 8,
	parameter depth = 2047)
(
	input clk,
	input [addr_width-1:0] address,
	inout [data_width-1:0] data,
	input csn, //ACTIVE LOW
	input wen, //ACTIVE LOW
	input oen //ACTIVE LOW
);

/*registers*/
reg [data_width-1:0] temp_data;
reg [data_width-1:0] memory[depth];
/*clocked section*/
/*
always@(posedge clk)
begin
	//if chip is selected and write it true and output isnt true
	if(csn==0 && wen==0 && oen==1)
		begin
			memory[address] <= data;
		end
	//if chip is selected and write is false and output is true
	else if(csn == 0 && wen==1 && oen == 0)
		begin
			temp_data <= memory[address];
		end
	//any other case
	else
		begin
			temp_data <= 'hz;
		end
end
*/

/*latched section*/

always@(csn or wen or oen)
begin
	//if chip is selected and write it true and output isnt true
	if(csn==0 && wen==0 && oen==1)
		begin
			memory[address] <= data;
		end
	//if chip is selected and write is false and output is true
	else if(csn == 0 && wen==1 && oen == 0)
		begin
			temp_data <= memory[address];
		end
	//any other case
	else
		begin
			temp_data <= 'hz;
		end
end

assign data = temp_data;
endmodule