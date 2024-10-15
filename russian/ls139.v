//ls139.v
/*
Author(s): Steven Miller
Date created: October 14 2024
Purpose: replacement for ls139 decoder
Notes:See https://www.ti.com/lit/ds/symlink/sn54ls139a-sp.pdf?ts=1728938098960&ref_url=https%253A%252F%252Fwww.google.com%252F
log:
	$ Steven 10/14/2024: initial creation
*/

module ls139
(
	input[1:0] A,
	input[1:0] B,
	input G1n,
	input G2n,
	output reg[3:0] Y1,
	output reg[3:0] Y2
);

always@(*)
begin
	
	case(A)
			2'b00:
				begin
					if(G1n == 0)
						begin
							Y1 <= 4'b0001;
						end
					else
						begin
							Y1 <= 4'b1111;
						end
				end
			2'b01:
				begin
					if(G1n == 0)
						begin
							Y1 <= 4'b0010;
						end
					else
						begin
							Y1 <= 4'b1111;
						end
				end
			2'b10:
				begin
					if(G1n == 0)
						begin
							Y1 <= 4'b0100;
						end
					else
						begin
							Y1 <= 4'b1111;
						end
				end
			2'b11:
				begin
					if(G1n == 0)
						begin
							Y1 <= 4'b1000;
						end
					else
						begin
							Y1 <= 4'b1111;
						end
				end
	endcase
	
	case(B)
			2'b00:
				begin
					if(G2n == 0)
						begin
							Y2 <= 4'b0001;
						end
					else
						begin
							Y2 <= 4'b1111;
						end
				end
			2'b01:
				begin
					if(G2n == 0)
						begin
							Y2 <= 4'b0010;
						end
					else
						begin
							Y2 <= 4'b1111;
						end
				end
			2'b10:
				begin
					if(G2n == 0)
						begin
							Y2 <= 4'b0100;
						end
					else
						begin
							Y2 <= 4'b1111;
						end
				end
			2'b11:
				begin
					if(G2n == 0)
						begin
							Y2 <= 4'b1000;
						end
					else
						begin
							Y2 <= 4'b1111;
						end
				end
	endcase
	
end

endmodule