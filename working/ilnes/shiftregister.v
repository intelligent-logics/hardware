//shiftregister.v
/*
Author(s): Steven Miller
Date created: October 12 2024
Purpose: 8 bit shift register

Notes: bit 2: parallel enable bit 1: direction bit 0: shift 
	000: all outputs are latched
	001: shift register recieves input
	100: shift register outputted in parallel
	110: shift register loaded in parallel
	011: shift register sends output
	assume all other combinations result in unknown behavior
log:
	$ Steven 10/12/2024: initial creation
	$ Steven 10/13/2024: added ability to load in parallel and shift out
*/
module shiftregister
#(parameter length = 8)
(
input data_recieve,
output reg data_transmit,
output reg[length-1:0] parallel_output,
input[length-1:0] parallel_input,
input shift,
input parallel_enable,
input direction, //0 is left(in), 1 is right(out)
input clk,
input rstn
);

//actual shift register
reg[length-1:0] shift_register;

//at clk edge or rstn
always@(posedge clk or negedge rstn)
begin
//if rstn is hit
	if(rstn == 0)
		begin
			shift_register <= 0;
			parallel_output <= 0;
		end
//else if clk is rising edge and the shift signal is high
	else if (shift == 1)
		begin
		//shift in values (left shift)
			if(direction == 0)
				begin
					shift_register<={shift_register[length-2:0],data_recieve};
				end
			//shift out values (right shift)
			else if(direction == 1)
				begin
					shift_register<={1'b0,shift_register[length-1:1]};
					data_transmit <= shift_register[0];
				end
		end
//else if clk is rising edge and parallel enable is high and direction is in
	else if(parallel_enable == 1 && direction == 0)
		begin
			parallel_output <= shift_register;
		end
//else if clk is rising edge and parallel enable is high and direction is out
	else if(parallel_enable == 1 && direction == 1)
		begin
			shift_register <= parallel_input;
		end
//invalid case
	else
		begin
			shift_register = shift_register;
			parallel_output = parallel_output;
		end
		
end

endmodule