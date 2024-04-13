//basics of concatenation
//referenced from:
//https://www.chipverify.com/verilog/verilog-concatenation

//you can concatenate wires, expressions, and sized constants
//together into one signal

wire a,b;

wire[1:0] res;

assign res = {a,b}; //concatenate the two

//you can also concatenate the same signal
//several times into one signal

wire[7:0] replicate

assign replicate = {8{a}};
//this replicates the signal "a" 8 times
//and concatenates

//you can combine the two easy peasy

wire[15:0] repres;

assign repres{8{a},8{b}};
//here, were replicating a and b eight times
//and concatenating them together.
