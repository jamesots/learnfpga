library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity drum1 is
  port (
    clk50 : in std_logic;
    clk32 : in std_logic;
    portc11 : out std_logic
  );
end drum1;

architecture behavioral of drum1 is
  component dcfifo is
    generic (
      width : positive;
      depth : positive -- in bits, (i.e. real_depth = 2 ** depth)
    );
    port ( 
      wr : in std_logic;
      wr_data : in std_logic_vector(width - 1 downto 0);
      wr_clk : in std_logic;
      wr_full : out std_logic;
      rd : in std_logic;
      rd_data : out std_logic_vector(width - 1 downto 0);
      rd_clk : in std_logic;
      rd_empty : out std_logic
    );
  end component;

  component clock_divider is
    generic (
      divisor : integer
    );
    port (
      clk_in : in std_logic;
      clk_out : out std_logic;
      reset : in std_logic
    );
  end component;
  
  component midi is
    port (
      -- clk must be a 31.25Hz clock
      clk : in std_logic;
      load : in std_logic;
      data_in : in std_logic_vector(7 downto 0);
      midi_out : out std_logic := '0';
      ready : out std_logic := '1'
    );
  end component;

  signal clk_midi : std_logic;
  signal load : std_logic;
  signal value : std_logic_vector(7 downto 0);
  signal ready : std_logic;
  
  signal wr_data : std_logic_vector(7 downto 0);
  signal wr : std_logic;
  signal wr_full : std_logic := '0';
  signal rd_data : std_logic_vector(7 downto 0);
  signal rd : std_logic;
  signal rd_empty : std_logic := '1';
begin
  fifo : dcfifo
    generic map (
      width => 8,
      depth => 3
    )
    port map ( 
      wr => wr,
      wr_data => wr_data,
      wr_clk => clk50,
      wr_full => wr_full,
      rd => rd,
      rd_data => rd_data,
      rd_clk => clk_midi,
      rd_empty => rd_empty
    );

  div : clock_divider 
  generic map (
    divisor => 500
--    divisor => 1
  )
  port map (
    clk_in => clk32,
    clk_out => clk_midi,
    reset => '0'
  );
  
  midi_i : midi
  port map (
    clk => clk_midi,
    load => load,
    data_in => value,
    midi_out => portc11,
    ready => ready
  );
  
  process(clk50)
    variable byte : integer range 0 to 140 := 0;
  begin
    -- if fifo isn't full, write next byte to fifo
    if rising_edge(clk50) then
      if wr_full = '0' then
        if byte = 0 then
          wr_data <= "10010000" after 1 ns;
        elsif byte = 1 then
          wr_data <= "01000101" after 1 ns;
        elsif byte = 2 then
          wr_data <= "01000101" after 1 ns;
        end if;
        wr <= '1' after 1 ns;
        byte := byte + 1;
        if byte = 3 then
          byte := 0;
        end if;
      end if;
      
      if wr = '1' then
        wr <= '0' after 1 ns;
      end if;
    end if;
  end process;
  
  process(clk_midi)
    variable load_value : boolean := false;
    variable read_value : boolean := false;
  begin
    if rising_edge(clk_midi) then
      if read_value then
        value <= rd_data after 1 ns;
        rd <= '0' after 1 ns;
        load_value := true;
        read_value := false;
      end if;

      if ready = '1' then
        if load_value then
          load <= '1' after 1 ns;
          load_value := false;
        else 
          load <= '0' after 1 ns;
          if not read_value then
            if rd_empty = '0' then
              rd <= '1' after 1 ns;
              read_value := true;
            end if;
          end if;
        end if;
      else
        load <= '0' after 1 ns;
      end if;
    end if;
  end process;
end behavioral;
