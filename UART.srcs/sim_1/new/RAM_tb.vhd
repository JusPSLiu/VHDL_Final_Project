library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_RAM is
    -- Testbench has no external ports
end tb_RAM;

architecture behavior of tb_RAM is

    -- Component Declaration for the Unit Under Test (UUT)
    component RAM
        generic (
            WORD : integer := 8; -- 8-bit data
            ADDR_WIDTH : integer := 5 -- 5 bits for 32 addresses
        );
        port (
            address        : in  std_logic_vector(4 downto 0);
            data_in        : in  std_logic_vector(7 downto 0);
            write_in       : in  std_logic;
            clock          : in  std_logic;
            output_enable  : in  std_logic;
            data_out       : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals for connecting to the UUT
    signal address        : std_logic_vector(4 downto 0);
    signal data_in        : std_logic_vector(7 downto 0);
    signal write_in       : std_logic;
    signal clock          : std_logic := '0';
    signal output_enable  : std_logic;
    signal data_out       : std_logic_vector(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: RAM
        port map (
            address        => address,
            data_in        => data_in,
            write_in       => write_in,
            clock          => clock,
            output_enable  => output_enable,
            data_out       => data_out
        );

    -- Clock generation (50 MHz clock)
    clk_process : process
    begin
        clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Write data to address 0
        write_in <= '1';
        output_enable <= '0';  -- Output disabled, data_out should be 'Z'
        address <= "00000";    -- Address 0
        data_in <= "10101010"; -- Data to write
        wait for 20 ns;  -- Wait for 1 clock cycle
        
        -- Test case 2: Read data from address 0 (output_enable = '1')
        write_in <= '0';  -- Write disabled
        output_enable <= '1'; -- Output enabled, should show data
        wait for 20 ns;  -- Wait for 1 clock cycle
        
        -- Test case 3: Write data to address 1
        write_in <= '1';
        output_enable <= '0';  -- Output disabled, data_out should be 'Z'
        address <= "00001";    -- Address 1
        data_in <= "11001100"; -- Data to write
        wait for 20 ns;  -- Wait for 1 clock cycle

        -- Test case 4: Read data from address 1 (output_enable = '1')
        write_in <= '0';  -- Write disabled
        output_enable <= '1'; -- Output enabled, should show data
        wait for 20 ns;  -- Wait for 1 clock cycle
        
        -- Test case 5: Disable output and check high impedance
        output_enable <= '0';  -- Output disabled, data_out should be 'Z'
        wait for 20 ns;  -- Wait for 1 clock cycle

        -- End the simulation
        assert false report "End of simulation" severity failure;
        wait;
    end process;

end behavior;
