
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Classification_Engine_tb is
    Generic (
        WORD : integer := 8
    );
end Classification_Engine_tb;

architecture Behavioral of Classification_Engine_tb is
    -- classification engine component
    component Classification_Engine is
        Port (
            start, grab, clk, rst : in std_logic;
            number : in std_logic_vector(WORD-1 downto 0);
            biggest_power_of_two : out std_logic_vector(WORD-1 downto 0);
            new_data, ready : out std_logic
        );
    end component;
    signal number, result : std_logic_vector(7 downto 0);
    signal start, grab, new_data, ready, clk, rst : std_logic;
begin
    -- etc
    classifier: Classification_Engine
        port map(
            start => start,
            grab => grab,
            clk => clk,
            rst => rst,
            number => number,
            biggest_power_of_two => result,
            new_data => new_data,
            ready => ready
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
        rst <= '1';
        wait for 15ns;
        rst <= '0';
        wait for 10ns;
        
        -- begin tests
        -- Test Case 35 -> 32
        number <= std_logic_vector(to_unsigned(35, 8));
        start <= '1'; wait for 10 ns; grab <= '1';
        wait for 10ns; grab <= '0'; start <= '0'; wait for 10ns;
        
        -- Test Case 7 -> 4
        number <= std_logic_vector(to_unsigned(7, 8));
        start <= '1'; wait for 10 ns; grab <= '1';
        wait for 10ns; grab <= '0'; start <= '0'; wait for 10ns;
        
        -- Test 127 -> 64
        number <= std_logic_vector(to_unsigned(127, 8));
        start <= '1'; wait for 10 ns; grab <= '1';
        wait for 10ns; grab <= '0'; start <= '0'; wait for 10ns;

        -- Test 128 -> 128
        number <= std_logic_vector(to_unsigned(128, 8));
        start <= '1'; wait for 10 ns; grab <= '1';
        wait for 10ns; grab <= '0'; start <= '0'; wait for 10ns;
        
        -- Test 62 -> 32
        number <= std_logic_vector(to_unsigned(62, 8));
        start <= '1'; wait for 10 ns; grab <= '1';
        wait for 10ns; grab <= '0'; start <= '0'; wait for 10ns;
        
        -- Stop Simulation
        wait;
    end process;

end Behavioral;
