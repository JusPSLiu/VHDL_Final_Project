----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2025 08:39:55 AM
-- Design Name: 
-- Module Name: Fifo_To_Classify_To_Fifo_tb - Behavioral
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

entity Fifo_To_Classify_To_Fifo_tb is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 5
    );
end Fifo_To_Classify_To_Fifo_tb;

architecture Behavioral of Fifo_To_Classify_To_Fifo_tb is
    component Fifo is
        Generic (
            WORD, ADDR_W : integer
        );
        Port (
            in_data : in std_logic_vector(WORD-1 downto 0);
            read, write, reset, clock : in std_logic;
            out_data : out std_logic_vector(WORD-1 downto 0);
            full, empty : out std_logic
        );
    end component;

    component RamFSM is
        Generic (
            WORD, ADDR_W : integer
        );
        Port (
            clk, reset, fifo_empty, classify_ready : in std_logic;
            fifo_data : in std_logic_vector(WORD-1 downto 0);
            read_fifo, start_classify : out std_logic;
            current_output : out std_logic_vector(WORD-1 downto 0)
        );
    end component;
    
    component Classification_Engine is
        Generic (
            WORD : integer
        );
        Port (
            start, grab, clk, rst : in std_logic;
            number : in std_logic_vector(WORD-1 downto 0);
            biggest_power_of_two : out std_logic_vector(WORD-1 downto 0);
            new_data, ready : out std_logic
        );
    end component;
    
    component classification_out_fsm is
        Generic (
            WORD : integer
        );
        Port (
            ready, is_new, fifo_is_full, rst, clk : in std_logic;
            grab : out std_logic
        );
    end component;
    
    -- global signals
    signal clk, rst : std_logic;
    -- fifo signals
    signal fifo_rd, fifo_wr, fifo_empty, fifo_full : std_logic;
    signal new_data, fifo_output : std_logic_vector(WORD-1 downto 0);
    -- RAM signals
    signal start_classify, classify_ready : std_logic;
    signal RAM_output : std_logic_vector(WORD-1 downto 0);
    -- classification output
    signal classification_output : std_logic_vector(WORD-1 downto 0);
    signal out_grabbing, classified_new : std_logic;
    -- final out fifo
    signal empty_out_fifo, last_fifo_empty, last_fifo_full : std_logic;
    signal final_output : std_logic_vector(WORD-1 downto 0);
    
    -- DEBUG SIGNALS
    --signal ram_writing, ram_reading : std_logic;
    --signal RAM_address : integer;
begin
    my_fsm : RamFSM
        generic map (
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            clk => clk,
            reset => rst,
            fifo_empty => fifo_empty,
            fifo_data => fifo_output,
            read_fifo => fifo_rd,
            classify_ready => classify_ready,
            start_classify => start_classify,
            current_output => RAM_output
        );

    my_fifo : FIFO
        generic map (
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            reset => rst,
            clock => clk,
            in_data => new_data,
            read => fifo_rd,
            write => fifo_wr,
            out_data => fifo_output,
            full => fifo_full,
            empty => fifo_empty
        );

    classifier : Classification_Engine
        generic map (
            WORD => WORD
        )
        port map (
            start => start_classify,
            grab => out_grabbing,
            clk => clk,
            rst => rst,
            number => RAM_output,
            biggest_power_of_two => classification_output,
            new_data => classified_new,
            ready => classify_ready
        );
        
    output_logic : classification_out_fsm
        generic map (
            WORD => WORD
        )
        port map (
            ready => classify_ready,
            is_new => classified_new,
            fifo_is_full => last_fifo_full,
            rst => rst,
            clk => clk,
            grab => out_grabbing
        );

    out_fifo : FIFO
        generic map (
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            reset => rst,
            clock => clk,
            in_data => classification_output,
            read => empty_out_fifo,
            write => out_grabbing,
            out_data => final_output,
            full => last_fifo_full,
            empty => last_fifo_empty
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
 
        -- RESET
        rst <= '1';
        fifo_wr <= '0';
        
        wait for 10ns;
        rst <= '1';
        
        wait for 15ns;
        rst <= '0';

        -- write a few numbers
        fifo_wr <= '1';
        new_data <= std_logic_vector(to_unsigned(10, WORD));
        wait for 10ns;
        new_data <= std_logic_vector(to_unsigned(63, WORD));
        wait for 10ns;
        new_data <= std_logic_vector(to_unsigned(5, WORD));
        wait for 10ns;
        fifo_wr <= '0';
 
        -- end test
        wait;
    end process;

end Behavioral;