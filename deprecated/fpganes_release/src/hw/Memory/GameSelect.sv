import Games::*;

module GameSelect(
		input rst_n,
		//input [9:0] SW,
		//ADDED BY STEVEN MILLER ON APRIL 18 2024
		input [3:0] SW,
		output reg [3:0] game
	);

	
	//added by steven miller on april 18 2024
initial
	game = EMS;
			
			/*
always @(negedge rst_n) begin
	if (SW == 10'b0000000001) begin// MARIO
		game = MARIO;
	end
	else if (SW == 10'b0000000010) begin // DK
		game = DONKEY_KONG;
	end
	else if (SW == 10'b0000000100) begin // PACMAN
		game = PACMAN;
	end
	else if (SW == 10'b0000001000) begin // GALAGA
		game = GALAGA;
	end
	else if (SW == 10'b0000010000) begin // DEFENDER 2
		game = DEFENDER2;
	end
	else if (SW == 10'b0000100000) begin // TENNIS
		game = TENNIS;
	end
	else if (SW == 10'b0001000000) begin // GOLF
		game = GOLF;
	end
	else if (SW == 10'b0010000000) begin // PINBALL
		game = PINBALL;
	end
	else begin
		game = EMS;
	end
end
*/

always @(negedge rst_n) begin
	if (SW == 4'b0001) begin// MARIO
		game = MARIO;
	end
	else if (SW == 4'b0010) begin // DK
		game = DONKEY_KONG;
	end
	else if (SW == 4'b0011) begin // PACMAN
		game = PACMAN;
	end
	else if (SW == 4'b0100) begin // GALAGA
		game = GALAGA;
	end
	else if (SW == 4'b0101) begin // DEFENDER 2
		game = DEFENDER2;
	end
	else if (SW == 4'b0110) begin // TENNIS
		game = TENNIS;
	end
	else if (SW == 4'b0111) begin // GOLF
		game = GOLF;
	end
	else if (SW == 4'b1000) begin // PINBALL
		game = PINBALL;
	end
	else begin
		game = EMS;
	end
end

endmodule