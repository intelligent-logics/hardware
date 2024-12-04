//instructionlatch_toplevel.v
/*
Author(s): Steven Miller
Date created: november 15 2024
Purpose: basic n bit latch
log:
	$ Steven 11/15/2024: initial creation
*/

module instructionlatch_toplevel
(
	input i_capturebyte,
	output[7:0] o_instructionlatch_Q0,
	output[7:0] o_instructionlatch_Q1
);

reg [7:0] counter; // Counter register to hold the count value
wire [7:0] w_instructionlatchdata;

// Counter logic
always @(posedge i_capturebyte) begin
    counter <= counter + 1;
end


assign o_instructionlatch_Q0 = w_instructionlatchdata;
assign o_instructionlatch_Q1 = w_instructionlatchdata;
instructionlatch instructionlatch
(
	.i_data(counter),
	.i_latch_enable(i_capturebyte),
	//input outputenablen,
	.o_Q(w_instructionlatchdata)
);
endmodule