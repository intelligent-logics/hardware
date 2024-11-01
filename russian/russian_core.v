//russian_core.v
/*
Author(s): Steven Miller
Date created: October 14 2024
Purpose: top level for russian core
log:
	$ Steven 10/14/2024: initial creation
*/
module russian_core
(
input clk50mhz,
input rstn,
input [15:0] debug_addressinput,
input [7:0] debug_datainput,
input [1:0] debug_addresselect,
input debug_stopclock,
input debug_manualclock,
output [15:0] debug_addressoutput,
output [7:0] debug_dataoutput,
output debug_clk
);

/*wires*/
wire[15:0] cpu_addressbus;
wire[7:0] cpu_databus;
wire cpu_nmi;
wire cpu_rnw;
wire cart_clk;
wire ppu_le;
wire[13:0] ppu_addressdatabus;
wire[10:0] ppu_vram;
wire[7:0] ppu_latchoutput;
wire ppu_csn;
wire ppu_wrn;
wire ppu_rdn;
wire[3:0] dmx_y1;
wire[3:0] dmx_y2;
wire clk;
wire fast_clk;
wire [23:0] rgb_data;
wire[15:0] memorycontroller_addressout;
wire[7:0] cartridge_databus;
wire[7:0] wram_databus;
wire[7:0] ppu_databus;
assign debug_addressoutput = memorycontroller_addressout;//(debug_addresselect == 2'b00) ? cpu_addressbus : (debug_addresselect == 2'b01) ? ppu_addressdatabus : (debug_addresselect == 2'b10) ? memorycontroller_addressout :16'bZ;
assign debug_dataoutput = cpu_databus;
assign debug_clk = clk;

//(clk & debug_stopclock) | (debug_manualclock);

/*pll*/
//nes runs at 21.47727 MHZ
clkpll_0002 nesclk(

	// interface 'refclk'
	.refclk(clk50mhz),

	// interface 'reset'
	.rst(~rstn),

	// interface 'outclk0'
	.outclk_0(fast_clk)
);
/*clock divider*/
clock_divider clkdivider
(
.clk(fast_clk),
.rstn(rstn),
.out(clk)
);
/*APU and CPU*/
RP2A03 apu
(
   // Clocks
.Clk((clk & debug_stopclock) | (~debug_manualclock)),               // Clock             
   // Inputs
   .PAL(0),               // PAL mode 	
	.nNMI(cpu_nmi),              // Non-maskable interrupt input	
	.nIRQ_EXT(),          // Interrupt request input
	.nRES(rstn),              // Reset signal
	// Outputs
	.DB(cpu_databus),          // Data bus
	.ADDR_BUS(cpu_addressbus),   // Address Bus
   .RnW(cpu_rnw),              // External pin Read/Write
	.M2_out(cart_clk),           // CPU phase M2 (external pin)
   .SQA(), 	       // Square Channel A Output
   .SQB(), 	       // Square Channel B Output
	.RND(), 	       // Noise channel output
	.TRIA(), 	    // Triangular channel output
	.DMC(), 	       // Delta Modulation Channel Output
	.SOUT(), 	    // Channel sum output SQA + SQB + RND + TRIA 
   .OUT(), 	       // Peripheral port output
   .nIN() 	       // Peripheral port output
);
/*PPU*/
/*
RP2C02 PPU
(
   .Clk((clk & debug_stopclock) | (~debug_manualclock)),               // System clock
   .Clk2(),	             // Clock 21.477/26.601 for divider
   // Inputs
   . MODE(0),              // PAL/NTSC mode
	. nRES(rstn),              // Reset signal
   . RnW(cpu_rnw),               // External Pin Read/Write	
   . nDBE(dmx_y2[1]),              // PPU access strobe
	. A(cpu_addressbus[2:0]),            // Register address
	. PD(),           // PPU Graphics Data Bus Input
	// Outputs
	.DB(ppu_databus),           // CPU External Data Bus
	. PCLK(),             // Clock for external DAC
	. RGB(rgb_data),        // RGB output
	. PAD(ppu_addressdatabus),        // PPU Bus Address Output
	. INT(cpu_nmi),              // NMI Interrupt Request Output
	. ALE(ppu_le),              // ALE VRAM Address Low Byte Latch Strobe Output
	. WR(ppu_wrn),               // VRAM Write Strobe	
	. RD(ppu_rdn),               // VRAM Read Strobe
	. SYNC()             // Composite sync output
	//. DBIN(),        // CPU Internal Data Bus (ignore?)
	//. DB_PAR()            // Forwarding CPU data to PPU bus (ignore?)
);
*/
/*
nbitlatch ppulatch
(
.data(ppu_addressdatabus[7:0]),
.latch_enable(ppu_le),
.outputenablen(0),
.Q(ppu_latchoutput)
);


singleportram vram
(
	//.clk(),
	.address({ppu_addressdatabus[10:8],ppu_latchoutput[7:0]}),
	.data(ppu_addressdatabus[7:0]),
	.csn(0), //ACTIVE LOW
	.wen(ppu_wrn), //ACTIVE LOW
	.oen(ppu_rdn)//ACTIVE LOW
);

singleportram wram
(
	//.clk(),
	.address(cpu_addressbus[10:0]),
	.data(wram_databus),
	.csn(dmx_y2[0]), //ACTIVE LOW
	.wen(cpu_rnw), //ACTIVE LOW
	.oen(0)//ACTIVE LOW
);
ls139 dmx
(
	.A({cpu_addressbus[15],cpu_addressbus[0]}),
	.B(cpu_addressbus[14:13]),
	.G1n(0),
	.G2n(dmx_y1[1]),
	.Y1(dmx_y1),
	.Y2(dmx_y2)
);

*/
MemController memory_controller
(
	 .address_in(cpu_addressbus), // From CPU 
    .rw_enable(cpu_rnw),  // 1 for write, 0 for read
    .r_en(ram_readenable),  // READ enable signal to RAM
    .w_en(ram_writeenable),   // Write enable signal to RAM
	 .address_out(memorycontroller_addressout) //MemController -> Cartridge RAM, Shifted by $8000
);

game_ram	cartridge
(
	.address(memorycontroller_addressout),
	.clock (cart_clk),
	.data (cpu_databus),
	.rden (ram_readenable),
	.wren (ram_writeenable),
	.q (cartridge_databus)
);


datacontroller datacontrol
(
    .address_in(cpu_addressbus), // From CPU  
	 .data_from_cart(cartridge_databus), //databus coming from cartridge
	 .data_wram(wram_databus),  //databus for wram and memory controller
	 .data_ppu(ppu_databus), //databus for ppu
	 .data_cpu(cpu_databus) //databus for cpu and memory controller
);

endmodule