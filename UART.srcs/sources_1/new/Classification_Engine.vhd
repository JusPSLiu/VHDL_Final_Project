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
    type state is (idle, to_classify, classify);
    signal curr_state, next_state : state;
    signal input_buffer, output_buffer : std_logic_vector(WORD-1 downto 0);
    signal ready_buffer, new_buffer : std_logic;
begin
    --csl
    process(clk, rst)
    begin
        if (rst='1') then
            curr_state <= idle;
            input_buffer <= (others => '0');
        elsif (rising_edge(clk)) then
            curr_state <= next_state;
            
            if (curr_state=to_classify) then
                input_buffer <= number;
            end if;
        end if;
    end process;

    -- nsl
    process(curr_state, start, grab, input_buffer)
    begin
        if (rst='1') then
            ready_buffer <= '1';
            output_buffer <= (others => '0');
        elsif (curr_state=idle) then
            -- start
            if (start='1') then
                next_state <= to_classify;
                ready_buffer <= '0';
            end if;
        elsif (curr_state=to_classify) then
            ready_buffer <= '0';
            next_state <= classify;
            new_buffer <= '1';
        elsif (curr_state=classify) then
            if (grab='1') then
                -- to idle state
                next_state <= idle;
                new_buffer <= '0';
            end if;

            -- new output
            ready_buffer <= '1';
            if (input_buffer(7)='1') then
                output_buffer <= "10000000";
            elsif (input_buffer(6)='1') then
                output_buffer <= "01000000";
            elsif (input_buffer(5)='1') then
                output_buffer <= "00100000";
            elsif (input_buffer(4)='1') then
                output_buffer <= "00010000";
            elsif (input_buffer(3)='1') then
                output_buffer <= "00001000";
            elsif (input_buffer(2)='1') then
                output_buffer <= "00000100";
            elsif (input_buffer(1)='1') then
                output_buffer <= "00000010";
            elsif (input_buffer(0)='1') then
                output_buffer <= "00000001";
            else output_buffer <= "00000000";
            end if;
        end if;
    end process;
    
    -- Moore output logic
    biggest_power_of_two <= input_buffer;--output_buffer;
    ready <= '1' when (next_state=idle) else '0';--ready_buffer;
    new_data <= new_buffer;
end Behavioral;