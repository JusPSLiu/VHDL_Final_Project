library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Subsystem_tb is
end UART_Subsystem_tb;
architecture arch of UART_Subsystem_tb is

-- Component Declaration
component UART_Subsystem is
    port(
        rx: in std_logic;
        clk, reset: in std_logic;
        w1_data: in std_logic_vector(7 downto 0);
        rd_uart: in std_logic;
        wr_uart: in std_logic;
        r0_data: out std_logic_vector(7 downto 0);
        rx_empty: out std_logic;
        tx: out std_logic
    );
end component;

-- Signal Declarations
signal rx : std_logic :='0';
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal w1_data : std_logic_vector(7 downto 0) := (others => '0');
signal rd_uart : std_logic := '0';
signal wr_uart : std_logic := '0';
signal r0_data : std_logic_vector(7 downto 0);
signal rx_empty : std_logic;
signal tx: std_logic;
begin

-- Instantiate UART Subsystem
US: UART_Subsystem
    port map(
        rx => rx,
        clk => clk,
        reset => reset,
        w1_data => w1_data,
        rd_uart => rd_uart,
        wr_uart => wr_uart,
        r0_data => r0_data,
        rx_empty => rx_empty,
        tx => tx
    );
    
-- Testbench Process
    process
    begin

        rx <= '0';
        reset <= '1';
        w1_data <= (others => '0');
        w1_data(0) <= '1';
        w1_data(3) <= '1';
        w1_data(6) <= '1';
        rd_uart <= '0';
        wr_uart <= '0';
        wait for 500 ns;
        reset <= '0';
        wait for 2000000 ns;
        rx <= '1';
        wait for 4000000 ns;
        rx <= '0';
        wait for 2000000 ns;
        rx <= '1';
        wr_uart <= '1';
        wait for 3000000 ns;
        rd_uart <= '1';
        wr_uart <= '0';
        wait for 500000 ns;
        rd_uart <= '0';
        

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