library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Transmitter_tb is
end UART_Transmitter_tb;
architecture arch of UART_Transmitter_tb is

-- Component Declaration
component UART_Transmitter is
    port(
        clk, reset: in std_logic;
        d_in: in std_logic_vector(7 downto 0);
        tx_start: in std_logic;
        tx_done_tick: out std_logic;
        tx: out std_logic
    );
end component;

-- Signal Declarations
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal d_in: std_logic_vector(7 downto 0) := (others => '0');
signal tx_start: std_logic := '1';
signal tx_done_tick : std_logic;
signal tx: std_logic;
begin

-- Instantiate Baud Rate Generator
UT: UART_Transmitter
    port map(
        clk => clk,
        reset => reset,
        d_in => d_in,
        tx_start => tx_start,
        tx_done_tick => tx_done_tick,
        tx => tx
    );

-- Testbench Process
    process
    begin

        -- Test Case
        clk <= '0';
        tx_start <= '1';
        d_in <= (others => '0');
        d_in(1) <= '1';
        d_in(3) <= '1';
        d_in(7) <= '1';
        reset <= '1';
        wait for 500 ns;
        reset <= '0';
        tx_start <= '0';
        for i in 1 to 5000000 loop -- Repeat clock cycle
            clk <= '1';
            wait for 100 ns;
            clk <= '0';
            wait for 100 ns;
        end loop;

    -- Stop Simulation
    wait;
    end process;

end arch;
