library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use IEEE.math_real.all;


entity Fifo_Controller is
    Generic (
        ADDR_W : integer := 3
    );
    Port (
        clk, rst, read, write : in std_logic;
        
        w_addr, r_addr : out std_logic_vector(ADDR_W-1 downto 0);
        full, empty : out std_logic
    );
end Fifo_Controller;

architecture Behavioral of Fifo_Controller is
    -- states and consts
    type state_type is (state_full, state_empty, state_neutral);
    constant ADDR_SIZE : integer := (2**ADDR_W);
    -- create state and signals for current pointers
    signal state : state_type;
    signal state_next : state_type:=state_empty;
    signal write_ptr, read_ptr, write_ptr_next, read_ptr_next : integer;
begin
    -- current state logic. and output logic.
    process(clk, rst)
    begin
        if (rst='1') then
            -- state
            state <= state_empty;
 
            -- outputs - read and write pointers
            write_ptr <= 0;
            read_ptr <= 0;

        elsif (rising_edge(clk)) then
            -- state
            state <= state_next;
            
            -- outputs - read and write pointers
            write_ptr <= write_ptr_next;
            read_ptr <= read_ptr_next;
        end if;
    end process;
    
    -- next state logic
    process(read, write, clk)
    begin
        -- default value for read_ptr_next and write_ptr_next
        read_ptr_next <= read_ptr;
        write_ptr_next <= write_ptr;


        if (write='1') then
            -- if write and read
            if (read='1') then
                -- update read and write ptrs
                read_ptr_next <= (read_ptr + 1) mod ADDR_SIZE;
                write_ptr_next <= (write_ptr + 1) mod ADDR_SIZE;
                -- state and outputs unchanged
                
            -- if write and not(read) and not(full)
            elsif (not(state=state_full)) then
                -- update write ptr
                write_ptr_next <= (write_ptr + 1) mod ADDR_SIZE;
                -- CHECK IF FULL
                if (read_ptr = (write_ptr + 1) mod ADDR_SIZE) then
                    state_next <= state_full;
                else
                    -- if not full then neutral
                    state_next <= state_neutral;
                end if;
            end if;
        else
             -- if not(write) and read and not(empty)
            if (read='1' and not(state=state_empty)) then
                -- update read ptr
                read_ptr_next <= (read_ptr + 1) mod ADDR_SIZE;
                -- CHECK IF EMPTY
                if (write_ptr = (read_ptr + 1) mod ADDR_SIZE) then
                    state_next <= state_empty;
                else
                    -- if not full then neutral
                    state_next <= state_neutral;
                end if;
            end if;
            -- if not(write) and not(read) then nothing happens
        end if;
    end process;
    
    -- output logic
    empty <= '1' when (state = state_empty) else '0';
    full <= '1' when (state = state_full) else '0';
    w_addr <= std_logic_vector(to_unsigned(write_ptr, ADDR_W));
    r_addr <= std_logic_vector(to_unsigned(read_ptr, ADDR_W));
end Behavioral;