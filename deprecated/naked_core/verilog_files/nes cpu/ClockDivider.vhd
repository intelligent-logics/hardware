library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ClockDivider is
    generic (
        INPUT_FREQ : POSITIVE;
        OUTPUT_FREQ : POSITIVE
    );
    port ( 
        clk, reset: in std_logic;
        clock_out: out std_logic
    );
end ClockDivider;

architecture bhv of ClockDivider is

    signal count: integer:= 1;
    signal tmp : std_logic := '0';
    constant DIVIDER_VALUE : integer := integer(INPUT_FREQ / OUTPUT_FREQ);

begin

    process(clk, reset)
    begin
        if reset = '1' then
            count <= 1;
            tmp <= '0';
        elsif rising_edge(clk) then
            count <= count + 1;
            if (count = DIVIDER_VALUE / 2) then
                tmp <= not tmp;
                count <= 1;
            end if;
        end if;
    end process;

    clock_out <= tmp;

end bhv;
