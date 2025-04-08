library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM_32X8 is
    port (
        address        : in  std_logic_vector(4 downto 0); -- 5 bits for 32 addresses
        data_in        : in  std_logic_vector(7 downto 0); -- 8-bit data
        write_in       : in  std_logic;
        clock          : in  std_logic;
        output_enable  : in  std_logic; 
        data_out       : out std_logic_vector(7 downto 0)
    );
end RAM_32X8;

architecture Behavioral of RAM_32X8 is

    -- PARAMETERIZED WIDTH AND DEPTH
    constant DATA_WIDTH : integer := 8;
    constant ADDR_WIDTH : integer := 5;
    constant DEPTH      : integer := 2**ADDR_WIDTH;

    -- Define RAM type
    type ram_array is array (0 to DEPTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal ram_data : ram_array := (others => (others => '0'));

begin

    -- Write operation (clocked process)
    process(clock)
    begin
        if rising_edge(clock) then
            if write_in = '1' then
                ram_data(to_integer(unsigned(address))) <= data_in; -- data is put into the address
            end if;
        end if;
    end process;

    -- Read operation with output enable control
    process(output_enable)
    begin
        if output_enable = '1' then
            data_out <= ram_data(to_integer(unsigned(address)));
        else
            data_out <= (others => 'Z');  -- Set data_out to high impedance when not enabled
        end if;
    end process;

end Behavioral;
