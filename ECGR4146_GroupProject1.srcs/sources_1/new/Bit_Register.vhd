library IEEE;
use IEEE.std_logic_1164.all;
use IEEE. Numeric_std. all;

entity Bit_Register is
    port (
        clk, reset: in std_logic; -- Clock & reset input
        Wr_en: in std_logic; -- Permit write input
        W_data: in std_logic; -- Written location
        R_data: out std_logic -- Read location
);
end Bit_Register;

architecture arch of Bit_Register is
    begin

    process (clk, reset)
        begin
        if (reset='1') then
            R_data <= '0'; -- Set output to zero
        elsif (rising_edge(clk)) then
            if (wr_en='1') then -- Only write data when wr_en is high
                R_data <= w_data; -- Write W_data to R_data
            end if;
        end if;
    end process;

end arch;
