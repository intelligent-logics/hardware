`timescale 1ns / 1ps


module fpganes_tb();
reg clk,rst;
fpganes_clone u_dut(

	//////////// CLOCK //////////
	.CLOCK2_50(),
	.CLOCK3_50(),
	.CLOCK4_50(),
	.CLOCK_50(clk),

	//////////// SEG7 //////////
	.HEX0(),
	.HEX1(),
	.HEX2(),
	.HEX3(),
	.HEX4(),
	.HEX5(),

	//////////// KEY //////////
	.KEY({3'b000,rst}),

	//////////// LED //////////
	.LEDR(),

	//////////// SW //////////
	.SW(),

	//////////// VGA //////////
	.VGA_BLANK_N(),
	.VGA_B(),
	.VGA_CLK(),
	.VGA_G(),
	.VGA_HS(),
	.VGA_R(),
	.VGA_SYNC_N(),
	.VGA_VS(),

	
	.GPIO()
);


initial begin
rst=1'b1;
#10;
rst=1'b0;
#30;
rst=1'b1;
end
initial begin
forever begin
clk=1'b1;
#10;
clk=1'b0;
#10;
end
end
endmodule