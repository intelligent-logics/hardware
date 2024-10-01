//basics of arrays
//referenced from:
//https://www.chipverify.com/verilog/verilog-arrays-memories

//an interesting feature of verilog is the use of arrays

//i say its interesting because, just like in C how you can
//make arrays, nothing is stopping you from doing the same in verilog

//examples:

//say i wanted to make an array of 1 bit registers
//you might type the following:
reg[7:0] bitarr;
//but this is incorrect! this is a single register that can store 8 bits

//instead, you would type the following:

reg bitarr[7:0];

//we declare a 1 bit register, but we declare 8 of them at once

//we can do the same for wires too!

wire y1[3:0]; //here is an array of 1 bit wires

//we can also declare an array of multiple bit regs and wires!

reg[2:0] example[7:0]; //this is an array of 8 3 bit registers

wire[7:0] y2[7:0]; //an array of 8 3 bit wires

reg[7:0] y3[7:0][7:0] //an 8x8 array of 8 bit registers

//you can access them like the following:

y3[0][0] = 8'haa; // were assigning 10101010 to register number 0,0.
y2[0] = 8'ha2; //were outputting 0xA2 on wire 0

//arrays can be used with regs, wires, integers, and real data types
