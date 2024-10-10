//MOS6502.v
/*
Author(s): Steven Miller
Date created: October 9 2024
Purpose: CPU for NES

Notes:
	$ Steven 10/9/2024: initial creation
*/

//we need the following for inputs and outputs
/*
1 bit clock input
8 bit data input
8 bit data output
16 bit address line output
1 bit reset line
*/

module MOS6502
(
	input[7:0] data_input,
	input clk,
	input nrst, //ACTIVE LOW
	output[7:0] data_output,
	output[15:0] address_output,
	output nrw_output, //ACTIVE LOW
	output clk1 //supposed to be connected to memory or other
	//peripherals, this way when clk is low, clk1 is high so
	//memory can be output on the bus
);

//registers
reg[7:0] register_x; //x register
reg[7:0] register_y; //y register
reg[7:0] register_accumulator; //accumulator register
reg[7:0] register_datainput; //register for data input line
reg[15:0] register_addressoutput; //register for address output lines
reg[7:0] register_cpustatus; //register for processor status
reg[3:0] register_universalstate; //register for when instructions need multiple clock cycles
reg[7:0] register_instructionregister; //register for holding current instruction
reg[15:0] register_programcounter; //our program counter
/*processor status flags*/
/*
N[7]: negative value just occurred with last operation
V[6]: overflow just occurred with last operation
1[5]: permanent 1
B[4]: software interrupt: 1 hardware interrupt: 0
D[3]: Decimal flag, permanently set to 0 since NES doesnt use this
I[2]: Disable interrupt flag
Z[1]: zero values just occurred with last operation
C[0]: carry value just occurred with last operation
*/

//wires
wire clknot = ~clk;
wire address = register_addressoutput;
wire irtodatainput = data_input;
assign register_instructionregister = irtodatainput;
assign clk1 = clknot;
assign address_output = address;
initial
	begin
		register_cpustatus = 00100000;
	end
always@(negedge nrst)
	begin
		register_x = 0;
		register_y = 0;
		register_accumulator = 0;
		register_addressoutput = 0;
		register_cpustatus = 8'b00100000;
		register_universalstate = 0;
		register_instructionregister = 0;
		register_programcounter = 8'h7FFF;
	end
always@(posedge clk)
	begin
			register_programcounter = register_programcounter + 1;
			if(register_universalstate == 0)
				begin
					register_instructionregister = data_input;
				end
	end
endmodule