`timescale 1ns / 1ps
/*foreach sig [find signals -recursive *] {
    force $sig -deposit 0 -cancel {@1ns}

  }
*/
// Asynchronous PSRAM controller for byte access
// After outputting a byte to read, the result is available 70ns later.
module MemoryController(
                 input clk,
                 input read_a,             // Set to 1 to read from RAM
                 input read_b,             // Set to 1 to read from RAM
                 input write,              // Set to 1 to write to RAM
                 input [23:0] addr,        // Address to read / write
                 input [7:0] din,          // Data to write
                 output reg [7:0] dout_a,  // Last read data a
                 output reg [7:0] dout_b,  // Last read data b
                 output reg busy,          // 1 while an operation is in progress

                 output reg MemOE,         // Output Enable. Enable when Low.
                 output reg MemWR,         // Write Enable. WRITE when Low.
                 output MemAdv,            // Address valid. Keep LOW for Async.
                 output MemClk,            // Clock for sync oper. Keep LOW for Async.
                 output reg RamCS,         // Chip Enable. Active = LOW
                 output RamCRE,            // CRE = Control Register. LOW = Normal mode.
                 output reg RamUB,         // Upper byte enable
                 output reg RamLB,         // Lower byte enable
                 output reg [22:0] MemAdr,
                 inout [15:0] MemDB);
                 
  // These are always low for async operations
  assign MemAdv = 0;
  assign MemClk = 0;
  assign RamCRE = 0;
  reg [7:0] data_to_write;
  assign MemDB = MemOE ? {data_to_write, data_to_write} : 16'bz; // MemOE == 0 means we need to output tristate
  reg [1:0] cycles;
  reg r_read_a;
  
  always @(posedge clk) begin
    // Initiate read or write
    if (!busy) begin
      if (read_a || read_b || write) begin
        MemAdr <= addr[23:1];
        RamUB <= !(addr[0] != 0); // addr[0] == 0 asserts RamUB, active low.
        RamLB <= !(addr[0] == 0);
        RamCS <= 0;    // 0 means active
        MemWR <= !(write != 0); // Active Low
        MemOE <= !(write == 0);
        busy <= 1;
        data_to_write <= din;
        cycles <= 0;
        r_read_a <= read_a;
      end else begin
        MemOE <= 1;
        MemWR <= 1;
        RamCS <= 1;
        RamUB <= 1;
        RamLB <= 1;
        busy <= 0;
        cycles <= 0;
      end
    end else begin
      if (cycles == 2) begin
        // Now we have waited 3x45 = 135ns, latch incoming data on read.
        if (!MemOE) begin
          if (r_read_a) dout_a <= RamUB ? MemDB[7:0] : MemDB[15:8];
          else dout_b <= RamUB ? MemDB[7:0] : MemDB[15:8];
        end
        MemOE <= 1; // Deassert Output Enable.
        MemWR <= 1; // Deassert Write
        RamCS <= 1; // Deassert Chip Select
        RamUB <= 1; // Deassert upper/lower byte
        RamLB <= 1;
        busy <= 0;
        cycles <= 0;
      end else begin
        cycles <= cycles + 1;
      end
    end
  end
endmodule  // MemoryController


// Module reads bytes and writes to proper address in ram.
// Done is asserted when the whole game is loaded.
// This parses iNES headers too.
module GameLoader(input clk, input reset,
                  input [7:0] indata, input indata_clk,
                  output reg [21:0] mem_addr, output [7:0] mem_data, output mem_write,
                  output [31:0] mapper_flags,
                  output reg done,
                  output error);
  reg [1:0] state = 0;
  reg [7:0] prgsize;
  reg [3:0] ctr;
  reg [7:0] ines[0:15]; // 16 bytes of iNES header
  reg [21:0] bytes_left;
  
  assign error = (state == 3);
  wire [7:0] prgrom = ines[4];
  wire [7:0] chrrom = ines[5];
  assign mem_data = indata;
  assign mem_write = (bytes_left != 0) && (state == 1 || state == 2) && indata_clk;
  
  wire [2:0] prg_size = prgrom <= 1  ? 0 :
                        prgrom <= 2  ? 1 : 
                        prgrom <= 4  ? 2 : 
                        prgrom <= 8  ? 3 : 
                        prgrom <= 16 ? 4 : 
                        prgrom <= 32 ? 5 : 
                        prgrom <= 64 ? 6 : 7;
                        
  wire [2:0] chr_size = chrrom <= 1  ? 0 : 
                        chrrom <= 2  ? 1 : 
                        chrrom <= 4  ? 2 : 
                        chrrom <= 8  ? 3 : 
                        chrrom <= 16 ? 4 : 
                        chrrom <= 32 ? 5 : 
                        chrrom <= 64 ? 6 : 7;
  
  wire [7:0] mapper = {ines[7][7:4], ines[6][7:4]};
  wire has_chr_ram = (chrrom == 0);
  assign mapper_flags = {16'b0, has_chr_ram, ines[6][0], chr_size, prg_size, mapper};
  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      done <= 0;
      ctr <= 0;
      mem_addr <= 0;  // Address for PRG
    end else begin
      case(state)
      // Read 16 bytes of ines header
      0: if (indata_clk) begin
           ctr <= ctr + 1;
           ines[ctr] <= indata;
           bytes_left <= {prgrom, 14'b0};
           if (ctr == 4'b1111)
             state <= (ines[0] == 8'h4E) && (ines[1] == 8'h45) && (ines[2] == 8'h53) && (ines[3] == 8'h1A) && !ines[6][2] && !ines[6][3] ? 1 : 3;
         end
      1, 2: begin // Read the next |bytes_left| bytes into |mem_addr|
          if (bytes_left != 0) begin
            if (indata_clk) begin
              bytes_left <= bytes_left - 1;
              mem_addr <= mem_addr + 1;
            end
          end else if (state == 1) begin
            state <= 2;
            mem_addr <= 22'b00_0100_0000_0000_0000_0000; // Address for CHR
            bytes_left <= {1'b0, chrrom, 13'b0};
          end else if (state == 2) begin
            done <= 1;
          end
        end
      endcase
    end
  end
endmodule






//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module fpganes_clone(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire       clock_locked;
wire       clk;
//wire       rst = KEY[0];
wire [7:0] uart_data;
wire [7:0] uart_addr;
wire       uart_write;
wire       uart_error;
wire       UART_TXD;
wire       UART_RXD;
wire [7:0] loader_input = uart_data;
wire       loader_clk   = (uart_addr == 8'h37) && uart_write;
reg  [7:0] loader_conf;
reg  [7:0] loader_btn, loader_btn_2;
reg [14:0] pallut[0:63];
reg [31:0] led_value;
reg [7:0]  led_enable;
wire [8:0] cycle;
wire [8:0] scanline;
wire [15:0] sample;
wire [5:0] color;
wire joypad_strobe;
wire [1:0] joypad_clock;
wire [21:0] memory_addr;
wire memory_read_cpu, memory_read_ppu;
wire memory_write;
wire [7:0] memory_din_cpu, memory_din_ppu;
wire [7:0] memory_dout;
reg [7:0] joypad_bits, joypad_bits2;
reg [1:0] last_joypad_clock;
wire [31:0] dbgadr;
wire [1:0] dbgctr;
reg [1:0] nes_ce;
wire [21:0] loader_addr;
wire [7:0] loader_write_data;
wire loader_reset = loader_conf[0];
wire loader_write;
wire [31:0] mapper_flags;
wire loader_done, loader_fail;
wire reset_nes = (~KEY[0] || !loader_done);
wire run_mem = (nes_ce == 0) && !reset_nes;
wire run_nes = (nes_ce == 3) && !reset_nes;
wire ram_busy;
reg ramfail;
wire [14:0] doubler_pixel;
wire doubler_sync;
wire [9:0] vga_hcounter, doubler_x;
wire [9:0] vga_vcounter;
wire [14:0] pixel_in = pallut[color];
wire [15:0] sound_signal = {sample[15] ^ 1'b1, sample[14:0]};
reg [7:0] sound_ctr;
wire sound_load = /*SW[6] ? sample_now_fir : */(sound_ctr == 0);
wire AUD_MCLK; // do nothing with audio signals
wire AUD_LRCK;
wire AUD_SCK;
wire AUD_SDIN;
assign LEDR = {6'h00, run_mem, run_nes, reset_nes};
wire[3:0] vga_r, vga_g, vga_b;
wire vga_v, vga_h;
wire vga_stall;
//=======================================================
//  Structural coding
//=======================================================
`ifdef MODEL_TECH
  // code for simulation with modelsim
  assign clk_ungated=CLOCK_50;

