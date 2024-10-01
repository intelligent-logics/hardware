//examples of module declaration

//here i will make a very simple d flip flop

//declaring a new component that will contain some logic
module dff(input d, input clk, input rstn, output reg q);

always @ (posedge clk) 
begin
if(!rstn)
	q <= 0;
else
	q <= d;
	
end

endmodule
