//nes_naked.v
/*
	Author(s): Steven Miller 
	Date created: April 10 2024
	Purpose: initializes main NES cpu while adding extra components
	Notes: originally taken from Ludvig Strigeus
	Log:
		$April 10 2024, Steven Miller
        initial creation
*/
/*wires to/from outside world*/
wire system_clk;
wire system_reset;
wire[7:0] sdram_datain;
wire[7:0] sdram_dataout;
/*intercomponent wires*/
wire dma_clk = system_clk;
wire dma_ce = 'h0;
wire dma_apu_request;
wire dma_cpuread;
wire[7:0] dma_datafromcpu;
wire[15:0] dma_dmcaddress;
wire[15:0] dma_addressout;
wire dma_addressenable;
wire dma_read;
wire dma_ack;
wire dma_pausecpu;
dma_controller dma
(
	.clk            (dma_clk),
	.ce             (dma_ce),
	.reset          (system_reset),
	.odd_cycle      ('h0),                // Even or odd cycle
	.sprite_trigger ('h1), // Sprite trigger
	.dmc_trigger    (dma_apu_request),            // DMC Trigger
	.cpu_read       (dma_cpuread),                    // CPU in a read cycle?
	.data_from_cpu  (dma_datafromcpu),                   // Data from cpu
	.data_from_ram  (sdram_datain),              // Data from RAM etc.
	.dmc_dma_addr   (dma_dmcaddress),               // DMC addr
	.aout           (dma_addressout),
	.aout_enable    (dma_addressenable),
	.read           (dma_read),
	.data_to_ram    (sdram_dataout),
	.dmc_ack        (dma_ack),
	.pause_cpu      (dma_pausecpu)
);