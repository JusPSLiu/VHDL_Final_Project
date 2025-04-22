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
        WORD : integer := 8;
        ADDR_W : integer := 3
    );
    Port (
        in_data : in std_logic_vector(WORD-1 downto 0);
        read, write : in std_logic;
        reset : in std_logic;
        clock : in std_logic;
        out_data : out std_logic_vector(WORD-1 downto 0);
        full, empty : out std_logic
    );
end Fifo;

    architecture Behavioral of Fifo is
    component Fifo_Controller is
        Generic (
            ADDR_W : integer
        );
        Port (
            clk, rst, read, write : in std_logic;
            
            w_addr, r_addr : out std_logic_vector(ADDR_W-1 downto 0);
            full, empty : out std_logic
        );
    end component;
    
    component Register_File is
        generic(
            WORD, ADDR_W: integer
        );
        port (
            clk, reset: in std_logic; -- Clock & reset input
            Wr_en: in std_logic; -- Permit write input
            W_addr , r_addr : in std_logic_vector ((ADDR_W-1) downto 0); -- Written & read input
            W_data: in std_logic_vector ((WORD-1) downto 0); -- Written location
            R_data: out std_logic_vector ((WORD-1) downto 0) -- Read location
        );
    end component;
    
    signal read_here : std_logic_vector(WORD-1 downto 0);
    signal full_reg, empty_reg : std_logic:='0';
    signal write_enable, read_enable : std_logic;
    signal w_ptr, r_ptr : std_logic_vector(ADDR_W-1 downto 0);
    
begin

    fifo_control : Fifo_Controller
        generic map(
            ADDR_W => ADDR_W
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
        
    fifo_reg : Register_File
        generic map(
            WORD => WORD,
            ADDR_W => ADDR_W
        )
        port map (
            clk => clock,
            reset => reset,
            Wr_en => write_enable,
            W_addr => w_ptr,
            r_addr => r_ptr,
            W_data => in_data,
            R_data => read_here
        );
        
    -- OUTPUT LOGIC
    -- connect full and empty outputs
    full <= full_reg; empty <= empty_reg;
    -- enable writing when not full
    write_enable <= write when full_reg='0' else '0';
    -- enable output when not empty
    out_data <= read_here when empty_reg='0' else (others => '0');
end Behavioral;
