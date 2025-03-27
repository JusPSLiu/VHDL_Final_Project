library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Baud_Rate_Generator is
generic(
        Cntr: integer:=326 -- Tick rate (# clock cycles between ticks)
    );
    port(
        clk, reset: in std_logic;
        tick: out std_logic
    );
end Baud_Rate_Generator;

architecture arch of Baud_Rate_Generator is

-- Component Declaration for Register File
    component Bit_Register is
    Port (
        W_data : in std_logic;
        clk, reset : in std_logic;
        wr_en : in std_logic;
        R_data : out std_logic
    );
    end component;
    
-- Intermediary Signal Declaration
    signal tick_next, LSB: std_logic;
    signal Count: integer;

begin

-- Port Mapping for Bit Register
    BG: Bit_Register
    port map(
        clk => clk,
        reset => reset,
        W_data => tick_next,
        wr_en => LSB,
        R_data => tick
    );

    process(clk, reset)
    begin
        if (reset='1') then
            tick_next <= '0';
            LSB <= '1'; -- Set register to write on clock rising edge
            Count <= 2; -- Buffer inital count to remove register delay
        elsif (falling_edge(clk)) then
            if (Count=Cntr) then
                tick_next <= '1';
                Count <= 1;
            else
                tick_next <= '0';
                Count <= Count + 1;
            end if;
        end if;
    end process;

end arch;
