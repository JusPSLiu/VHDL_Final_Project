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

entity Fifo_Controller_tb is
    Generic (
        WORD : integer := 8
    );
--  Port ( );
end Fifo_Controller_tb;

architecture Behavioral of Fifo_Controller_tb is
    -- const for ptr size and states
    component Fifo_Controller is
        Generic (
            WORD : integer
        );
        Port (
            clk, rst, read, write : in std_logic;
            
            w_addr, r_addr : out integer;
            full, empty : out std_logic
        );
    end component;
    signal clk, rst, rd, wr, full, empty : std_logic;
    signal w_ptr, r_ptr : integer;
begin
    fifo : Fifo_Controller
        generic map(
            WORD => WORD
        )
        port map (
            clk => clk,
            rst => rst,
            read => rd,
            write => wr,
            w_addr => w_ptr,
            r_addr => r_ptr,
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
        rst <= '0';
        rd <= '0';
        wr <= '0';
        wait for 10ns;
        rst <= '1';
        wait for 15ns;

        rst <= '0';

        -- WRITE ONCE
        rd <= '0';
        wr <= '1';
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
        wait for 10ns;
        
        -- end test
        wait;
    end process;

end Behavioral;
