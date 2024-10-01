//basics of operators
//referenced from:
//https://www.chipverify.com/verilog/verilog-operators

module arithmetic(input[7:0] A, input[7:0] B, input[3:0] op, output[15:0] arithmeticoutput);
always @ (op)
begin

if(op == 0)
//addition
arithmeticoutput <= A + B;
else if(op == 1)
//subtraction
arithmeticoutput <= A - B;
else if(op == 2)
//division
arithmeticoutput <= A/B;
else if(op == 3)
//modulus
arithmeticoutput <= A%B;
else if(op == 4)
//powers
arithmeticoutput <= A**2; //note that either the exponent or base must be a constant number
else if(op ==5)
//and
arithmeticoutput <= A&B;
else if(op == 6)
arithmeticoutput <= A|B;
else if(op == 7)
arithmeticoutput <= ~A;

else
arithmeticoutput <= 0; //making sure there are no inferred latches
//dont need an end here because every if statement is a single line

end
endmodule
