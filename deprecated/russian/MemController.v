//MemController.v
/* Author(s): Kieran Abesamis, Steven Miller
Date created: October 17, 2024
Purpose: Determines if address is in the range $8000-FFFF. Based on read/write enable, 
handles data exchange between Cartridge RAM and CPU. Also sends enable for Cartridge RAM. 
Notes: Error checked using AI Software (ClaudeAi/Chatgpt)
log:
    $ Kieran October 17, 2024 - Initial Creation
	 $ Steven October 17 2024: fixed simple errors
	 $ Steven October 21 2024: made address decoding combinational, corrected mistakes.
 */

module MemController(
    input [15:0] address_in, // From CPU 
    input rw_enable,  // 1 for write, 0 for read
    output reg r_en,  // READ enable signal to RAM
    output reg w_en,   // Write enable signal to RAM
    output reg[15:0] address_out //MemController -> Cartridge RAM, Shifted by $8000
);

    // Address validation and data operations
    always @(*) 
	 begin
	 //we want the cartridge
        if (address_in >= 16'h8000) 
			begin
				//if write operation (rw is zero)
            if (!rw_enable) 
					begin
                // Write operation
                //data_out <= data_cpu; 
                r_en <= 1'b0;          // Set RAM READ to low
                w_en <= 1'b1;          // Set RAM WRITE to high
					end 
				else 
				//if read operation (rw is one)
					begin
                // Read operation
                //data_out <= 8'bZ;
                r_en <= 1'b1;          // Set RAM READ to high
                w_en <= 1'b0;          // Set RAM WRITE to low
					end
				address_out <= address_in - 16'h8000;
			end 
		 else
			begin
				address_out <= 16'h0000;
				r_en <= 1'b0;          // Set RAM READ to low
            w_en <= 1'b0;          // Set RAM WRITE to low
			end
		  
    end

    // Send current address to RAM
   // assign address_out = address_in - 16'h8000; 

    // Drive inout ports based on rw_enable
   // assign data_cpu = (!rw_enable) ? data_cpu : q_in; // Only drive data_cpu during read

endmodule