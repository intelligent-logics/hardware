//basics of operators
//referenced from:
//https://www.chipverify.com/verilog/verilog-operators

//we can do simple binary addition
	arithmeticoutput <= A + B;
//we can do simple subtraction
	arithmeticoutput <= A - B;
//we can also do binary multiplication
	arithmeticoutput <= A*B;
//we can also do division
	arithmeticoutput <= A/B;
//we can do the modulus
	arithmeticoutput <= A%B;
//we can also do powers
	arithmeticoutput <= A**B;
	
//we can also do relational logic
input[7:0] X; //note that this code is invalid and is just here for context 
if(A<B)
	gte <= X;
else if(A>B)
	gte <= 1;
else if(A>=B)
	gte <= 1;
else if(A<=B)
	gte <= 1;
	
//we can also test equality
//note that relational logic has greater precedence
//than equality. meaning
//relational will execute first if true.

//if A is equal to B, where a result is
//always guaranteed
if(A === B)
	equals <= X;
//if A isnt equal to B, where a result is 
//always guaranteed
else if( A !== B)
	equals <= 0;
//if A is equal to B, where a result
//can be unknown
else if(A == B)
	equals <= X;
//if A isnt equal to B, where a result
//can be unknown
else if(A != B)
	equals <= 0;
	
//we can also perform logical comparisons
//precedence is the same as equality tests

//if A and B are true
if(A && B)
	equals <= X;
//if A isnt equal to B
if( A || B)
	equals <= 0;
//converts non-zero value to zero
equals <= !A;

//we can, unsurprisingly, do binary logic
//operations

//binary and
equals <= A & B;

//binary or
equals <= A | B;

//finally, we can do shifting

//logical shift left 3 times
equals <= A << 3;

//logical shift right 3 times
equals <= A >> 3;

//arithmetic shift left 3 times
equals <= A <<< 3;

//arithmetic shift right 3 times
equals <= A >>> 3;