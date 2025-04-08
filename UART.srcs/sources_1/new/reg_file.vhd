library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_file is
    Generic (
        ADDR_WIDTH : integer := 4;  -- Address width (e.g., 4-bit = 16 locations)
        DATA_WIDTH : integer := 8   -- Data width (e.g., 8-bit data)
    );
    Port ( 
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        w_en    : in  STD_LOGIC;
        w_addr  : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
        w_data  : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        r_addr0  : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
        r_data0  : out STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0)
    );
end reg_file;

architecture Behavioral of reg_file is
    type reg_array is array (0 to 2**ADDR_WIDTH-1) of STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal mem : reg_array := (others => (others => '0'));  -- Initialize memory to zeros

begin
    -- Write Process: Synchronous with clock
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                mem <= (others => (others => '0'));  -- Reset memory
            elsif w_en = '1' then
                mem(to_integer(unsigned(w_addr))) <= w_data;  -- Write data
            end if;
        end if;
    end process;

    -- Read: Asynchronous
    r_data <= mem(to_integer(unsigned(r_addr))); 

end Behavioral;
