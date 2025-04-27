
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    Generic (
        WORD : integer := 8;
        ADDR_W : integer := 3
    );
    Port (
        clk, reset, fifo_empty, classify_ready : in std_logic;
        fifo_data : in std_logic_vector(WORD-1 downto 0);
        read_fifo, start_classify : out std_logic;
        current_output : out std_logic_vector(WORD-1 downto 0)
        
        ;write_to_ram, read_from_ram : out std_logic; --- DEBUG OUTPUTS
        the_address : out integer
    );
end FSM;

architecture Behavioral of FSM is
    type state is (idle, loadRAM, classify);
    signal curr_state, next_state : state;
    signal start_addr, address, start_addr_next, addr_next : integer;
    signal fifo_rd, ram_out_enable : std_logic;
    signal address_vector: std_logic_vector(ADDR_W-1 downto 0);
    signal fifo_data_buffer : std_logic_vector(WORD-1 downto 0);
    
    component RAM is
        Generic (
            WORD, ADDR_WIDTH : integer
        );
        port (
            address        : in  std_logic_vector(ADDR_W-1 downto 0);
            data_in        : in  std_logic_vector(WORD-1 downto 0);
            write_in       : in  std_logic;
            clock          : in  std_logic;
            output_enable  : in  std_logic; 
            data_out       : out std_logic_vector(WORD-1 downto 0)
        );
    end component;
begin
    -- set the ram
    my_ram : RAM
        generic map (
            WORD => WORD,
            ADDR_WIDTH => ADDR_W
        )
        port map(
            address => address_vector,
            data_in => fifo_data_buffer,
            write_in => fifo_rd,
            clock => clk,
            output_enable => ram_out_enable,
            data_out => current_output
        );

    -- csl
    process(clk, reset)
    begin
        if (reset='1') then
            curr_state <= idle;
            
            -- set addresses to point to 0
            address <= 0;
            start_addr <= 0;
            address_vector <= (others => '0');
            start_addr_next <= 0;
            addr_next<= 0;
        elsif (rising_edge(clk)) then
            -- new state
            curr_state <= next_state;
            
            -- update start and next addr
            start_addr <= start_addr_next;
            address <= addr_next;
            
            -- output logic here
            if (curr_state=loadRAM and fifo_empty='0') then
                fifo_rd <= '1';
                
                -- no classifying or reading from ram
                start_classify <= '0';
                ram_out_enable <= '0';
    
                -- set the RAM address to point to next address
                address_vector <= std_logic_vector(to_unsigned(address, ADDR_W));
                addr_next <= (address + 1) mod (2**ADDR_W);
                
                -- put the data into the buffer
                fifo_data_buffer <= fifo_data;
            elsif (curr_state=classify and classify_ready='1' and not(address=start_addr)) then
                -- send and classify
                start_classify <= '1';
                ram_out_enable <= '1';
    
                -- don't read fifo
                fifo_rd <= '0';
                
                -- set the RAM address to point to start address
                start_addr_next <= (start_addr + 1) mod (2**ADDR_W);
                address_vector <= std_logic_vector(to_unsigned(start_addr, ADDR_W));
            elsif (curr_state=idle) then
                fifo_rd <= '0';
                ram_out_enable <= '0';
                start_classify <= '0';
                ram_out_enable <= '0';
            end if;
        end if;
    end process;

    --nsl
    process(curr_state, classify_ready, fifo_empty)
    begin
        if (curr_state = idle) then
            -- set next state when fifo is not empty
            if (fifo_empty='0') then
                next_state <= loadRAM;
            elsif (not(address=start_addr) and classify_ready='1') then
                next_state <= classify;
            end if;
        elsif (curr_state = loadRAM) then
            next_state <= idle;
        elsif (curr_state = classify) then
            next_state <= idle;
        end if;
    end process;
    
    -- MOORE OUTPUT
    read_fifo <= fifo_rd;

    -- DEBUG OUTPUTS
    write_to_ram <= fifo_rd;
    read_from_ram <= ram_out_enable;
    the_address <= to_integer(unsigned(address_vector));
end Behavioral;