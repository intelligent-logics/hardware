	component clkgater is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			ena    : in  std_logic := 'X'; -- ena
			outclk : out std_logic         -- outclk
		);
	end component clkgater;

	u0 : component clkgater
		port map (
			inclk  => CONNECTED_TO_inclk,  --  altclkctrl_input.inclk
			ena    => CONNECTED_TO_ena,    --                  .ena
			outclk => CONNECTED_TO_outclk  -- altclkctrl_output.outclk
		);

