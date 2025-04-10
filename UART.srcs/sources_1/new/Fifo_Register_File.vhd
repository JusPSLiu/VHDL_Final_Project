----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2025 04:18:50 PM
-- Design Name: 
-- Module Name: Register_File - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE. Numeric_std. all;

entity Fifo_Register_File is
    generic(
        WORD : integer := 16 -- Number of bits
    );
    port (
        clk, reset: in std_logic; -- Clock & reset input
        Wr_en: in std_logic; -- Permit write input
        W_addr , r_addr : in integer range 0 to WORD-1; -- Written & read input
        W_data: in std_logic; -- Write Input
        R_data: out std_logic; -- Read Output
        array_reg_output : out std_logic_vector(WORD-1 downto 0)
    );
end Fifo_Register_File;

architecture arch of Fifo_Register_File is
    signal array_reg: std_logic_vector(WORD-1 downto 0); -- Assign array with dimensions 2^w x B
    begin

    process (clk, reset)
        begin
        if (reset='1') then
            array_reg <= (others=>'0'); -- Reset all rows to zero
        elsif (rising_edge(clk)) then
            if (wr_en='1') then -- Only write data when wr_en is high
                array_reg(w_addr) <= w_data; -- Write w_data to row w_addr
            end if;
        end if;
    end process;
    
    --read port
    r_data <= '0' when (r_addr<0) else
        array_reg(r_addr); -- Read r_data as row r_add
    
    -- the full reg output
    array_reg_output <= array_reg;
end arch;