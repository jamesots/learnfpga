library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- this entity is just so that ise synthesises something and I can look at its RTL Schematic and
-- make sure the synchronizer is flip-flops and not a shift register
entity fifo is
  Port (
    clk50 : in std_logic;
    clk32 : in std_logic;
    leds : out std_logic_vector(7 downto 0)
  );
end fifo;

architecture behavioral of fifo is

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

signal wr : std_logic := '0';
signal wr_data : std_logic_vector(7 downto 0) := "00000000";
signal wr_full : std_logic;
signal rd : std_logic := '0';
signal rd_data : std_logic_vector(7 downto 0) := "00000000";
signal rd_empty : std_logic;

begin
  f : dcfifo
    generic map (
      width => 8,
      depth => 4
    )
    port map ( 
      wr => wr,
      wr_data => wr_data,
      wr_clk => clk50,
      wr_full => wr_full,
      rd => rd,
      rd_data => rd_data,
      rd_clk => clk32,
      rd_empty => rd_empty
    );

  process(clk50)
  begin
    if rising_edge(clk50) then
      wr_data <= wr & wr_data(7 downto 1);
      wr <= not wr;
    end if;
  end process;

  process(clk32)
  begin
    if rising_edge(clk32) then
      rd <= not rd;
      leds <= rd_data;
    end if;
  end process;
end behavioral;
