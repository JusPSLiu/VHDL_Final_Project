
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Classification_Engine_tb is
--  Port ( );
end Classification_Engine_tb;

architecture Behavioral of Classification_Engine_tb is
    -- classification engine component
    component Classification_Engine is
        Port (
            number : in std_logic_vector(7 downto 0);
            biggest_power_of_two : out std_logic_vector(7 downto 0)
        );
    end component;
    signal number, result : std_logic_vector(7 downto 0);
begin
    -- etc
    classifier: Classification_Engine
        port map(
            number => number,
            biggest_power_of_two => result
        );
    
    -- begin tests
    process
    begin

        -- Test Case 35 -> 32
        number <= std_logic_vector(to_unsigned(35, 8));
        wait for 5 ns;
        
        -- Test Case 7 -> 4
        number <= std_logic_vector(to_unsigned(7, 8));
        wait for 5 ns;
        
        -- Test 127 -> 64
        number <= std_logic_vector(to_unsigned(127, 8));
        wait for 5 ns;

        -- Test 128 -> 128
        number <= std_logic_vector(to_unsigned(128, 8));
        wait for 5ns;
        
        -- Test 62 -> 32
        number <= std_logic_vector(to_unsigned(62, 8));
        
        -- Stop Simulation
        wait;
    end process;

end Behavioral;
