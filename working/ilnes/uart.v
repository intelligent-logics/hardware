//UART.v
/*
Author(s): Steven Miller
Date created: October 12 2024
Purpose: uart recieving and transmitting

Notes:
	$ Steven 10/12/2024: initial creation
*/

module uart
#(parameter length = 8)
(
input data_reciever,
output data_transmitter,
input clk,
input[length-1:0] data_tosend,
output[length-1:0] data_recieved
);


/*registers*/
reg tx_shift_signal;


/*modules*/

endmodule