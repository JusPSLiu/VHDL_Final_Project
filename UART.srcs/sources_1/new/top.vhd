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
            r0_data: in std_logic_vector(7 downto 0);
            rx_empty: in std_logic;
            tx_full: in std_logic;
            w1_data: out std_logic_vector(7 downto 0);
            rd_uart: out std_logic;
            wr_uart: out std_logic
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
    
    -- signals btwn UART and classification
    signal w1_data, r0_data : std_logic_vector(7 downto 0);
    signal rd_uart, wr_uart, rx_empty, tx_full : std_logic;
begin
    UART : UART_FIFO
        port map(
            clk => clk,
            reset => reset,
            rx => rx,
            w1_data => w1_data,
            rd_uart => rd_uart,
            wr_uart => wr_uart,
            r0_data => r0_data,
            rx_empty => rx_empty,
            tx_full => tx_full,
            tx => tx
        );
    Classifier : classify_subsystem
        generic map (
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            clk => clk,
            rst => reset,
            r0_data => r0_data,
            rx_empty => rx_empty,
            tx_full => tx_full,
            w1_data => w1_data,
            rd_uart => rd_uart,
            wr_uart => wr_uart
        );

end Behavioral;
