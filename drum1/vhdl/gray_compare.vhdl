library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gray_compare is
  generic (
    width : positive
  );
  port ( 
    -- These gray counters are interpreted as the MSB being a looped indicator
    -- and the rest being the actual value. Invert the MSB of the value 
    -- (that is, gray(width-2)) to get the real value when the looped
    -- flag is set.
    -- This gray counter is updated on our clock
    gray : in std_logic_vector(width - 1 downto 0);
    -- This gray counter is updated on another clock
    other_gray : in std_logic_vector(width - 1 downto 0);
    clk : in std_logic;
    -- Set high when both values are equal
    eq : out std_logic := '0';
    -- Tet high when only one counter has looped
    looped : out std_logic := '0'
  );
end gray_compare;

architecture behavioral of gray_compare is
  component bus_sync is
    generic (
      width : positive
    );
    port ( 
      bus_in : in std_logic_vector(width - 1 downto 0);
      bus_out : out std_logic_vector(width - 1 downto 0);
      clk : in std_logic
    );
  end component;

  signal gray_sync : std_logic_vector(width - 1 downto 0);
  
--  signal test1 : std_logic_vector(width - 2 downto 0);
--  signal test2 : std_logic_vector(width - 2 downto 0);
begin
  sync : bus_sync
  generic map (
    width => width
  )
  port map (
    bus_in => other_gray,
    bus_out => gray_sync,
    clk => clk
  );

  process(clk)
    variable looped1 : std_logic := '0';
    variable looped2 : std_logic := '0';
    variable value1 : std_logic_vector(width - 2 downto 0) := (others => '0');
    variable value2 : std_logic_vector(width - 2 downto 0) := (others => '0');
  begin
    if falling_edge(clk) then
      looped1 := gray(width - 1);
      if looped1 = '1' then
        value1 := (not gray(width - 2)) & gray(width - 3 downto 0);
      else 
        value1 := gray(width - 2 downto 0);
      end if;
      looped2 := gray_sync(width - 1);
      if looped2 = '1' then
        value2 := (not gray_sync(width - 2)) & gray_sync(width - 3 downto 0);
      else
        value2 := gray_sync(width - 2 downto 0);
      end if;
--      test1 <= value1;
--      test2 <= value2;
      if value1 = value2 then
        eq <= '1';
      else
        eq <= '0';
      end if;
      if looped1 = looped2 then
        looped <= '0';
      else 
        looped <= '1';
      end if;
    end if;
  end process;
end behavioral;


