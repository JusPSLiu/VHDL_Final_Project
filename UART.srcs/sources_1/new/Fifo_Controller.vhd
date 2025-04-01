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
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use IEEE.math_real.all;


entity Fifo_Controller is
    Generic (
        WORD : integer := 8
    );
    Port (
        clk, rst, read, write : in std_logic;
        
        w_addr, r_addr : out std_logic_vector(integer(ceil(log2(real(WORD)))) downto 0);
        full, empty : out std_logic
    );
end Fifo_Controller;

architecture Behavioral of Fifo_Controller is
    -- const for ptr size and states
    constant PTR_SIZE : integer := integer(ceil(log2(real(WORD))));
    type state_type is (state_full, state_empty, state_neutral);
    -- create state and signals for current pointers
    signal state, state_next : state_type;
    signal write_ptr, read_ptr, write_ptr_next, read_ptr_next : std_logic_vector(PTR_SIZE downto 0);
    signal empty_next, full_next : std_logic;
begin
    -- current state logic. and output logic.
    process(clk, rst)
    begin
        if (rst='1') then
            -- state
            state <= state_neutral;
 
            -- outputs - read and write pointers
            write_ptr <= (others => '0');
            read_ptr <= (others => '0');
            -- outputs - empty / full
            empty <= empty_next;
            full <= full_next;

        elsif (rising_edge(clk)) then
            -- state
            state <= state_next;
            
            -- outputs - read and write pointers
            write_ptr <= write_ptr_next;
            read_ptr <= read_ptr_next;
            -- outputs - empty / full
            empty <= empty_next;
            full <= full_next;
        end if;
    end process;
    
    -- next state logic
    process(read, write)
    begin
        -- default value for read_ptr_next and write_ptr_next
        read_ptr_next <= read_ptr;
        write_ptr_next <= write_ptr;


        if (write='1') then
            -- if write and read
            if (read='1') then
                -- update read and write ptrs
                read_ptr_next <= std_logic_vector(to_unsigned(PTR_SIZE, to_integer(unsigned(read_ptr)) + 1));
                write_ptr_next <= std_logic_vector(to_unsigned(PTR_SIZE, to_integer(unsigned(read_ptr)) + 1));
                -- state and outputs unchanged
                
            -- if write and not(read) and not(full)
            elsif (not(state=state_full)) then
                -- update write ptr
                write_ptr_next <= std_logic_vector(to_unsigned(PTR_SIZE, to_integer(unsigned(read_ptr)) + 1));
                -- CHECK IF FULL
                if (read_ptr_next = write_ptr_next) then
                    state <= state_full;
                    full <= '1';
                end if;
            end if;
        else
             -- if not(write) and read and not(empty)
            if (read='1' and not(state=state_empty)) then
                full_next <= '0'; -- reading, so not full
                read_ptr_next <= std_logic_vector(to_unsigned(PTR_SIZE, to_integer(unsigned(read_ptr)) + 1));
                
                -- CHECK IF EMPTY
                if (read_ptr_next = write_ptr_next) then
                    empty <= '1';
                end if;
            end if;
            -- if not(write) and not(read) then nothing happens
        end if;

    end process;
end Behavioral;