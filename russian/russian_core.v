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
assign debug_addressoutput = cpu_addressbus;
assign debug_dataoutput = cpu_databus;
wire fast_clk;
assign debug_clk = clk;

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
.Clk(clk),               // Clock             
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
RP2C02 PPU
(
   .Clk(clk),               // System clock
   .Clk2(),	             // Clock 21.477/26.601 for divider
   // Inputs
   . MODE(0),              // PAL/NTSC mode
	. nRES(rstn),              // Reset signal
   . RnW(cpu_rnw),               // External Pin Read/Write	
   . nDBE(dmx_y2[1]),              // PPU access strobe
	. A(cpu_addressbus[2:0]),            // Register address
	. PD(),           // PPU Graphics Data Bus Input
	// Outputs
	.DB(cpu_databus),           // CPU External Data Bus
	. PCLK(),             // Clock for external DAC
	. RGB(),        // RGB output
	. PAD(ppu_addressdatabus),        // PPU Bus Address Output
	. INT(cpu_nmi),              // NMI Interrupt Request Output
	. ALE(ppu_le),              // ALE VRAM Address Low Byte Latch Strobe Output
	. WR(ppu_wrn),               // VRAM Write Strobe	
	. RD(ppu_rdn),               // VRAM Read Strobe
	. SYNC()             // Composite sync output
	//. DBIN(),        // CPU Internal Data Bus (ignore?)
	//. DB_PAR()            // Forwarding CPU data to PPU bus (ignore?)
);

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
	.data(cpu_databus[7:0]),
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
endmodule