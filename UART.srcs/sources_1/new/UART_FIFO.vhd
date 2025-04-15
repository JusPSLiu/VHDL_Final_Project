library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_FIFO is
    port(
        rx: in std_logic;
        clk, reset: in std_logic;
        w1_data: in std_logic_vector(7 downto 0);
        rd_uart: in std_logic;
        wr_uart: in std_logic;
        r0_data: out std_logic_vector(7 downto 0);
        rx_empty: out std_logic;
        tx_full: out std_logic;
        tx: out std_logic
    );
end UART_FIFO;

architecture arch of UART_FIFO is
-- Internal Signals
    signal rx_done_tick: std_logic;
    signal tx_done_tick: std_logic;
    signal flag, full: std_logic:='0';
    signal flag_buff: std_logic;
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
    
-- component Declaration for FIFO
    component Fifo is
        generic(
            WORD : integer := 8;
            ADDR_W : integer := 3
            );
        port(
            in_data : in std_logic_vector(WORD-1 downto 0);
            read, write : in std_logic;
            reset : in std_logic;
            clock : in std_logic;
            out_data : out std_logic_vector(WORD-1 downto 0);
            full, empty : out std_logic
        );
    end component;

begin

-- Port Mapping for UART Transmitter
    UT: UART_Transmitter
    port map(
        clk => clk,
        reset => reset,
        d_in => r1_data,
        tx_start => flag,
        tx_done_tick => tx_done_tick,
        tx => tx
    );
    
-- Port Mapping for UART Reciever
    UR: UART_Reciever
    port map(
        clk => clk,
        reset => reset,
        rx => rx,
        rx_done_tick => rx_done_tick,
        b_out => b_out
    );

-- Port Mapping for Reciever FIFO
    FF0: Fifo
    port map(
        in_data => b_out,
        read => rd_uart,
        write => rx_done_tick,
        reset => reset,
        clock => clk,
        out_data => r0_data,
        full => full,
        empty => rx_empty
    );
    
-- Port Mapping for Transmitter FIFO
    FF1: Fifo
    port map(
        in_data => w1_data,
        read => tx_done_tick,
        reset => reset,
        clock => clk,
        write => wr_uart,
        out_data => r1_data,
        full => tx_full,
        empty => flag_buff
    );
    
    flag <= not flag_buff;

end arch;
