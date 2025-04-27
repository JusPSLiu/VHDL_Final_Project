----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2025 02:28:20 AM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 5
    );
end top_tb;

architecture Behavioral of top_tb is
    component top is
        Generic (
            WORD, ADDR_W : integer
        );
        Port (
            rx, clk, reset : in std_logic;
            tx: out std_logic
        );
    end component;
    
    signal rx, clk, reset, tx : std_logic;
begin
    system : top
        generic map (
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            rx => rx,
            clk => clk,
            reset => reset,
            tx => tx
        );

end Behavioral;
