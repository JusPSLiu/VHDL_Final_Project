library ieee;
use ieee.std_logic_1164.all;

entity flag_buff is
    generic(W: integer := 8);
    port(
        clk, reset: in std_logic;
        clr_flag, set_flag: in std_logic;
        flag: out std_logic
    );
end flag_buff;

architecture arch of flag_buff is
    signal flag_reg, flag_next: std_logic;
    
begin

    process(clk, reset)
    begin
        if (reset = '1') then
            flag_reg <= '0';
        elsif (clk'event and clk='1') then
            flag_reg <= flag_next;
        end if;
    end process;
 
-- next-state logic
    process (set_flag, clr_flag)
    begin
        flag_next <= flag_reg;
        if (set_flag = '1') then
            flag_next <= '1';
        elsif (clr_flag = '1') then
            flag_next <= '0';
        end if;
    end process;
    
-- output logic
    flag <= flag_reg;
    
end arch;