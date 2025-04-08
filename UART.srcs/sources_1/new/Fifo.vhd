----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2025 04:31:29 PM
-- Design Name: 
-- Module Name: Fifo - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Fifo is
    Generic (
        WORD : integer := 8
    );
    Port (
        in_data : in std_logic;
        read, write : in std_logic;
        reset : in std_logic;
        clock : in std_logic;
        out_data : out std_logic;
        full, empty : out std_logic
    );
end Fifo;

architecture Behavioral of Fifo is
    component Fifo_Controller is
        Generic (
            WORD : integer
        );
        Port (
            clk, rst, read, write : in std_logic;
            
            w_addr, r_addr : out integer;
            full, empty : out std_logic
        );
    end component;
    component Fifo_Register_File is
        generic(
            WORD : integer
        );
        port (
            clk, reset: in std_logic; -- Clock & reset input
            Wr_en: in std_logic; -- Permit write input
            W_addr , r_addr : in integer range 0 to WORD-1; -- Written & read input
            W_data: in std_logic; -- Write Input
            R_data: out std_logic -- Read Output
        );
    end component;
    signal write_now, read_here, full_reg, empty_reg, write_enable, read_enable : std_logic;
    signal w_ptr, r_ptr : integer;
begin
    fifo_control : Fifo_Controller
        generic map(
            WORD => WORD
        )
        port map (
            clk => clock,
            rst => reset,
            read => read,
            write => write,
            w_addr => w_ptr,
            r_addr => r_ptr,
            full => full_reg,
            empty => empty_reg
        );
    fifo_reg : Fifo_Register_File
        generic map(
            WORD => WORD
        )
        port map (
            clk => clock,
            reset => reset,
            Wr_en => write_now,
            w_addr => w_ptr,
            r_addr => r_ptr,
            w_data => in_data,
            r_data => read_here
        );

    full <= full_reg; empty <= empty_reg;

    write_now <= write when full_reg='0' else '0';
    out_data <= read_here when empty_reg='0' else '0';
end Behavioral;
