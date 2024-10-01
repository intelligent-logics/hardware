//basics of variables.
//referenced from:
//https://www.chipverify.com/verilog/verilog-data-types

//variables are how we represent data storage elements,
//like flip flops and latches, in verilog.

//variable types:

reg[7:0] 8bitreg = 100; //represents an 8 bit register
reg[4:0] 5bitreg = 100; //represents a 5 bit register

integer a = 20; //integers are 32 bits and can be used to store integer values

time beg_time; //time variables are 64 bit variables that can be used to store simulation times for debugging
realtime end_time; //same as time but it can store floats
real thousand; //a real variable can store floating point values and is assigned the same as an integer or reg

wire[3:0] wire0; //a wire connects logic elements together
wire[5:0] wire1; //6 bit wire

//these variables are available in verilog
//in system verilog, you have all the above but also
//have access to a string
string sussy = "sussy baka!"; //string thats stored in a register

//in verilog, you would need to use a register to represent strings
reg[8*10:0] sussy = "sussy baka!";//same string but verilog
//note that [8*10:0] is the lazy way of saying [80:1]
//because each character in the string requires 8 bits

//you can assign values to wires just like regs or variables
assign wire0 = 0; //assign 0 to all wires
assign wire1[0] = 1; //assign 1 to first wire of wire 1
assign wire1[5:3] = 0; //assign 0 to wires 5 down to 3 of wire 1
//note that you MUST use the assign operator
//the following is not valid:
wire1 = 0;
//this throws an error
