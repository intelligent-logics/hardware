//HDMI_toplevel.v
/*
Author(s): Steven Miller
Date created: October 17 2024
Purpose: sets up HDMI(hopefully)
Notes: Not my code. Taken from various sources that im too lazy to list rn.
log:
	$ Steven 10/17/2024: initial creation
*/


module HDMI_toplevel
(
	input clk50,
	input rstn,
	//HDMI data
	output HDMI_HS,
	output HDMI_VS,
	output[23:0] HDMI_RGB,
	output HDMI_CLK,
	output HDMI_DE,
	output HDMI_READY,
	//HDMI i2c
	output HDMI_SCL,
	inout HDMI_SDA,
	input HDMI_TXINT
);


top_sync_vg_pattern
sync_pattern
(

.clk_in(clk50),

.resetb(rstn),

.adv7511_hs(HDMI_HS), // HS output to ADV7511

.adv7511_vs(HDMI_VS), // VS output to ADV7511

.adv7511_clk(HDMI_CLK), // ADV7511: CLK

.adv7511_d(HDMI_RGB), // data

.adv7511_de(HDMI_DE), // ADV7511: DE

//input wire [5:0] pb

) ;


//im 99% sure this works

// **I2C Interface for ADV7513 initial config**
I2C_HDMI_Config #(
  .CLK_Freq (50000000), // we work with a 50MHz clock
  .I2C_Freq (20000)   // 20kHz clock for I2C clock
  )

  I2C_HDMI_Config (
  .iCLK        (clk50),
  .iRST_N      (rstn),
  .I2C_SCLK    (HDMI_SCL),
  .I2C_SDAT    (HDMI_SDA),
  .HDMI_TX_INT (HDMI_TXINT),
  .READY       (HDMI_READY)
);
endmodule