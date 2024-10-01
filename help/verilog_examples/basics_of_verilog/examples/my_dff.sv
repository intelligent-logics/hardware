//examples of module declaration

//here i will make a very simple d flip flop

//declaring a new component that will contain some logic
module my_dff(input d, input clk, input rstn, output q);

//"always @" is used for when logic depends on edges. such as flip flops and resets
//here, we have a dff that has its logic executed when reset goes low,
//or when the clk has a positive edge
always @ (negedge rstn or posedge clk) 
begin
if(rstn == 0)
	q <= 0;
else
	q <= d;
end

endmodule
