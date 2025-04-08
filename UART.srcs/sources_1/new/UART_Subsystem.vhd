library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Subsystem is
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
end UART_Subsystem;

architecture arch of UART_Subsystem is
-- Internal Signals
    signal rx_done_tick: std_logic;
    signal tx_done_tick: std_logic;
    signal flag: std_logic;
    signal rx_empty_buffer: std_logic:='0';
    signal b_out: std_logic_vector(7 downto 0);
    signal r1_data: std_logic_vector(7 downto 0);
    
-- Component Declaration for UART Transmitter
    component UART_Transmitter is
        port(
        clk, reset: in std_logic;
        d_in: in std_logic_vector(7 downto 0);
        tx_start: in std_logic;
        tx_done_tick: out std_logic;
        tx: out std_logic
        );
    end component;
    
-- Component Declaration for UART Reciever
    component UART_Reciever is
        port(
        clk, reset: in std_logic;
        rx: in std_logic;
        rx_done_tick: out std_logic;
        b_out: out std_logic_vector(7 downto 0)
        );
    end component;
    
-- component Declaration for flag buffer
    component flag_buff is
        generic(W: integer := 8);
        port(
            clk, reset: in std_logic;
            clr_flag, set_flag: in std_logic;
            flag: out std_logic
        );
    end component;
    
-- component Declaration for Subsystem Register
    component Sub_Register is
        port (
            clk, reset: in std_logic; -- Clock & reset input
            Wr_en: in std_logic; -- Permit write input
            Ri_en: in std_logic; -- Permit read input
            W_data: in std_logic_vector(7 downto 0); -- Written location
            R_data: out std_logic_vector(7 downto 0) -- Read location
        );
    end component;

begin

-- Port Mapping for BUART Transmitter
    UT: UART_Transmitter
    port map(
        clk => clk,
        reset => reset,
        d_in => r1_data,
        tx_start => flag,
        tx_done_tick => tx_done_tick,
        tx => tx
    );
    
-- Port Mapping for BUART Reciever
    UR: UART_Reciever
    port map(
        clk => clk,
        reset => reset,
        rx => rx,
        rx_done_tick => rx_done_tick,
        b_out => b_out
    );

-- Port Mapping for Reciever Sub Register
    SR0: Sub_Register
    port map(
        clk => clk,
        reset => reset,
        Wr_en => rx_done_tick,
        Ri_en => rd_uart,
        W_data => b_out,
        R_data => r0_data
    );
    
-- Port Mapping for Transmitter Sub Register
    SR1: Sub_Register
    port map(
        clk => clk,
        reset => reset,
        Wr_en => wr_uart,
        Ri_en => rd_uart,
        W_data => w1_data,
        R_data => r1_data
    );
    
-- Port Mapping for Reciever flag buff
    FB0: flag_buff
    port map(
        clk => clk,
        reset => reset,
        clr_flag => rd_uart,
        set_flag => rx_done_tick,
        flag => rx_empty_buffer
    );
    
-- Set rx_empty to the inverse of the reciever flag buffer output
    rx_empty <= not rx_empty_buffer;
    
-- Port Mapping for Transmitter flag buff
    FB1: flag_buff
    port map(
        clk => clk,
        reset => reset,
        clr_flag => tx_done_tick,
        set_flag => rd_uart,
        flag => flag
    );

end arch;