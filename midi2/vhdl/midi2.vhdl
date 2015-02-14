library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midi2 is
  port (
    clk32 : in std_logic;
    portc11 : out std_logic
  );
end midi2;

architecture behavioral of midi2 is
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
begin
  div : clock_divider 
  generic map (
    divisor => 500
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
  
  process(clk_midi)
    variable byte : integer range 0 to 140 := 0;
    variable load_value : boolean := false;
  begin
    if rising_edge(clk_midi) then
      if ready = '1' then
        if load_value then
          load <= '1';
          load_value := false;
        else 
          load <= '0';
          if byte = 0 then
            value <= "10010000";
            byte := 1;
            load_value := true;
          elsif byte = 1 then 
            value <= "01000101";
            byte := 2;
            load_value := true;
          elsif byte = 2 then
            value <= "01000101";
            byte := 3;
            load_value := true;
          elsif byte = 139 then
            byte := 0;
          else
            byte := byte + 1;
          end if;
        end if;
      else
        load <= '0';
      end if;
    end if;
  end process;
end behavioral;
