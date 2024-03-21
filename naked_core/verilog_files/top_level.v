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
	input         core_cpu_reset,
	input         core_cpu_reset_cold,
	input         core_pause,
	input   [1:0] core_sys_type,
	input  [63:0] core_cpu_mapper_flags,
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
	//input         core_cpu_gg,
	//input [128:0] core_cpu_ggcode,
	//input         core_cpu_ggreset,
	
	//outputs
	output        core_paused,
	output  [1:0] core_cpu_div,
	output [15:0] core_audio_sample,         // sample generated from APU
	output  [5:0] core_video_color,          // pixel generated from PPU
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
	output  [8:0] core_cpu_cycle,
	output  [8:0] core_video_scanline,
	output        core_audio_apuce,
	//output        core_cpu_ggavail,
	output  [2:0] core_cpu_emphasis,
	output        core_cpu_savewritten
);
//actual behavior code
wire eject_signal = core_fds_disk_eject | core_fds_disk_autoeject;
NES nes (
	//need to be able to pause the core by just anding it with "core_pause"
	.core_pause		  (core_pause),
	.clk             (core_cpu_clk),
	.reset_nes       (core_cpu_reset),
	.cold_reset      (core_cpu_reset_cold),
	.sys_type        (core_sys_type),
	.nes_div         (core_cpu_div),
	.mapper_flags    (core_cpu_mapper_flags),
	//.gg              (core_cpu_gg),
	//.gg_code         (core_cpu_ggcode),
	//.gg_reset        (core_cpu_ggreset),
	//.gg_avail        (core_cpu_ggavail),
	// Audio
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
	.diskside_req    (core_fds_disk_diskside_req),
	.diskside        (core_fds_disk_diskside),
	.fds_busy        (core_fds_disk_busy),
	//im assuming that either a logical "1" from either the eject button
	//OR auto-eject signal will trigger an eject
	.fds_eject       (eject_signal),

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
	.save_written    (core_cpu_savewritten),
	.core_paused	  (core_paused)
);

endmodule