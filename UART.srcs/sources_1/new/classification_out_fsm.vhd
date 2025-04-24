----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2025 05:37:13 PM
-- Design Name: 
-- Module Name: classification_out_fsm - Behavioral
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

entity classification_out_fsm is
    Generic (
        WORD : integer := 8
    );
    Port (
        ready, is_new, rst, clk, fifo_is_full : in std_logic;
        grab : out std_logic
    );
end classification_out_fsm;

architecture Behavioral of classification_out_fsm is
    type state is (idle, transfer);
    signal curr_state, next_state : state;
begin
    -- csl
    process(clk, rst)
    begin
        if (rst='1') then
            curr_state <= idle;
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
        end if;
    end process;
    
    -- nsl
    process(clk, rst)
    begin
        if (rst='1') then
            next_state <= idle;
        elsif (curr_state=idle) then
            if (ready='1' and is_new='1' and fifo_is_full='0') then
                next_state <= transfer;
            end if;
        elsif (curr_state=transfer) then
            next_state <= idle;
        end if;
    end process;
    
    -- Moore output logic
    grab <= '1' when curr_state=transfer else '0';
end Behavioral;