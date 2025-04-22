----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2025 02:38:17 PM
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 3
    );
    Port (
        clk, reset, fifo_empty, classify_ready : in std_logic;
        fifo_data : in std_logic_vector(WORD-1 downto 0);
        read_fifo, start_classify : out std_logic;
        current_output : out std_logic_vector(WORD-1 downto 0);
        
        write_to_ram, read_from_ram : out std_logic; --- DEBUG OUTPUTS
        the_address : out integer
    );
end FSM;

architecture Behavioral of FSM is
    type state is (idle, loadRAM, classify);
    signal curr_state, next_state : state;
    signal start_addr, address, start_addr_next, address_next : integer;
    signal fifo_rd, fifo_rd_nxt, ram_out_enable, ram_out_en_next, start_classify_next : std_logic;
    signal address_vector, address_vector_next : std_logic_vector(ADDR_W-1 downto 0);
    
    component RAM is
        Generic (
            WORD, ADDR_WIDTH : integer
        );
        port (
            address        : in  std_logic_vector(ADDR_W-1 downto 0);
            data_in        : in  std_logic_vector(WORD-1 downto 0);
            write_in       : in  std_logic;
            clock          : in  std_logic;
            output_enable  : in  std_logic; 
            data_out       : out std_logic_vector(WORD-1 downto 0)
        );
    end component;
begin
    -- set the ram
    my_ram : RAM
        generic map (
            WORD => WORD,
            ADDR_WIDTH => ADDR_W
        )
        port map(
            address => address_vector,
            data_in => fifo_data,
            write_in => fifo_rd,
            clock => clk,
            output_enable => '1',--ram_out_enable,
            data_out => current_output
        );

    -- csl
    process(clk, reset)
    begin
        if (reset='1') then
            curr_state <= idle;
            
            -- set addresses to point to 0
            address <= 0;
            start_addr <= 0;
            address_vector <= (others => '0');
        elsif (rising_edge(clk)) then
            -- new state
            curr_state <= next_state;
            
            -- new start address, fifo read signal, classify signal
            start_addr <= start_addr_next;
            address <= address_next;
            address_vector <= address_vector_next;
            read_fifo <= fifo_rd_nxt; fifo_rd <= fifo_rd_nxt;
            start_classify <= start_classify_next;
            ram_out_enable <= ram_out_en_next;
        end if;
    end process;

    --nsl
    process(clk, reset)
    begin
        if (reset='1') then
            -- set next variables to 0
            start_addr_next <= 0;
            address_next <= 0;
            address_vector_next <= (others => '0');
            fifo_rd_nxt <= '0';
            start_classify_next <= '0';
            ram_out_en_next <= '0';
        elsif (curr_state = idle) then
            -- set next state when fifo is not empty
            if (fifo_empty='0') then
                next_state <= loadRAM;
            elsif (not(address = start_addr)) then
                next_state <= classify;
            end if;
        elsif (curr_state = loadRAM) then
            -- set next state
            if (fifo_empty='0') then
                next_state <= loadRAM;
            elsif (classify_ready='1') then
                next_state <= classify;
            end if;
        elsif (curr_state = classify) then
            start_addr_next <= (start_addr + 1) mod (2**ADDR_W);
            next_state <= idle;
        end if;

        -- handle next outputs for next states
        if (next_state=loadRAM) then
            fifo_rd_nxt <= '1';

            start_classify_next <= '0';
            ram_out_en_next <= '0';

            -- set the RAM address to point to next address
            address_vector_next <= std_logic_vector(to_unsigned(address, ADDR_W));
            address_next <= (address + 1) mod (2**ADDR_W);
        elsif (next_state=classify) then
            start_classify_next <= '1';
            ram_out_en_next <= '1';

            -- don't read fifo next
            fifo_rd_nxt <= '0';
            
            -- set the RAM address to point to start address
            address_vector_next <= std_logic_vector(to_unsigned(start_addr, ADDR_W));
        elsif (next_state=idle) then
            start_addr_next <= start_addr;
            ram_out_en_next <= '0';
            start_classify_next <= '0';
        end if;
    end process;
    
    -- DEBUG OUTPUTS
    write_to_ram <= fifo_rd_nxt;
    read_from_ram <= ram_out_enable;
    the_address <= to_integer(unsigned(address_vector));
end Behavioral;