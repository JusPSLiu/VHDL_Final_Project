library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Transmitter is
    port(
        clk, reset: in std_logic;
        d_in: in std_logic_vector(7 downto 0);
        tx_start: in std_logic;
        tx_done_tick: out std_logic;
        tx: out std_logic
    );
end UART_Transmitter;

architecture arch of UART_Transmitter is
-- Internal Signals
    type fsm_state_type is (idle, start, data, stop);
    signal state_reg, state_next: fsm_state_type;
    signal s_tick: std_logic;
    signal tx_done_buffer: std_logic:='0';
    signal tx_buffer: std_logic:='0';
    signal n: integer:=0;
    signal D_Bit: integer:=8;
    signal Cntr: integer:=326;
    
-- Component Declaration for Register File
    component Baud_Rate_Generator is
    port(
        clk, reset: in std_logic;
        tick: out std_logic
    );
    end component;

begin

-- Port Mapping for Baud Rate Generator
    BRG: Baud_Rate_Generator
    port map(
        clk => clk,
        reset => reset,
        tick => s_tick
    );

-- state register
    process(clk, reset)
    begin
        if (reset = '1') then
            state_reg <= idle;
        elsif (rising_edge(clk)) then
            state_reg <= state_next;
        end if;
    end process;
    
-- state next logic
    process(state_reg, s_tick)
    begin
    --if (s_tick='1') then
        case state_reg is
            when idle =>
                if (tx_start='0') then    -- When input is zero
                    state_next <= start;
                else                -- Wait
                    state_next <= idle;
                end if;
            when start =>
                if (s_tick='1') then
                    state_next <= data;
                    n <= 0;
                end if;
            when data =>
                if (s_tick='1') then
                    tx_buffer <= d_in(n);
                    if (n=(D_Bit-1)) then       -- After 16*8=128 ticks
                        state_next <= stop;
                    else
                        n <= n+1;               -- Count to 7
                    end if;
                end if;
            when others =>
                if (s_tick='1') then
                    state_next <= idle;
                    tx_done_buffer <= '1';
                end if;
        end case;
    --end if;
    end process;
    
    -- output logic
    tx <= tx_buffer;
    tx_done_tick <= '1' when tx_done_buffer='1' else
                    '0';

end arch;
