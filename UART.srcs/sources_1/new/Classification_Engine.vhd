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
    Generic (
        WORD : integer := 8
    );
    Port (
        start, grab, clk, rst : in std_logic;
        number : in std_logic_vector(WORD-1 downto 0);
        biggest_power_of_two : out std_logic_vector(WORD-1 downto 0);
        new_data, ready : out std_logic
    );
end Classification_Engine;

architecture Behavioral of Classification_Engine is
    type state is (classify, idle);
    signal curr_state, next_state : state;
    signal next_output : std_logic_vector(WORD-1 downto 0);
    signal next_new, next_next_new, next_ready : std_logic;
begin
    --csl
    process(clk, rst)
    begin
        if (rising_edge(clk)) then
            if (rst='1') then
                curr_state <= idle;
                biggest_power_of_two <= (others => '0');
                ready <= '1'; new_data <= '0'; next_new <= '0';
            else
                curr_state <= next_state;
                biggest_power_of_two <= next_output;
                ready <= next_ready;
                
                -- alert when there is new unsent data here
                new_data <= next_new;
                next_new <= next_next_new;
            end if;
        end if;
    end process;


    -- nsl
    process(clk, rst)
    begin
        if (rst='1') then
            next_ready <= '1'; next_next_new <= '0';
            next_state <= idle;
        elsif (curr_state=idle) then
            -- start
            if (start='1') then
                next_state <= classify;
                next_ready <= '0';
                next_next_new <= '1';
            end if;
        elsif (curr_state=classify) then
            if (grab='1') then
                -- to idle state
                next_state <= idle;
                next_next_new <= '0';
            end if;
            -- new output
            next_ready <= '1';
            next_output <= "00000000";
            if (number(7)='1') then
                next_output <= "10000000";
            elsif (number(6)='1') then
                next_output <= "01000000";
            elsif (number(5)='1') then
                next_output <= "00100000";
            elsif (number(4)='1') then
                next_output <= "00010000";
            elsif (number(3)='1') then
                next_output <= "00001000";
            elsif (number(2)='1') then
                next_output <= "00000100";
            elsif (number(1)='1') then
                next_output <= "00000010";
            elsif (number(0)='1') then
                next_output <= "00000001";
            else next_output <= "00000000";
            end if;
        end if;
    end process;
end Behavioral;