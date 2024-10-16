//translated by steven miller on september 19 2024
/**
Description,
Top module that sends the communication signals generated by VGA to the
HDMI ADV7513 chip, providing it with a 25MHz clock.

This chip must first start a configuration routine via i2c,
for more information check the datasheet.

-----------------------------------------------------------------------------
Author : Nicolas Hasbun, nhasbun@gmail.com
File   : topModule.v
Create : 2017-06-15 23:21:31
Editor : sublime text3, tab size (2)
-----------------------------------------------------------------------------
*/

`include "vgaHdmi.v"
`include "i2c/I2C_HDMI_Config.v"

module TopModule(
  // **input**
  input clock50, reset_n,

  // ********************************** //
  // ** HDMI CONNECTIONS **

  // AUDIO
  // SPDIF is disconnected
  output HDMI_I2S0,  // don't care, they're not used
  output HDMI_MCLK,  // don't care, they're not used
  output HDMI_LRCLK, // don't care, they're not used
  output HDMI_SCLK,   // don't care, they're not used

  // VIDEO
  input[7:0] vgared,vgagreen,vgablue,
  output [23:0] HDMI_TX_D, // RGBchannel
  output HDMI_TX_VS,  // vsync
  output HDMI_TX_HS,  // hsync
  output HDMI_TX_DE,  // dataEnable
  output HDMI_TX_CLK, // vgaClock

  // REGISTERS AND CONFIG LOGIC
  // HPD comes from the connector
  input HDMI_TX_INT,
  inout HDMI_I2C_SDA,  // HDMI i2c data
  output HDMI_I2C_SCL, // HDMI i2c clock
  output READY,        // HDMI is ready signal from i2c module
  // ********************************** //
  //debugging
  output int_led,
  output locked_led,
  output reset_led
  );

wire clock25, locked;
wire reset;
assign reset = ~reset_n; //board reset pressed works with negative logic
assign int_led = HDMI_TX_INT;
assign locked_led = locked;
assign reset_led = reset;


// audio signals in high impedance
assign HDMI_I2S0  = 1'b z;
assign HDMI_MCLK  = 1'b z;
assign HDMI_LRCLK = 1'b z;
assign HDMI_SCLK  = 1'b z;

// **VGA CLOCK**
pll_25 pll_25(
  .refclk(clock50),
  .rst(reset),

  .outclk_0(clock25),
  .locked(locked)
  );

// **VGA MAIN CONTROLLER**
vgaHdmi vgaHdmi (
  //input
  .clock(clock25), 
  .clock50(clock50), 
  .reset(reset),
  .redvga(vgared),
  .greenvga(vgagreen),
  .bluevga(vgablue),
  // output
  .dataEnable (HDMI_TX_DE),
  .vgaClock   (HDMI_TX_CLK),
  .RGBchannel (HDMI_TX_D),
  .hsync      (HDMI_TX_HS),
  .vsync      (HDMI_TX_VS),
);

// **I2C Interface for ADV7513 initial config**
I2C_HDMI_Config #(
  .CLK_Freq (50000000), // we work with a 50MHz clock
  .I2C_Freq (20000)   // 20kHz clock for I2C clock
  )

  I2C_HDMI_Config (
  .iCLK        (clock50),
  .iRST_N      (reset_n),
  .I2C_SCLK    (HDMI_I2C_SCL),
  .I2C_SDAT    (HDMI_I2C_SDA),
  .HDMI_TX_INT (HDMI_TX_INT),
  .READY       (READY)
);

endmodule