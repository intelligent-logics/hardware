//top_level.v
/*
	Author(s): Steven Miller 
	Date created: March 19 2024
	Purpose: initializes main NES cpu
	Notes: gg = game genie
	Log:
		$March 19 2024, Steven Miller
        initial creation
		$March 20 2024, Steven Miller
			finished "top_level" module which
			instantiates core itself
*/

//declaration

module top_level
(
//inputs

	input         core_cpu_clk,
	input         core_cpu_reset_cold,
	input   [1:0] core_sys_type,
	
	input         core_cpu_reset,
	
	input         core_pause,
	//input  [63:0] core_cpu_mapper_flags,
	input   [4:0] core_controllers_joypad1_data,   // Port1
	input   [4:0] core_controllers_joypad2_data,   // Port2
	input         core_fds_disk_busy,       // FDS Disk Swap Busy
	input         core_fds_disk_eject,      // FDS Disk Swap Pause
	input         core_fds_disk_autoeject,
	input   [1:0] core_fds_disk_diskside,
	
	input   [4:0] core_audio_audiochannels, // Enabled audio channels
	input         core_video_extrasprites, //line for extra sprites, may not be needed
	input   [1:0] core_video_mask,

	// Access signals for the SDRAM.
	input   [7:0] core_cpu_sdraminterface_memdin,
	input   [7:0] core_cpu_ppuinterface_ppumemdin,

	input  [20:0] core_cpu_sdraminterface_prgmask,
	input  [19:0] core_cpu_sdraminterface_chrmask,

	// Override for BRAM
	input         core_audio_internalaudio,
	input         core_audio_externalaudio,
	input   [7:0] core_cpu_braminterface_din,       // Data from BRAM
	
	//outputs
	output        core_paused,
	output  [1:0] core_cpu_div,
	output [15:0] core_audio_sample,         // sample generated from APU
	
	output  [5:0] core_video_color,          // pixel generated from PPU
	output  [8:0] core_cpu_cycle,
	output  [2:0] core_cpu_emphasis,
	output  [8:0] core_video_scanline,
	
	output  [1:0] core_controllers_joypad_clock,   // Set to 1 for each joypad to clock it.
	output  [2:0] core_controllers_joypad_out,     // Set to 1 to strobe joypads. Then set to zero to keep the value.
	output  [1:0] core_fds_disk_diskside_req,
	output [24:0] core_cpu_sdraminterface_memaddr,
	output        core_cpu_sdraminterface_memread,
	output        core_cpu_sdraminterface_memwrite,
	output  [7:0] core_cpu_sdraminterface_memdout,
	output [21:0] core_cpu_ppuinterface_ppumemaddr,
	output        core_cpu_ppuinterface_ppumemread,
	output        core_cpu_ppuinterface_ppumemwrite,
	output  [7:0] core_cpu_ppuinterface_ppumemdout,
	output        core_cpu_sdraminterface_refresh,
	output [17:0] core_cpu_braminterface_addr,      // address to access
	output  [7:0] core_cpu_braminterface_dout,
	output        core_cpu_braminterface_write,     // is a write operation
	output        core_cpu_braminterface_override,
	output        core_audio_apuce,
	output        core_cpu_savewritten
	
);
//actual behavior code
//wire eject_signal = core_fds_disk_eject | core_fds_disk_autoeject;
NES nes (
	//need to be able to pause the core by just anding it with "core_pause"
	.core_pause		  (core_pause),
	.clk             (core_cpu_clk),
	.reset_nes       (core_cpu_reset),
	.cold_reset      (core_cpu_reset_cold),
	.sys_type        (core_sys_type),
	
	.nes_div         (core_cpu_div),
	.mapper_flags    (core_cpu_mapper_flags),
	 //Audio
	.sample          (core_audio_sample),
	
	.audio_channels  (core_audio_audiochannels),
	
	.int_audio       (core_audio_internalaudio),
	.ext_audio       (core_audio_externalaudio),
	.apu_ce          (core_audio_apuce),
	
	// Video
	.ex_sprites      (core_video_extrasprites),
	.color           (core_video_color),
	.emphasis        (core_cpu_emphasis),
	.cycle           (core_cpu_cycle),
	.scanline        (core_video_scanline),
	.mask            (core_video_mask),
	// User Input
	
	.joypad_out      (core_controllers_joypad_out),
	.joypad_clock    (core_controllers_joypad_clock),
	.joypad1_data    (core_controllers_joypad1_data),
	.joypad2_data    (core_controllers_joypad2_data),
	/*
	.diskside_req    (core_fds_disk_diskside_req),
	.diskside        (core_fds_disk_diskside),
	.fds_busy        (core_fds_disk_busy),
	//im assuming that either a logical "1" from either the eject button
	//OR auto-eject signal will trigger an eject
	.fds_eject       (eject_signal),
	*/
	// Memory transactions
	
	.cpumem_addr     (core_cpu_sdraminterface_memaddr),
	.cpumem_read     (core_cpu_sdraminterface_memread),
	.cpumem_write    (core_cpu_sdraminterface_memwrite),
	.cpumem_dout     (core_cpu_sdraminterface_memdout),
	.cpumem_din      (core_cpu_sdraminterface_memdin),
	.ppumem_addr     (core_cpu_ppuinterface_ppumemaddr),
	.ppumem_read     (core_cpu_ppuinterface_ppumemread),
	.ppumem_write    (core_cpu_ppuinterface_ppumemwrite),
	.ppumem_dout     (core_cpu_ppuinterface_ppumemdout),
	.ppumem_din      (core_cpu_ppuinterface_ppumemdin),
	.core_sdram_refresh(core_cpu_sdraminterface_refresh),

	.prg_mask        (core_cpu_sdraminterface_prgmask),
	.chr_mask        (core_cpu_sdraminterface_chrmask),

	.bram_addr       (core_cpu_braminterface_addr),
	.bram_din        ( core_cpu_braminterface_din),
	.bram_dout       ( core_cpu_braminterface_dout),
	.bram_write      ( core_cpu_braminterface_write),
	.bram_override   (core_cpu_braminterface_override),
	//.save_written    (core_cpu_savewritten),
	//.core_paused	  (core_paused)
	
);
/*
sysmem_lite sysmem
(
	//Reset/Clock
	.reset_core_req(reset_req),
	.reset_out(reset),
	.clock(clk_100m),

	//DE10-nano has no reset signal on GPIO, so core has to emulate cold reset button.
	.reset_hps_cold_req(btn_r),

`ifdef USE_DDRAM
	//64-bit DDR3 RAM access
	.ram1_clk(ram_clk),
	.ram1_address(ram_address),
	.ram1_burstcount(ram_burstcount),
	.ram1_waitrequest(ram_waitrequest),
	.ram1_readdata(ram_readdata),
	.ram1_readdatavalid(ram_readdatavalid),
	.ram1_read(ram_read),
	.ram1_writedata(ram_writedata),
	.ram1_byteenable(ram_byteenable),
	.ram1_write(ram_write),
`endif

	//64-bit DDR3 RAM access
	.ram2_clk(clk_audio),
	.ram2_address(ram2_address),
	.ram2_burstcount(ram2_burstcount),
	.ram2_waitrequest(ram2_waitrequest),
	.ram2_readdata(ram2_readdata),
	.ram2_readdatavalid(ram2_readdatavalid),
	.ram2_read(ram2_read),
	.ram2_writedata(ram2_writedata),
	.ram2_byteenable(ram2_byteenable),
	.ram2_write(ram2_write),

	//128-bit DDR3 RAM access
	// HDMI frame buffer
	.vbuf_clk(clk_100m),
	.vbuf_address(vbuf_address),
	.vbuf_burstcount(vbuf_burstcount),
	.vbuf_waitrequest(vbuf_waitrequest),
	.vbuf_writedata(vbuf_writedata),
	.vbuf_byteenable(vbuf_byteenable),
	.vbuf_write(vbuf_write),
	.vbuf_readdata(vbuf_readdata),
	.vbuf_readdatavalid(vbuf_readdatavalid),
	.vbuf_read(vbuf_read)
);
ddr_svc ddr_svc
(
	.clk(clk_audio),

	.ram_waitrequest(ram2_waitrequest),
	.ram_burstcnt(ram2_burstcount),
	.ram_addr(ram2_address),
	.ram_readdata(ram2_readdata),
	.ram_read_ready(ram2_readdatavalid),
	.ram_read(ram2_read),
	.ram_writedata(ram2_writedata),
	.ram_byteenable(ram2_byteenable),
	.ram_write(ram2_write),
	.ram_bcnt(ram2_bcnt),

	.ch0_addr(alsa_address),
	.ch0_burst(1),
	.ch0_data(alsa_readdata),
	.ch0_req(alsa_req),
	.ch0_ready(alsa_ready),

	.ch1_addr(pal_addr),
	.ch1_burst(128),
	.ch1_data(pal_data),
	.ch1_req(pal_req),
	.ch1_ready(pal_wr)
);

emu emu
(
	.CLK_50M(FPGA_CLK2_50),
	.RESET(reset),
	.HPS_BUS({f1, HDMI_TX_VS, 
				 clk_100m, clk_ihdmi,
				 ce_hpix, hde_emu, hhs_fix, hvs_fix, 
				 io_wait, clk_sys, io_fpga, io_uio, io_strobe, io_wide, io_din, io_dout}),

	.VGA_R(r_out),
	.VGA_G(g_out),
	.VGA_B(b_out),
	.VGA_HS(hs_emu),
	.VGA_VS(vs_emu),
	.VGA_DE(de_emu),
	.VGA_F1(f1),
	.VGA_SCALER(vga_force_scaler),

	.HDMI_WIDTH(direct_video ? 12'd0 : hdmi_width),
	.HDMI_HEIGHT(direct_video ? 12'd0 : hdmi_height),

	.CLK_VIDEO(clk_vid),
	.CE_PIXEL(ce_pix),
	.VGA_SL(scanlines),
	.VIDEO_ARX(ARX),
	.VIDEO_ARY(ARY),

`ifdef USE_FB
	.FB_EN(fb_en),
	.FB_FORMAT(fb_fmt),
	.FB_WIDTH(fb_width),
	.FB_HEIGHT(fb_height),
	.FB_BASE(fb_base),
	.FB_STRIDE(fb_stride),
	.FB_VBL(fb_vbl),
	.FB_LL(lowlat),
	.FB_FORCE_BLANK(fb_force_blank),

	.FB_PAL_CLK (fb_pal_clk),
	.FB_PAL_ADDR(fb_pal_a),
	.FB_PAL_DOUT(fb_pal_d),
	.FB_PAL_DIN (fb_pal_q),
	.FB_PAL_WR  (fb_pal_wr),
`endif

	.LED_USER(led_user),
	.LED_POWER(led_power),
	.LED_DISK(led_disk),

	.CLK_AUDIO(clk_audio),
	.AUDIO_L(audio_l),
	.AUDIO_R(audio_r),
	.AUDIO_S(audio_s),

`ifndef ARCADE_SYS
	.AUDIO_MIX(audio_mix),
	.ADC_BUS({ADC_SCK,ADC_SDO,ADC_SDI,ADC_CONVST}),
`endif

`ifdef USE_DDRAM
	.DDRAM_CLK(ram_clk),
	.DDRAM_ADDR(ram_address),
	.DDRAM_BURSTCNT(ram_burstcount),
	.DDRAM_BUSY(ram_waitrequest),
	.DDRAM_DOUT(ram_readdata),
	.DDRAM_DOUT_READY(ram_readdatavalid),
	.DDRAM_RD(ram_read),
	.DDRAM_DIN(ram_writedata),
	.DDRAM_BE(ram_byteenable),
	.DDRAM_WE(ram_write),
`endif

`ifdef USE_SDRAM
	.SDRAM_DQ(SDRAM_DQ),
	.SDRAM_A(SDRAM_A),
	.SDRAM_DQML(SDRAM_DQML),
	.SDRAM_DQMH(SDRAM_DQMH),
	.SDRAM_BA(SDRAM_BA),
	.SDRAM_nCS(SDRAM_nCS),
	.SDRAM_nWE(SDRAM_nWE),
	.SDRAM_nRAS(SDRAM_nRAS),
	.SDRAM_nCAS(SDRAM_nCAS),
	.SDRAM_CLK(SDRAM_CLK),
	.SDRAM_CKE(SDRAM_CKE),
`endif

`ifdef DUAL_SDRAM
	.SDRAM2_DQ(SDRAM2_DQ),
	.SDRAM2_A(SDRAM2_A),
	.SDRAM2_BA(SDRAM2_BA),
	.SDRAM2_nCS(SDRAM2_nCS),
	.SDRAM2_nWE(SDRAM2_nWE),
	.SDRAM2_nRAS(SDRAM2_nRAS),
	.SDRAM2_nCAS(SDRAM2_nCAS),
	.SDRAM2_CLK(SDRAM2_CLK),
	.SDRAM2_EN(SW[3]),
`endif

`ifndef ARCADE_SYS
	.BUTTONS(btn),
	.OSD_STATUS(osd_status),
	.SD_SCK(SD_CLK),
	.SD_MOSI(SD_MOSI),
	.SD_MISO(SD_MISO),
	.SD_CS(SD_CS),
`ifdef DUAL_SDRAM
	.SD_CD(mcp_sdcd),
`else
	.SD_CD(mcp_sdcd & (SW[0] ? VGA_HS : (SW[3] | SDCD_SPDIF))),
`endif

	.UART_CTS(uart_rts),
	.UART_RTS(uart_cts),
	.UART_RXD(uart_txd),
	.UART_TXD(uart_rxd),
	.UART_DTR(uart_dsr),
	.UART_DSR(uart_dtr),
`endif

	.USER_OUT(user_out),
	.USER_IN(user_in)
);
wire [28:0] ram2_address;
wire  [7:0] ram2_burstcount;
wire  [7:0] ram2_byteenable;
wire        ram2_waitrequest;
wire [63:0] ram2_readdata;
wire [63:0] ram2_writedata;
wire        ram2_readdatavalid;
wire        ram2_read;
wire        ram2_write;
wire  [7:0] ram2_bcnt;
wire reset_req;
*/
endmodule