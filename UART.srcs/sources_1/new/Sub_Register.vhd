library IEEE;
use IEEE.std_logic_1164.all;
use IEEE. Numeric_std. all;

entity Sub_Register is
    port (
        clk, reset: in std_logic; -- Clock & reset input
        Wr_en: in std_logic; -- Permit write input
        Ri_en: in std_logic; -- Permit read output
        W_data: in std_logic_vector(7 downto 0); -- Written location
        R_data: out std_logic_vector(7 downto 0) -- Read location
    );
end Sub_Register;

architecture arch of Sub_Register is
    signal R_data_buffer: std_logic_vector(7 downto 0):=(others =>'0');
    
    begin

    process (clk, reset)
        begin
        if (reset='1') then
            R_data <= (others => '0'); -- Set output to zero
        elsif (rising_edge(clk)) then
            if (wr_en='1') then
                R_data_buffer <= W_data;
            end if;
            if (Ri_en='1') then
                R_data <= R_data_buffer;
            end if;
        end if;
    end process;

end arch;
