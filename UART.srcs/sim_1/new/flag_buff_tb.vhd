library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flag_buff_tb is
end flag_buff_tb;
architecture arch of flag_buff_tb is

signal W: integer := 8;

-- Component Declaration
component flag_buff is
    generic(W: integer := 8);
    port(
        clk, reset: in std_logic;
        clr_flag, set_flag: in std_logic;
        flag: out std_logic
    );
end component;

-- Signal Declarations
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal clr_flag: std_logic := '0';
signal set_flag: std_logic := '0';
signal flag : std_logic;
begin

-- Instantiate flag buffer
fb: flag_buff
    port map(
        clk => clk,
        reset => reset,
        clr_flag => clr_flag,
        set_flag => set_flag,
        flag => flag
    );

-- Testbench Process
    process
    begin

        -- Test Case
        clr_flag <= '0';
        set_flag <= '0';
        reset <= '1';
        wait for 500 ns;
        reset <= '0';
        wait for 500 ns;
        set_flag <= '1';
        wait for 1000 ns;
        set_flag <= '0';
        wait for 1000 ns;
        clr_flag <= '1';

    -- Stop Simulation
    wait;
    end process;

-- Clock Process
    process
    begin
    
    for i in 1 to 5000000 loop -- Repeat clock cycle
            clk <= '1';
            wait for 100 ns;
            clk <= '0';
            wait for 100 ns;
        end loop;
        
    -- Stop Clock
    wait;
    end process;

end arch;