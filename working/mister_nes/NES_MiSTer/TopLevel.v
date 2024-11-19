//TopLevel.v
/*
	Author(s): Steven Miller
	Date created: November 7 2024
	Purpose: top level with SPI integrated
	Notes: 
	Log:
		$ November 7 2024 Steven: Initial creation.
*/

module TopLevel
(
	/////////// CLOCK //////////
	input         FPGA_CLK1_50,
	input         FPGA_CLK2_50,
	input         FPGA_CLK3_50,

	//////////// HDMI //////////
	output        HDMI_I2C_SCL,
	inout         HDMI_I2C_SDA,

	output        HDMI_MCLK,
	output        HDMI_SCLK,
	output        HDMI_LRCLK,
	output        HDMI_I2S,

	output        HDMI_TX_CLK,
	output        HDMI_TX_DE,
	output [23:0] HDMI_TX_D,
	output        HDMI_TX_HS,
	output        HDMI_TX_VS,
	
	input         HDMI_TX_INT,

	//////////// SDR ///////////
	output [12:0] SDRAM_A,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nWE,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nCS,
	output  [1:0] SDRAM_BA,
	output        SDRAM_CLK,
	output        SDRAM_CKE,

`ifdef MISTER_DUAL_SDRAM
	////////// SDR #2 //////////
	output [12:0] SDRAM2_A,
	inout  [15:0] SDRAM2_DQ,
	output        SDRAM2_nWE,
	output        SDRAM2_nCAS,
	output        SDRAM2_nRAS,
	output        SDRAM2_nCS,
	output  [1:0] SDRAM2_BA,
	output        SDRAM2_CLK,

`else
	//////////// VGA ///////////
	//output  [5:0] VGA_R,
	//output  [5:0] VGA_G,
	//output  [5:0] VGA_B,
	inout         VGA_HS,
	output		  VGA_VS,
	input         VGA_EN,  // active low

	/////////// AUDIO //////////
	output		  AUDIO_L,
	output		  AUDIO_R,
	output		  AUDIO_SPDIF,

	//////////// SDIO ///////////
	inout   [3:0] SDIO_DAT,
	inout         SDIO_CMD,
	output        SDIO_CLK,

	//////////// I/O ///////////
	output        LED_USER,
	output        LED_HDD,
	output        LED_POWER,
	input         BTN_USER,
	input         BTN_OSD,
	input         BTN_RESET,
`endif

	////////// I/O ALT /////////
	output        SD_SPI_CS,
	input         SD_SPI_MISO,
	output        SD_SPI_CLK,
	output        SD_SPI_MOSI,

	inout         SDCD_SPDIF,
	output        IO_SCL,
	inout         IO_SDA,

	////////// ADC //////////////
	output        ADC_SCK,
	input         ADC_SDO,
	output        ADC_SDI,
	output        ADC_CONVST,

	////////// MB KEY ///////////
	input   [1:0] KEY,

	////////// MB SWITCH ////////
	input   [3:0] SW,

	////////// MB LED ///////////
	output  [7:0] LED,

	///////// USER IO ///////////
	inout   [6:0] USER_IO,
	
	//spi module
	output[7:0] o_instructionlatch_Q, //added by steven miller on november 15 2024
	input i_capturebyte //added by steven miller on november 15 2024
	//input i_spi_clk,//added by steven miller on november 7 2024
	//input i_csn,//added by steven miller on november 7 2024
	//output o_datasent//added by steven miller on november 7 2024
);

//wires
wire w_databyte;
wire w_reset;
instructionlatch instructionlatch
  (
   .i_data(w_databyte),
	.i_latch_enable(i_capturebyte),
	.o_Q(o_instructionlatch_Q)
   );

sys_top mister_top
(
	/////////// CLOCK //////////
	.FPGA_CLK1_50(FPGA_CLK1_50),
	.FPGA_CLK2_50(FPGA_CLK2_50),
	.FPGA_CLK3_50(FPGA_CLK3_50),

	//////////// HDMI //////////
	.HDMI_I2C_SCL(HDMI_I2C_SCL),
	.HDMI_I2C_SDA(HDMI_I2C_SDA),
	
	.HDMI_MCLK(HDMI_MCLK),
	.HDMI_SCLK(HDMI_SCLK),
	.HDMI_LRCLK(HDMI_LRCLK),
	.HDMI_I2S(HDMI_I2S),
	
	.HDMI_TX_CLK(HDMI_TX_CLK),
	.HDMI_TX_DE(HDMI_TX_DE),
	.HDMI_TX_D(HDMI_TX_D),
	.HDMI_TX_HS(HDMI_TX_HS),
	.HDMI_TX_VS(HDMI_TX_VS),
	
	.HDMI_TX_INT(HDMI_TX_INT),

	//////////// SDR ///////////
	.SDRAM_A(SDRAM_A),
	.SDRAM_DQ(SDRAM_DQ),
	.SDRAM_DQML(SDRAM_DQML),
	.SDRAM_DQMH(SDRAM_DQMH),
	.SDRAM_nWE(SDRAM_nWE),
	.SDRAM_nCAS(SDRAM_nCAS),
	.SDRAM_nRAS(SDRAM_nRAS),
	.SDRAM_nCS(SDRAM_nCS),
	.SDRAM_BA(SDRAM_BA),
	.SDRAM_CLK(SDRAM_CLK),
	.SDRAM_CKE(SDRAM_CKE),

`ifdef MISTER_DUAL_SDRAM
	////////// SDR #2 //////////
	.SDRAM2_A(SDRAM2_A),
	.SDRAM2_DQ(SDRAM2_DQ),
	.SDRAM2_nWE(SDRAM2_nWE),
	.SDRAM2_nCAS(SDRAM2_nCAS),
	.SDRAM2_nRAS(SDRAM2_nRAS),
	.SDRAM2_nCS(SDRAM2_nCS),
	.SDRAM2_BA(SDRAM2_BA),
	.SDRAM2_CLK(SDRAM2_CLK),

`else
	//////////// VGA ///////////
	//output  [5:0] VGA_R,
	//output  [5:0] VGA_G,
	//output  [5:0] VGA_B,
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.VGA_EN(VGA_EN),  // active low

	/////////// AUDIO //////////
	.AUDIO_L(AUDIO_L),
	.AUDIO_R(AUDIO_R),
	.AUDIO_SPDIF(AUDIO_SPDIF),

	//////////// SDIO ///////////
	.SDIO_DAT(SDIO_DAT),
	.SDIO_CMD(SDIO_CMD),
	.SDIO_CLK(SDIO_CLK),

	//////////// I/O ///////////
	.LED_USER(LED_USER),
	.LED_HDD(LED_HDD),
	.LED_POWER(LED_POWER),
	.BTN_USER(BTN_USER),
	.BTN_OSD(BTN_OSD),
	.BTN_RESET(BTN_RESET),
`endif

	////////// I/O ALT /////////
	.SD_SPI_CS(SD_SPI_CS),
	.SD_SPI_MISO(SD_SPI_MISO),
	.SD_SPI_CLK(SD_SPI_CLK),
	.SD_SPI_MOSI(SD_SPI_MOSI),
	.SDCD_SPDIF(SDCD_SPDIF),
	.IO_SCL(IO_SCL),
	.IO_SDA(IO_SDA),

	////////// ADC //////////////
	.ADC_SCK(ADC_SCK),
	.ADC_SDO(ADC_SDO),
	.ADC_SDI(ADC_SDI),
	.ADC_CONVST(ADC_CONVST),

	////////// MB KEY ///////////
	.KEY(KEY),

	////////// MB SWITCH ////////
	.SW(SW),

	////////// MB LED ///////////
	.LED(LED),

	///////// USER IO ///////////
	.USER_IO(USER_IO),
	
	.cpu_debug_instruction(w_databyte), //added by steven miller on october 31 2024
	//system_clock //added by steven miller on october 31 2024
	.o_reset(w_reset)
);

endmodule