`else
  alterapll alterapll_inst(.areset(1'b0), .inclk0(CLOCK_50) , .c0(clk_ungated), .locked(clock_locked));// code for synthesis
`endif

//clk_wiz_v3_6 clock_21mhz(.CLK_IN1(CLK100MHZ), .CLK_OUT1(clk),  .RESET(1'b0), .LOCKED(clock_locked));
  assign clk= clk_ungated & ~vga_stall;
// UART
// GPIO[3] as TX output, GPIO[5] as RX input
assign UART_TXD = 1;
assign GPIO[3] = UART_TXD;
assign UART_RXD = GPIO[5];
UartDemux uart_demux(clk, 1'b0, UART_RXD, uart_data, uart_addr, uart_write, uart_error);

// Loader
always @(posedge clk) begin
  if (uart_addr == 8'h35 && uart_write)
    loader_conf <= uart_data;
  if (uart_addr == 8'h40 && uart_write)
    loader_btn <= uart_data;
  if (uart_addr == 8'h41 && uart_write)
    loader_btn_2 <= uart_data;
end

// NES Palette -> RGB332 conversion
initial $readmemh("src/nes_palette.txt", pallut);

// LED Display
assign HEX5 = 7'b0101011;

assign HEX4 = 7'b0000110;
assign HEX3 = 7'b0010010;
assign HEX2 = 7'b0101011;
assign HEX1 = 7'b0000110;
assign HEX0 = 7'b0010010;
// LedDriver led_driver(clk, led_value, led_enable, SSEG_CA, SSEG_AN);

// Joypad
always @(posedge clk) begin
  if (joypad_strobe) begin
    joypad_bits <= loader_btn;
    joypad_bits2 <= loader_btn_2;
  end
  if (!joypad_clock[0] && last_joypad_clock[0])
    joypad_bits <= {1'b0, joypad_bits[7:1]};
  if (!joypad_clock[1] && last_joypad_clock[1])
    joypad_bits2 <= {1'b0, joypad_bits2[7:1]};
  last_joypad_clock <= joypad_clock;
end
  
	
//force outputs
assign loader_write = 0;
assign loader_done = 1;
assign loader_fail = 0;
assign mapper_flags = 32'h00004100;
 //ROM PRELOADED 
// Load ROMs
/*
GameLoader loader(clk, loader_reset, loader_input, loader_clk, loader_addr, loader_write_data, loader_write,mapper_flags, loader_done, loader_fail); 
*/
  // NES is clocked at every 4th cycle.
always @(posedge clk) begin
if(~KEY[0]) begin
  nes_ce <= 'h0;
end else begin
  nes_ce <= nes_ce + 1;
end
end
    
NES nes(clk, reset_nes, run_nes,
        mapper_flags,
        sample, color,
        joypad_strobe, joypad_clock, {joypad_bits2[0], joypad_bits[0]},
        SW[4:0], // audio enables
        memory_addr,
        memory_read_cpu, memory_din_cpu,
        memory_read_ppu, memory_din_ppu,
        memory_write, memory_dout,
        cycle, scanline,
        dbgadr,
        dbgctr);
		  
/*
                 output MemOE,          // Output Enable. Enable when Low.
                 output MemWR,          // Write Enable. WRITE when Low.
                 output MemAdv,         // Address valid. Keep LOW for Async.
                 input MemWait,         // Ignore for Async.
                 output MemClk,         // Clock for sync oper. Keep LOW for Async.
                 output RamCS,          // Chip Enable. Active = LOW
                 output RamCRE,         // CRE = Control Register. LOW = Normal mode.
                 output RamUB,          // Upper byte enable
                 output RamLB,          // Lower byte enable
                 output [22:0] MemAdr,
                 inout [15:0] MemDB,
*/
		  
wire[22:0] MemAdr;
wire[15:0] MemDB, MemDB_wr, MemDB_rd;
wire[15:0]  MemDB_rd_chrrom, MemDB_rd_chrram;
wire[15:0]  MemDB_rd_cpuram, MemDB_rd_prgrom;
wire[1:0] ByteMask;
wire RamCS, RamCRE, MemClk, MemWait, MemAdv, MemWR, MemOE;

wire cs_prgrom,cs_cpuram,cs_chrrom,cs_chrram;
assign cs_prgrom=(MemAdr[20]== 1'b0);
assign cs_cpuram=(MemAdr[20:18]== 3'b111);
assign cs_chrrom=(MemAdr[20:19]== 2'b10);
assign cs_chrram=(MemAdr[20:19]== 2'b110);
// this ram block replaces the on board memory used in the nexys4

ram_programmemory	ram_programmemory_inst (
	.address ( {MemAdr[9:0]} ),
	.byteena ( ~ByteMask ),
	.clock ( clk),
	.data (MemDB_wr ),
	.wren (~MemWR & cs_prgrom),
	.q ( MemDB_rd_prgrom  )
	);

/*cpuram	ram_inst_cpuram (
	.address ( {1'b0,MemAdr[14:0]} ),
	.byteena ( ~ByteMask ),
	//.clken ( 1'b1 ),
	.clock ( clk ),
	.data ( MemDB_wr ),
	.wren ( ~MemWR & cs_cpuram),
	.q ( MemDB_rd_cpuram )
	);*/
reg[7:0] cpuram_array0[0:'hFF]; //these two were causing slowdowns in compilation because it was allocating so much freakin memory
reg[7:0] cpuram_array1[0:'hFF];
integer i;
always@(posedge clk) begin
`ifdef MODEL_TECH
 if (reset_nes) begin
      begin
        for (i=0; i<'hFF; i=i+1) begin
			cpuram_array0[i] <= 15'h0;
			cpuram_array1[i] <= 15'h0;
			end
      end
`else
	if(0) begin
`endif
  end else if(~MemWR & cs_cpuram) begin

	if(~ByteMask[0]) begin
		cpuram_array0[{1'b0,MemAdr[6:0]}]<=MemDB_wr[7:0];
	end
	if(~ByteMask[1]) begin
		cpuram_array1[{1'b0,MemAdr[6:0]}]<=MemDB_wr[15:8];
	end
  end 
end
assign MemDB_rd_cpuram = {cpuram_array0[{1'b0,MemAdr[6:0]}],cpuram_array1[{1'b0,MemAdr[6:0]}]};//flips again before going to CPU

ram_programmemory	ram_charactermemory_inst (
	.address ( ({5'b0,MemAdr[14:0]} + 20'h4000 ) ),
	.byteena ( ~ByteMask ),
	.clock ( clk),
	.data (MemDB_wr ),
	.wren (~MemWR & cs_prgrom),
	.q ( MemDB_rd_prgrom  )
	);
	
/*
ram	ram_inst_chrram (
	.address ( {5'b0,MemAdr[14:0]} ),
	.byteena ( ~ByteMask ),
	//.clken ( 1'b1 ),
	.clock ( clk ),
	.data ( MemDB_wr ),
	.wren ( ~MemWR & cs_chrram),
	.q ( MemDB_rd_chrram )
	);
	
*/

reg[7:0] chrram_array0[0:'hFFF]; //these two were causing slowdowns in compilation because it was allocating so much freakin memory
reg[7:0] chrram_array1[0:'hFFF];

always@(posedge clk) begin
`ifdef MODEL_TECH
  if (reset_nes) begin
      begin
        for (i=0; i<'hFF; i=i+1) begin
		chrram_array0[i] <= 15'h0;
		chrram_array1[i] <= 15'h0;
	end
      end
`else
		
	if(0) begin
`endif
  end else if(~MemWR & cs_chrram) begin

  if(~ByteMask[0]) begin
    chrram_array0[{1'b0,MemAdr[6:0]}]<=MemDB_wr[7:0];
  end
  if(~ByteMask[1]) begin
    chrram_array1[{1'b0,MemAdr[6:0]}]<=MemDB_wr[15:8];
  end
  end 
end
assign MemDB_rd_chrram = {chrram_array0[{1'b0,MemAdr[6:0]}],chrram_array1[{1'b0,MemAdr[6:0]}]};

	
assign MemDB_rd = cs_cpuram? MemDB_rd_cpuram : (cs_prgrom ? MemDB_rd_prgrom : (cs_chrrom ?  MemDB_rd_chrrom : MemDB_rd_chrram));


/*ram	ram_inst (
	.address ( MemAdr[19:0] ),
	.byteena ( ~ByteMask ),
	.clken ( 1'b1 ),
	.clock ( clk ),
	.data ( MemDB_wr ),
	.wren ( ~MemWR),
	.q ( MemDB_rd )
	);
*/
assign MemDB = MemOE ? 16'hzzzz : {MemDB_rd[7:0],MemDB_rd[15:8]};
assign MemDB_wr = MemOE ? {MemDB[7:0],MemDB[15:8]} : 16'hzzzz;

// This is the memory controller to access the board's PSRAM
MemoryController memory(clk,
                        memory_read_cpu && run_mem, 
                        memory_read_ppu && run_mem,
                        memory_write && run_mem || loader_write,
                        loader_write ? {2'b00, loader_addr} : {2'b00, memory_addr},
                        loader_write ? loader_write_data : memory_dout,
                        memory_din_cpu,
                        memory_din_ppu,
                        ram_busy,
                        MemOE, MemWR, MemAdv, MemClk, RamCS, RamCRE, ByteMask[1], ByteMask[0], MemAdr, MemDB); // TODO



always @(posedge clk) begin
  if (loader_reset)
    ramfail <= 0;
  else
    ramfail <= ram_busy && loader_write || ramfail;
end

wire blank_n;
assign VGA_CLK = clk;
assign VGA_BLANK_N = blank_n;
assign VGA_SYNC_N = 1'b0;

assign VGA_B = {4'h0, vga_b};
assign VGA_G = {4'h0, vga_g};
assign VGA_R = {4'h0, vga_r};

//assign VGA_B = 'hFF;
//assign VGA_G = 'h00;
//assign VGA_R = 'h00;

assign VGA_HS = vga_h;
assign VGA_VS = vga_v;


VgaDriver vga(clk_ungated, vga_h, vga_v, vga_r, vga_g, vga_b, vga_hcounter, vga_vcounter, doubler_x,blank_n, vga_stall,doubler_pixel, doubler_sync, SW[0]); // border 

Hq2x hq2x(clk, pixel_in, SW[5], // disable hq2x 
          scanline[8],        // reset_frame
          (cycle[8:3] == 42), // reset_line
          doubler_x,          // 0-511 for line 1, or 512-1023 for line 2.
          doubler_sync,       // new frame has just started
          doubler_pixel);     // pixel is outputted

//  wire [15:0] sound_signal_fir;
//  wire sample_now_fir;
//  FirFilter fir(clk, sound_signal, sound_signal_fir, sample_now_fir);
// Display mapper info on screen
always @(posedge clk) begin
  led_enable <= 255;
  led_value <= sound_signal;
end

always @(posedge clk)
  sound_ctr <= sound_ctr + 1;

SoundDriver sound_driver(clk, 
    /*SW[6] ? sound_signal_fir : */sound_signal, 
    sound_load,
    sound_load,
    AUD_MCLK, AUD_LRCK, AUD_SCK, AUD_SDIN);
 
assign LED = {6'b0, uart_error, ramfail, loader_fail, loader_done};


endmodule
