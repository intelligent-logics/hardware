//spi_toplevel.v
/*
	Author(s): Steven Miller
	Date created: November 8 2024
	Purpose: SPI slave test
	Notes:
	Log:
		$ November 8 2024 Steven: Initial creation.
*/

module spi_toplevel
(
	input i_clk,
	input i_spi_clk,
	input i_capturebyte,
	output o_miso

);

SPI spi
  (
   // Control/Data Signals,
   .i_Rst_L(1'h1),    // FPGA Reset, active low
   .i_Clk(i_clk),      // FPGA Clock
   .i_TX_DV(i_capturebyte),    // Data Valid pulse to register i_TX_Byte
   .i_TX_Byte(8'b01010101),  // Byte to serialize to MISO.
   .i_SPI_Clk(i_spi_clk),
   .i_SPI_MOSI(1'hz),
   .i_SPI_CS_n(1'h0),        // active low
	//.o_RX_DV(),    // Data Valid pulse (1 clock cycle)
   //.o_RX_Byte(),  // Byte received on MOSI
	.o_SPI_MISO(o_miso),
   );
	
endmodule