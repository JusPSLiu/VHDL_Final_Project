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


entity top is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 5
    );
    Port (
        rx, clk, reset : in std_logic;
        tx: out std_logic
    );
end top;

architecture Behavioral of top is
    component classify_subsystem is
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
    end component;
    
    component UART_FIFO is
        port(
            rx: in std_logic;
            clk, reset: in std_logic;
            w1_data: in std_logic_vector(7 downto 0);
            rd_uart: in std_logic;
            wr_uart: in std_logic;
            r0_data: out std_logic_vector(7 downto 0);
            rx_empty: out std_logic;
            tx_full: out std_logic;
            tx: out std_logic
        );
    end component;
    
    -- UART subsystem
    signal w1_data : std_logic_vector(7 downto 0);
    signal rd_uart, wr_uart : std_logic;
    signal r0_data: std_logic_vector(7 downto 0);
    signal rx_empty, tx_full: std_logic;
    
    -- classification subsystem
    signal received_data, data_to_transmit : std_logic_vector(WORD-1 downto 0);
    signal input_full, output_empty : std_logic;
    
    -- FIX THE CODE LATER
begin
    

end Behavioral;
