//translated by steven miller on september 19 2024
/**
Description,
Module that synchronizes the signals (hsync and vsync)
of a VGA controller for 640x480 at 60Hz, operating with a 25MHz clock.

It also includes the coordinates of the pixels H (x-axis),
and the pixels V (y-axis), to send the corresponding RGB signal
for each pixel.

-----------------------------------------------------------------------------
Author : Nicolas Hasbun, nhasbun@gmail.com
File   : vgaHdmi.v
Create : 2017-06-15 15:07:05
Editor : sublime text3, tab size (2)
-----------------------------------------------------------------------------
*/

// **Info Source**
// https://eewiki.net/pages/viewpage.action?pageId=15925278
module vgaHdmi(
  // **input**
  input clock, clock50, reset,
  input[7:0] redvga,greenvga,bluevga,

  // **output**
  output reg hsync, vsync,
  output reg dataEnable,
  output reg vgaClock,
  output [23:0] RGBchannel
);

reg [9:0]pixelH, pixelV; // internal state of the pixels of the module

initial begin
  hsync      = 1;
  vsync      = 1;
  pixelH     = 0;
  pixelV     = 0;
  dataEnable = 0;
  vgaClock   = 0;
end

// Pixel Handling and Synchronization

always @(posedge clock or posedge reset) begin
  if(reset) begin
    hsync  <= 1;
    vsync  <= 1;
    pixelH <= 0;
    pixelV <= 0;
  end
  else begin
    // Display Horizontal
    if(pixelH==0 && pixelV!=524) begin
      pixelH<=pixelH+1'b1;
      pixelV<=pixelV+1'b1;
    end
    else if(pixelH==0 && pixelV==524) begin
      pixelH <= pixelH + 1'b1;
      pixelV <= 0; // pixel 525
    end
    else if(pixelH<=640) pixelH <= pixelH + 1'b1;
    // Front Porch
    else if(pixelH<=656) pixelH <= pixelH + 1'b1;
    // Sync Pulse
    else if(pixelH<=752) begin
      pixelH <= pixelH + 1'b1;
      hsync  <= 0;
    end
    // Back Porch
    else if(pixelH<799) begin
      pixelH <= pixelH+1'b1;
      hsync  <= 1;
    end
    else pixelH<=0; // pixel 800

    // Vertical Signal Handling
    // Sync Pulse
    if(pixelV == 491 || pixelV == 492)
      vsync <= 0;
    else
      vsync <= 1;
  end
end

// dataEnable signal
always @(posedge clock or posedge reset) begin
  if(reset) dataEnable<= 0;

  else begin
    if(pixelH >= 0 && pixelH <640 && pixelV >= 0 && pixelV < 480)
      dataEnable <= 1;
    else
      dataEnable <= 0;
  end
end

// VGA pixel clock signal
// Clocks should not directly drive outputs; a trick should be used
initial vgaClock = 0;

always @(posedge clock50 or posedge reset) begin
  if(reset) vgaClock <= 0;
  else      vgaClock <= ~vgaClock;
end

// **************************************************************
// Screen colors using de10nano switches for test
assign RGBchannel[23:16] = redvga;
assign RGBchannel [15:8] = greenvga;
assign RGBchannel  [7:0] = bluevga;

endmodule