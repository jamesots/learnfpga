library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dcfifo is
  generic (
    width : positive;
    depth : positive -- in bits, (i.e. real_depth = 2 ** depth)
  );
  port ( 
    wr : in std_logic;
    wr_data : in std_logic_vector(width - 1 downto 0);
    wr_clk : in std_logic;
    wr_full : out std_logic := '0';
    rd : in std_logic;
    rd_data : out std_logic_vector(width - 1 downto 0);
    rd_clk : in std_logic;
    rd_empty : out std_logic := '1'
  );
end dcfifo;

architecture behavioral of dcfifo is
  subtype depth_int is natural range 0 to 2 ** depth - 1;
  subtype depth_and_loop_int is natural range 0 to 2 ** (depth + 1) - 1;

  component gray_compare is
    generic (
      width : positive
    );
    port ( 
      gray : in std_logic_vector(width - 1 downto 0);
      other_gray : in std_logic_vector(width - 1 downto 0);
      clk : in std_logic;
      eq : out std_logic;
      looped : out std_logic
    );
  end component;
  
  type memory_type is array (0 to depth_int'right) of std_logic_vector(width - 1 downto 0);
  signal mem : memory_type;

  signal head_gray : std_logic_vector(depth downto 0) := (others => '0');
  signal tail_gray : std_logic_vector(depth downto 0) := (others => '0');

  signal full_eq : std_logic := '1';
  signal full_looped : std_logic := '0';
  signal empty_eq : std_logic := '1';
  signal empty_looped : std_logic := '0';
  
  signal temp_wr_full : std_logic := '0';
  signal temp_rd_empty : std_logic := '1';
  
  -- isim can't display variables, so put head and tail in signals
--  signal test_head : std_logic_vector(depth - 1 downto 0);
--  signal test_tail : std_logic_vector(depth - 1 downto 0);
begin
  compare_full : gray_compare
    generic map (
      width => depth + 1
    )
    port map ( 
      gray => head_gray,
      other_gray => tail_gray,
      clk => wr_clk,
      eq => full_eq,
      looped => full_looped
    );
    
  compare_empty : gray_compare
    generic map (
      width => depth + 1
    )
    port map ( 
      gray => tail_gray,
      other_gray => head_gray,
      clk => rd_clk,
      eq => empty_eq,
      looped => empty_looped
    );
    
  wr_full <= full_eq and full_looped;
  rd_empty <= empty_eq and not empty_looped;
  temp_wr_full <= full_eq and full_looped;
  temp_rd_empty <= empty_eq and not empty_looped;

  process(wr_clk)
    variable head_and_loop : depth_and_loop_int := 0;
    variable head : depth_int := 0;
  begin
    if rising_edge(wr_clk) then
      if wr = '1' then
        if temp_wr_full = '0' then
          mem(head) <= wr_data;
          
          if head < depth_int'right then
            head := head + 1;
          else 
            head := 0;
          end if;
--          test_head <= std_logic_vector(to_unsigned(head, depth));
          
          if head_and_loop < depth_and_loop_int'high then
            head_and_loop := head_and_loop + 1;
          else 
            head_and_loop := 0;
          end if;
          
          head_gray <= std_logic_vector(to_unsigned(head_and_loop, depth + 1)
              xor ('0' & to_unsigned(head_and_loop, depth + 1)(depth downto 1)));
        end if;
      end if;
    end if;
  end process;

  process(rd_clk)
    variable tail_and_loop : depth_and_loop_int := 0;
    variable tail : depth_int := 0;
  begin
    if rising_edge(rd_clk) then
      if rd = '1' then
        if temp_rd_empty = '0' then
          rd_data <= mem(tail);
          
          if tail < depth_int'right then
            tail := tail + 1;
          else 
            tail := 0;
          end if;
--          test_tail <= std_logic_vector(to_unsigned(tail, depth));
          
          if tail_and_loop < depth_and_loop_int'right then
            tail_and_loop := tail_and_loop + 1;
          else 
            tail_and_loop := 0;
          end if;
          
          tail_gray <= std_logic_vector(to_unsigned(tail_and_loop, depth + 1)
              xor ('0' & to_unsigned(tail_and_loop, depth + 1)(depth downto 1)));
        end if;
      end if;
    end if;
  end process;
end behavioral;

