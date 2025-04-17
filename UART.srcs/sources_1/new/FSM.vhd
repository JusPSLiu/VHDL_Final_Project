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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 3
    );
   Port (
        clk, reset, fifo_empty : in std_logic;
        fifo_data : in std_logic_vector(WORD-1 downto 0);
        read_fifo, start_classify, write_ram2 : out std_logic;
        classify_output : out std_logic_vector(WORD-1 downto 0)
   );
end FSM;

architecture Behavioral of FSM is
    -- wait for data to appear
    type state is (idle, loadRAM, classify, writeRAM);
    signal curr_state, next_state : state;
    signal start_addr, address : integer;
    signal ram_write, ram_out_enable : std_logic;
    
    component RAM_32X8 is
        port (
            address        : in  std_logic_vector(4 downto 0); -- 5 bits for 32 addresses
            data_in        : in  std_logic_vector(7 downto 0); -- 8-bit data
            write_in       : in  std_logic;
            clock          : in  std_logic;
            output_enable  : in  std_logic; 
            data_out       : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    ram : RAM_32x8
        port map(
            address => std_logic_vector(to_unsigned(address, WORD-1)),
            data_in => fifo_data,
            write_in => ram_write,
            clock => clk,
            output_enable => ram_out_enable,
            data_out => classify_output
        );

    -- csl
    process(clk, reset)
    begin
        if (reset='1') then
            curr_state <= idle;
        elsif (rising_edge(clk)) then
            -- new state
            curr_state <= next_state;
        end if;
    end process;

    --nsl
    process(clk)
    begin
        if (curr_state = idle) then
            -- set next state when fifo is not empty
            if (fifo_empty='0') then
                next_state <= loadRAM;
            end if;
        elsif (curr_state = loadRAM) then
            -- set next state
            if (fifo_empty='0') then
                next_state <= classify;
            end if;
        elsif (curr_state = classify) then
            -- set next state
            next_state <= writeRAM;
            -- outputs
        elsif (curr_state = writeRAM) then
            -- set next state
            next_state <= idle;
        end if;
    end process;
    
    -- output
    -- set read fifo
    read_fifo <= '1' when (curr_state=loadRAM) else '0';
    start_classify <= '1' when (curr_state=classify) else '0';
    write_ram2 <= '1' when (curr_state=writeRAM) else '0';
end Behavioral;
