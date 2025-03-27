library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Baud_Rate_Generator_tb is
end Baud_Rate_Generator_tb;
architecture arch of Baud_Rate_Generator_tb is

-- Generic Parameter
constant Cntr : INTEGER := 326;

-- Component Declaration
component Baud_Rate_Generator is
    generic(
        Cntr: integer:=326 -- Tick rate
    );
    port(
        clk, reset: in std_logic;
        tick: out std_logic
    );
end component;

-- Signal Declarations
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal tick : std_logic;
begin

-- Instantiate Baud Rate Generator
BRG: Baud_Rate_Generator
    generic map(
        Cntr => Cntr
    )
    port map(
        clk => clk,
        reset => reset,
        tick => tick
    );

-- Testbench Process
    process
    begin

        -- Test Case
        clk <= '0';
        reset <= '1';
        wait for 5 ns;
        reset <= '0';
        wait for 5 ns;
        for i in 1 to 5000 loop -- Repeat clock cycle
            clk <= '1';
            wait for 10 ns;
            clk <= '0';
            wait for 10 ns;
        end loop;

    -- Stop Simulation
    wait;
    end process;

end arch;
