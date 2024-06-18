//basics of scalars and vectors
//referenced from:
//https://www.chipverify.com/verilog/verilog-scalar-vector

//to make our lives more confusing, the designers of verilog
//use special terms called "scalars" and "vectors"

//to put it simply, a scalar is a datatype of 1 bit length
//a vector is a datatype of multiple bit length

//examples:

//this is a scalar
wire wire0; //since we did not specify a range, verilog assumes this is 1 bit wide

//this is a vector
wire[7:0] four; //we specified a range, so verilog honors it.

reg zero; //this is a scalar reg

reg[7:0] seven; //this is a vector reg

//just like in C how you can select individual elements
//in an array using brackets, the same applies to verilog.

seven[7] = 0; //we set the 8th bit in the to zero

four[7] = seven[7]; //we assign the seventh wire in "four" to the seventh bit in our register

//unlike C, you can select a range of values using the bracket operator

seven[6:4] = 3'h7; //we represent 7 using registers 6 down to 4
//keep in mind, since each register is an individual bit,
//the following is illegal:
seven[6:4] = 7;
//its illegal because its assuming we want to assign register 6 down to 4
//the value seven for EACH ONE. when in reality we want them to each represent
// "1" (because 111 is 7)
//therefore, its best you specify the value in binary.

//interestingly, you can increment the register you want to use

//for example
for(i = 0; i < 4; i++)
begin
	seven[0 +: i] = 0;
end
//this runs through  a loop that sets registers 0 to 3 as 0.
//you can do the same for decrementing
for(i = 3; i >= 0; i--)
begin
	seven[3 -: i] = 0;
end

//this does the same thing but just uses decrementing