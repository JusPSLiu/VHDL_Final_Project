library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end top_tb;
architecture arch of top_tb is

    signal WORD : integer := 8;
    signal ADDR_W : integer := 5;

-- Component Declaration
component top is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 5
    );
    Port (
        rx, clk, reset : in std_logic;
        tx: out std_logic
    );
end component;

-- Signal Declarations
signal rx : std_logic :='0';
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal tx: std_logic;
begin

-- Instantiate top
tp: top
    port map(
        rx => rx,
        clk => clk,
        reset => reset,
        tx => tx
    );
    
-- Testbench Process
    process
    begin

        rx <= '0';
        reset <= '1';
        wait for 500 ns;
        reset <= '0';
        wait for 2000000 ns;
        rx <= '1';
        wait for 4000000 ns;
        rx <= '0';
        wait for 2000000 ns;
        rx <= '1';

    wait;
    end process;

    
-- Clock Process
    process
    begin

        -- Clock Cycle
        for i in 1 to 5000000 loop -- Repeat clock cycle
            clk <= '1';
            wait for 100 ns;
            clk <= '0';
            wait for 100 ns;
        end loop;

    wait;
    end process;

end arch;