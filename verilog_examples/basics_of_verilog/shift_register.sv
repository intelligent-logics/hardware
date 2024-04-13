//examples of module declaration

//here i will make a very simple shift register

//declaring a new component that will call another component

module shift_register(input d, input clk, input rstn, output q); 

//components from outside files are always declared inside modules
my_dff dff0(.d(d),.clk(clk),.rstn(rstn), .q(shift_reg_wires[0]));
my_dff dff1(.d(shift_reg_wires[0]),.clk(clk),.rstn(rstn), .q(shift_reg_wires[1]));
my_dff dff2(.d(shift_reg_wires[1]),.clk(clk),.rstn(rstn), .q(shift_reg_wires[2]));
my_dff dff3(.d(shift_reg_wires[2]),.clk(clk),.rstn(rstn), .q(q));

//need to declare wires to connect components together
//notice that were using "shift_reg_wires" before we even declare them
//this is a hardware description, all code is executed at the same time.
//these wires can be declared anywhere within our module.
wire[3:0] shift_reg_wires;

endmodule