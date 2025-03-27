library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Reciever_tb is
end UART_Reciever_tb;
architecture arch of UART_Reciever_tb is

-- Component Declaration
component UART_Reciever is
    port(
        clk, reset: in std_logic;
        rx: in std_logic;
        rx_done_tick: out std_logic;
        b_out: out std_logic_vector(7 downto 0)
    );
end component;

-- Signal Declarations
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal rx: std_logic := '0';
signal rx_done_tick : std_logic;
signal b_out: std_logic_vector(7 downto 0);
begin

-- Instantiate Baud Rate Generator
UR: UART_Reciever
    port map(
        clk => clk,
        reset => reset,
        rx => rx,
        rx_done_tick => rx_done_tick,
        b_out => b_out
    );

-- Testbench Process
    process
    begin

        -- Test Case
        clk <= '0';
        rx <= '0';
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