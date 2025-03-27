library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_Reciever is
    port(
        clk: in std_logic;
        rx: in std_logic;
        rx_done_tick, b: out std_logic
    );
end UART_Reciever;

architecture arch of UART_Reciever is
    type fsm_state_type is (idle, start, data, stop);
    signal state_reg, state_next: fsm_state_type;
    signal s, s_tick: std_logic;
    signal D_Bit: integer:=8;
    signal SB_tick: integer:=16;

begin


end arch;
