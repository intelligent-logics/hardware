//datacontroller.v
/* Author(s):Steven Miller
Date created: October 17, 2024
Purpose: Databus arbitration, based on kierans memory controller
log:
	 $ Steven October 21 2024: initial creation
 */

/*While the NES does its own address
decoding via the address lines and the rnw pin,
quartus does not seem to understand this.
Therefore, some sort of alternative address
decoding method is needed to shut it up.*/
/*
memory mappings:
$0000–$07FF Work RAM
$0800–$0FFF	Mirror of $0000–$07FF
$1000–$17FF	Mirror of $0000–$07FF
$1800–$1FFF Mirror of $0000–$07FF
$2000–$2007 PPU registers
$2008–$3FFF Mirrors of $2000–$2007 (repeats every 8 bytes)
$6000–$7FFF cartridge ram
$8000–$FFFF cartridge rom
*/
module datacontroller(
    input [15:0] address_in, // From CPU  
	 inout reg[7:0] data_from_cart, //databus coming from cartridge
	 inout reg[7:0] data_wram,  //databus for wram and memory controller
	 inout reg[7:0] data_ppu, //databus for ppu
	 inout reg[7:0] data_cpu //databus for cpu and memory controller
);

	reg[15:0] temp_address;
    // Address validation and data operations
    always @(*) 
	 begin
	 //we want the work ram
		if(address_in <= 16'h07FF)
			begin
				data_from_cart <= 8'hz;
				data_wram <= data_cpu;
				data_ppu <= 8'hz;
				data_cpu <= 8'hz;
			end
	//still work ram
		else if((address_in >= 16'h0800) || (address_in <= 16'h0FFF))
			begin
				data_from_cart <= 8'hz;
				data_wram <= data_cpu;
				data_ppu <= 8'hz;
				data_cpu <= 8'hz;
			end
	//still work ram
		else if((address_in >= 16'h1000) || (address_in <= 16'h17FF))
			begin
				data_from_cart <= 8'hz;
				data_wram <= data_cpu;
				data_ppu <= 8'hz;
				data_cpu <= 8'hz;
			end
	//still work ram
		else if((address_in >= 16'h1800) || (address_in <= 16'h1FFF))
			begin
				data_from_cart <= 8'hz;
				data_wram <= data_cpu;
				data_ppu <= 8'hz;
				data_cpu <= 8'hz;
			end
	//ppu
		else if((address_in >= 16'h2000) || (address_in <= 16'h2007))
			begin
				data_from_cart <= 8'hz;
				data_wram <= 8'hz;
				data_ppu <= data_cpu;
				data_cpu <= 8'hz;
			end
	//ppu mirrors
		else if((address_in >= 16'h2008) || (address_in <= 16'h3FFF))
			begin
				data_from_cart <= 8'hz;
				data_wram <= 8'hz;
				data_ppu <= data_cpu;
				data_cpu <= 8'hz;
			
			/*
				temp_address <= address_in;
				//since its replicated every byte, we can do a trick.
				//1.chop off the first nibble
				temp_address <= temp_address & 16'h000F;
				//2.check if the address is greater than 7
				if(temp_address > 3'h7)
					begin
						//if so, subtract 8
							temp_address <= temp_address - 4'h8;
					end
				//3.bitwise or with 0x2000
				temp_address <= temp_address | 16'h2000;
				//tada!!!!
			*/
			end
	//cartridge ram
		else if((address_in >= 16'h6000) || (address_in <= 16'h7FFF))
			begin
				data_from_cart <= 8'hz;
				data_wram <= 8'hz;
				data_ppu <= data_cpu;
				data_cpu <= 8'hz;
			end
	//cartridge rom
		else if((address_in >= 16'h8000) || (address_in <= 16'hFFFF))
			begin
				data_from_cart <= data_cpu;
				data_wram <= 8'hz;
				data_ppu <= 8'hz;
				data_cpu <= 8'hz;
			end
		else
		
		data_from_cart <= 8'hz;
		data_wram <= 8'hz;
		data_ppu <= 8'hz;
		data_cpu <= 8'hz;
        
    end


endmodule