----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 04:00:33 PM
-- Design Name: 
-- Module Name: Classification_Engine - Behavioral
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
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Classification_Engine is
    Port (
        number : in std_logic_vector(7 downto 0);
        biggest_power_of_two : out std_logic_vector(7 downto 0)
    );
end Classification_Engine;

architecture Behavioral of Classification_Engine is
begin
    biggest_power_of_two <= "10000000" when number(7)='1' else
                            "01000000" when number(6)='1' else
                            "00100000" when number(5)='1' else
                            "00010000" when number(4)='1' else
                            "00001000" when number(3)='1' else
                            "00000100" when number(2)='1' else
                            "00000010" when number(1)='1' else
                            "00000001" when number(0)='1' else
                            "00000000";
end Behavioral;