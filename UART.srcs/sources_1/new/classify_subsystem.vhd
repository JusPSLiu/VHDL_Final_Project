----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2025 03:16:59 PM
-- Design Name: 
-- Module Name: top - Behavioral
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


entity classify_subsystem is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 5
    );
    Port (
        clk, rst : in std_logic;
        received_data : in std_logic_vector(WORD-1 downto 0);
        input_full, output_empty : out std_logic;
        data_to_transmit : out std_logic_vector(WORD-1 downto 0)
    );
end classify_subsystem;

architecture Behavioral of classify_subsystem is
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

    component FSM is
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
    
    -- fifo signals
    signal fifo_rd, fifo_wr, fifo_empty : std_logic;
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
begin
    my_fsm : FSM
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
            full => input_full,
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

end Behavioral;
