//procedural logic
//examples of procedural logic in verilog
//referenced from:
//https://www.chipverify.com/verilog/verilog-operators

//procedural logic is the same as sequential logic

//we execute sequential logic by using the always operator

always @(<sensitivity list>)

begin

end

//the sensitivity list is the list of signals that triggers the always block to execute

//if any one of the signals changes in value, the always block is immediately executed.

//example:

always@(A or B)

begin
if(A == 1)
	output <= 1;
else if(B == 1)
	output <= 1;
else
output <= 0;
end

end;

//this is a simple or gate. this is an example of how an always block can represent combinational logic

//another example:

always @ (posedge clk or rst)

begin

if(clk == 1)

	output <= input;
else if(rst == 0;)
	output <= 0;
end

end

//here, weve made sequential logic. a simple flip flop

//if else statements are examples of sequential logics.
//logic that is executed one after the other

//if else statements MUST be wrapped in an always block

//if else example
if(A == B)
 begin
 output <= A + B;
 cout <= A - B;
 end
//if a block contains more than one statement, it must be wrapped
//in "begin" and "end"
 else
 begin
 output <= 0;
 cout <= 0;
 end
end;

//for loops can also be used like in C
always @(posedge clk) //anything can be in the sensitivity list but clock is convenient
begin
      for(ii=0; ii<3; ii=ii+1)
        r_Shift_With_For[ii+1] <= r_Shift_With_For[ii];
end

//case statements are the same as if else statements
always@(a,b,c,sel) 
begin

case(sel)
0 : out = a; //if sel is equal to 0
1 : out = b; //if sel is equal to 1
2 : out = c; //if sel is equal to 2
default: out = 0; //default selection
endcase

end
