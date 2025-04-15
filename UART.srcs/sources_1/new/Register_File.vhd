library IEEE;
use IEEE.std_logic_1164.all;
use IEEE. Numeric_std. all;

entity Register_File is
    generic(
        WORD: integer:=16; -- Number of bits
        ADDR_W: integer:=3 -- Number of address bits
    );
    port (
        clk, reset: in std_logic; -- Clock & reset input
        Wr_en: in std_logic; -- Permit write input
        W_addr , r_addr : in std_logic_vector ((ADDR_W-1) downto 0); -- Written & read input
        W_data: in std_logic_vector ((WORD-1) downto 0); -- Written location
        R_data: out std_logic_vector ((WORD-1) downto 0) -- Read location
    );
end Register_File;

architecture arch of Register_File is

    type reg_file_type is array (((2**ADDR_W)-1) downto 0) of std_logic_vector ((WORD-1) downto 0);
    signal array_reg: reg_file_type; -- Assign array with dimensions 2^ADDR_W x WORD
    begin

    process (clk, reset)
        begin
        if (reset='1') then
            array_reg <= (others=>(others=>'0')); -- Reset all rows to zero
        elsif (rising_edge(clk)) then
            if (wr_en='1') then -- Only write data when wr_en is high
                array_reg(to_integer(unsigned(w_addr))) <= w_data; -- Write w_data to row w_addr
            end if;
        end if;
    end process;
    
    --read port
    r_data <= array_reg(to_integer(unsigned(r_addr))); -- Read r_data as row r_addr
    
end arch;
