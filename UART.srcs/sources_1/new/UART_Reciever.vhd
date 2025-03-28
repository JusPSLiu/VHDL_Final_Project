library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Reciever is
    port(
        clk, reset: in std_logic;
        rx: in std_logic;
        rx_done_tick: out std_logic;
        b_out: out std_logic_vector(7 downto 0)
    );
end UART_Reciever;

architecture arch of UART_Reciever is
    type fsm_state_type is (idle, start, data, stop);
    signal state_reg, state_next: fsm_state_type;
    signal s_tick, rx_done_buffer: std_logic;
    signal b: std_logic_vector(7 downto 0);
    signal s, n: integer;
    signal D_Bit: integer:=8;
    signal SB_tick: integer:=16;
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
                if (rx='0') then    -- When input is zero
                    state_next <= start;
                    s <= 0;
                else                -- Wait
                    state_next <= idle;
                end if;
            when start =>
                if (s_tick='1') then
                if (s=7) then       -- After 8 ticks
                    state_next <= data;
                    s <= 0;
                    n <= 0;
                    b <= (others => '0');
                else                -- Count to 7
                    s <= s+1;
                end if;
                end if;
            when data =>
                if (s_tick='1') then
                if (s=15) then  -- Every 16 ticks
                    s <= 0;
                    b <= rx & b(7 downto 1);
                    if (n=(D_Bit-1)) then       -- After 16*8=128 ticks
                        state_next <= stop;
                    else
                        n <= n+1;               -- Count to 7
                    end if;
                else            -- Count to 15
                    s <= s+1;
                end if;
                end if;
            when others =>
                if (s_tick='1') then
                if (s=(SB_tick-1)) then         -- After 16 ticks
                    state_next <= idle;
                    rx_done_buffer <= '1';
                else                            -- Count to 15
                    s <= s+1;
                end if;
                end if;
        end case;
    --end if;
    end process;
    
    -- output logic
    b_out <= b;
    rx_done_tick <= '1' when rx_done_buffer='1' else
                    '0';

end arch;
