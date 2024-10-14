//UART_tx.v
/*
Author(s): Steven Miller
Date created: October 12 2024
Purpose: uart recieving

Notes:
	$ Steven 10/12/2024: initial creation
	$ Steven 10/13/2024: able to send data
*/
module uart_tx
#(parameter length = 8)
(
output data_transmitter, //wire that transmits data bit
input clk,
input[length-1:0] data_transmit_register,
input shiftout,
input rstn,
output reg data_transmitted_signal,
output[1:0] current_state
);

/*regs*/
reg shift_signal;
reg parallel_enable_signal;
reg[1:0] state = 0;
reg[(length/2)-1:0] cycle_counter = 0;
assign current_state = state;


/*modules*/
/*
	bit 2: parallel enable bit 1: direction bit 0: shift 
	000: all outputs are latched <--- use this
	001: shift register recieves input 
	100: shift register outputted in parallel 
	110: shift register loaded in parallel <--- use this
	011: shift register sends output <--- use this
	assume all other combinations result in unknown behavior
*/

 shiftregister 
 txshiftregister
(
//.data_recieve,
.data_transmit(data_transmitter),
//.parallel_output(),
.parallel_input(data_transmit_register),
.shift(shift_signal),
.parallel_enable(parallel_enable_signal),
.direction(1), //0 is left(in), 1 is right(out)
.clk(clk),
.rstn(rstn)
);

always@(posedge clk or negedge rstn)
	begin
		if(rstn == 0)
			begin
				state <= 0;
				cycle_counter <= 0;
				shift_signal <= 0;
				parallel_enable_signal <= 0;
				
			end
		else
			case(state)
				//wait for signal to shift out
				2'h0:
					begin
						parallel_enable_signal <= 0;
						//direction <=1
						shift_signal <= 0;
						//go to recieving state
						if(shiftout == 1)
							begin
								state = 1;
							end
						//continue waiting
						else
							begin
								state = 0;
							end
					end
				//load shift register with data	
				2'h1:
					begin
						parallel_enable_signal <= 1;
						//direction <=1
						shift_signal <= 0;
						data_transmitted_signal <=0;
						state = 2;
					end
				//start shifting out
				2'h2:
					begin
						parallel_enable_signal <= 0;
						//direction <=1
						shift_signal <= 1;
						data_transmitted_signal <=0;
						//if we shifted out the specified number of bits
						if(cycle_counter == length-1)
							begin
								cycle_counter = 0;
								state = 3;
							end
						//continue shifting
						else
							begin
								cycle_counter = cycle_counter + 1;
								state = 2;
							end
					end
				2'h3:
					begin
						//tell controller its data has been sent
						parallel_enable_signal <= 0;
						//direction <=1
						shift_signal <= 0;
						data_transmitted_signal <= 1;
						state = 0;
					end
			endcase
	end
endmodule