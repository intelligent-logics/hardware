// clkgater.v

// Generated using ACDS version 16.0 211

`timescale 1 ps / 1 ps
module clkgater (
		input  wire  inclk,  //  altclkctrl_input.inclk
		input  wire  ena,    //                  .ena
		output wire  outclk  // altclkctrl_output.outclk
	);

	clkgater_altclkctrl_0 altclkctrl_0 (
		.inclk  (inclk),  //  altclkctrl_input.inclk
		.ena    (ena),    //                  .ena
		.outclk (outclk)  // altclkctrl_output.outclk
	);

endmodule