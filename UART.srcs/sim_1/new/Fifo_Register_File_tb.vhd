----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 04:34:07 PM
-- Design Name: 
-- Module Name: Fifo_Controller_tb - Behavioral
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

use IEEE.math_real.all;

entity Fifo_tb is
    Generic (
        WORD : integer := 8
    );
--  Port ( );
end Fifo_tb;

architecture Behavioral of Fifo_tb is
    -- fifo controller
    component Fifo is
        generic (
            WORD : integer := 8
        );
        port (
            in_data : in std_logic;
            read, write : in std_logic;
            reset : in std_logic;
            clock : in std_logic;
            out_data : out std_logic;
            full, empty : out std_logic
        );
     end component;
     
     signal clk, rst, rd, wr, full, empty, in_data, out_data : std_logic;
begin
    fifo_to_test : Fifo
        generic map(
            WORD => WORD
        )
        port map (
            in_data => in_data,
            clock => clk,
            reset => rst,
            read => rd,
            write => wr,
            out_data => out_data,
            full => full,
            empty => empty
        );

    -- clock
    process
    begin
        clk <= '1';
        wait for 5ns;
        clk <= '0';
        wait for 5ns;
    end process;

    -- Testbench Process
    process
    begin
        -- RESET
        rst <= '1';
        rd <= '0';
        wr <= '0';
        wait for 10ns;
        rst <= '1';
        wait for 15ns;

        rst <= '0';

        -- WRITE '1'
        rd <= '0';
        wr <= '1';
        in_data <= '1';
        wait for 10ns;
        
        -- READ AND WRITE
        rd <= '1';
        wr <= '1';
        wait for 10ns;
        
        -- READ
        rd <= '1';
        wr <= '0';
        wait for 10ns;
        
        
        -- WRITE 9 TIMES (only 8 registers)
        for i in 0 to 8 loop
            rd <= '0';
            wr <= '1';
            wait for 10ns;
        end loop;
        
        -- READ AND WRITE
        rd <= '1';
        wr <= '1';
        wait for 10ns;
        
        -- READ 10 TIMES (only 8 registers)
        for i in 0 to 9 loop
            rd <= '1';
            wr <= '0';
            wait for 10ns;
        end loop;
        
        -- STOP
        rd <= '0';
        wr <= '0';
        wait for 40ns;
        
        
        -- WRITE 1101001
        rd <= '0';
        wr <= '1';
        in_data <= '1';
        wait for 20ns;
        in_data <= '0';
        wait for 10ns;
        in_data <= '1';
        wait for 10ns;
        in_data <= '0';
        wait for 20ns;
        in_data <= '1';
        wait for 10ns;
        wr <= '0';
        wait for 10ns;
        
        -- READ 10 TIMES (only 8 registers)
        for i in 0 to 9 loop
            rd <= '1';
            wr <= '0';
            wait for 10ns;
        end loop;
        
        -- end test
        wait;
    end process;
end Behavioral;