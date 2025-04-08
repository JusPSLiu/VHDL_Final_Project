library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sub_Register_tb is
end Sub_Register_tb;
architecture arch of Sub_Register_tb is

-- Component Declaration
component Sub_Register is
    port (
        clk, reset: in std_logic; -- Clock & reset input
        Wr_en: in std_logic; -- Permit write input
        Ri_en: in std_logic; -- Permit read output
        W_data: in std_logic_vector(7 downto 0); -- Written location
        R_data: out std_logic_vector(7 downto 0) -- Read location
    );
end component;

-- Signal Declarations
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal Wr_en: std_logic := '0';
signal Ri_en: std_logic := '0';
signal W_data: std_logic_vector(7 downto 0) := (others => '0');
signal R_data: std_logic_vector(7 downto 0);
begin

-- Instantiate Subsystem Register
SR: Sub_Register
    port map(
        clk => clk,
        reset => reset,
        Wr_en => Wr_en,
        Ri_en => Ri_en,
        W_data => W_data,
        R_data => R_data
    );

-- Testbench Process
    process
    begin

        -- Test Case
        W_data <= (others => '0');
        W_data(1) <= '1';
        W_data(2) <= '1';
        W_data(6) <= '1';
        Wr_en <= '0';
        Ri_en <= '0';
        reset <= '1';
        wait for 500 ns;
        reset <= '0';
        wait for 500 ns;
        Wr_en <= '1';
        wait for 1000 ns;
        Wr_en <= '0';
        W_data <= (others => '0');
        wait for 1000 ns;
        Ri_en <= '1';

    -- Stop Simulation
    wait;
    end process;

-- Clock Process
    process
    begin
    
    for i in 1 to 5000000 loop -- Repeat clock cycle
            clk <= '1';
            wait for 100 ns;
            clk <= '0';
            wait for 100 ns;
        end loop;
        
    -- Stop Clock
    wait;
    end process;

end arch;
