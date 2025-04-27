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
        r0_data: in std_logic_vector(7 downto 0);
        rx_empty: in std_logic;
        tx_full: in std_logic;
        w1_data: out std_logic_vector(7 downto 0);
        rd_uart: out std_logic;
        wr_uart: out std_logic
    );
end classify_subsystem;

architecture Behavioral of classify_subsystem is
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

    -- RAM signals
    signal start_classify, classify_ready : std_logic;
    signal RAM_output : std_logic_vector(WORD-1 downto 0);
    -- classification output
    signal classification_output : std_logic_vector(WORD-1 downto 0);
    signal sending_result, classified_new : std_logic;
begin
    my_fsm : FSM
        generic map (
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            clk => clk,
            reset => rst,
            fifo_empty => rx_empty,
            fifo_data => r0_data,
            read_fifo => rd_uart,
            classify_ready => classify_ready,
            start_classify => start_classify,
            current_output => RAM_output
        );
    
    classifier : Classification_Engine
        generic map (
            WORD => WORD
        )
        port map (
            start => start_classify,
            grab => sending_result,
            clk => clk,
            rst => rst,
            number => RAM_output,
            biggest_power_of_two => w1_data, -- send output to w1 FIFO
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
            fifo_is_full => tx_full,
            rst => rst,
            clk => clk,
            grab => sending_result
        );
        
    wr_uart <= sending_result;
end Behavioral;