//basics of syntax.
//referenced from: 
//https://www.chipverify.com/verilog/verilog-syntax

/*
because verilog is based around the C language,
we can use variables just like we do in C.
*/

integer a; //this declares an integer
string hello = "hello world!"; //this declares a string

//well get more into datatypes in a seperate file

//there are three types of operators:
x = ~y; //unary
x = y|z; //binary
x = (y > 5) ? w :z; //ternary. this behaves exactly like in C.

//you can also represent numbers a variety of ways
//by default, verilog assumes a number is in base 10 (decimal)

//to specify numbers in a different base, use the following format:
//[size of number in bits]'[base format][number]

//examples:
16; //16 in base 10 (decimal)
5'h16; // 16 in hex 16
5'b10000; //16 in binary
5'o20; //16 in octal

//you can also represent negative numbers 
//by placing a minus sign before [size of number in bits]

//examples:
-16; //-16 in base 10 (decimal)
-5'h16; // -16 in hex 16
-5'b10000; //-16 in binary
-5'o20; //-16 in octal

//identifiers are names of variables and must adhere to the following rules:
//1. made up of alphanumeric characters
//2. can contain a dollar sign but must not start with one
//3. can contain underscores
//4. must not start with a number