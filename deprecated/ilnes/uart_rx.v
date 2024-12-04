//UART_rx.v
/*
Author(s): Steven Miller
Date created: October 12 2024
Purpose: uart recieving

Notes:
	$ Steven 10/12/2024: initial creation
	$ Steven 10/13/2024: able to recieve data
*/
module uart_rx
#(parameter length = 8)
(
input data_reciever,
input clk,
input shiftin,
input rstn,
output[length-1:0] data_recieved_register,
output reg data_recieved_signal,
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
	001: shift register recieves input <--- use this
	100: shift register outputted in parallel <--- use this
	110: shift register loaded in parallel
	011: shift register sends output
	assume all other combinations result in unknown behavior
*/
shiftregister
rxshiftregister
(
.data_recieve(data_reciever),
//.data_transmit(),
.parallel_output(data_recieved_register),
.parallel_input(0),
.shift(shift_signal),
.parallel_enable(parallel_enable_signal),
.direction(0), //0 is left(in), 1 is right(out)
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
			begin
				case(state)
						//wait for signal to shift in
						2'h0:
							begin
							parallel_enable_signal <= 0;
							//direction <=0
							shift_signal <= 0;
							//go to recieving state
							if(shiftin == 1)
								begin
									state = 1;
								end
							//continue waiting
							else
								begin
									state = 0;
								end
							end
						//shifting state
						2'h1:
							begin
							parallel_enable_signal <= 0;
							//direction <=0
							shift_signal <= 1;
							data_recieved_signal <=0;
							//if we shifted in the specified number of bits
							if(cycle_counter == length-1)
								begin
									cycle_counter = 0;
									state = 2;
								end
							//continue shifting
							else
								begin
									cycle_counter = cycle_counter + 1;
									state = 1;
								end
							end
						//stop shifting and get the parallel output
						2'h2:
							begin
							parallel_enable_signal <= 1;
							//direction <=0
							shift_signal <= 0;
							data_recieved_signal <=0;
							state = 3;
							end
						2'h3:
							begin
						//tell controller its data is ready
							parallel_enable_signal <= 0;
							//direction <=0
							shift_signal <= 0;
							data_recieved_signal <= 1;
							state = 0;
						
							end
							
				endcase
			end
	end

endmodule