library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midi is
  port (
    clk32 : in std_logic;
    portc11 : out std_logic
  );
end midi;

architecture behavioral of midi is
  component clock_divider is
    port (
      clk_in : in std_logic;
      clk_out : out std_logic;
      reset : in std_logic
    );
  end component;

  component shift_out is
    port ( 
      par_in : in std_logic_vector(9 downto 0);
      load : in std_logic;
      ser_out : out std_logic;
      clk : in std_logic;
      ce : in std_logic
    );
  end component;
  
  signal step : integer range 0 to 10 := 9;
  signal clk_midi : std_logic;
  signal value : std_logic_vector(9 downto 0) := "0000000000";
  signal load : std_logic := '0';
  signal ce : std_logic := '1';
  signal byte : integer range 0 to 4 := 3;
  signal ser_out : std_logic;
begin
  div : clock_divider port map (
    clk_in => clk32,
    clk_out => clk_midi,
    reset => '0'
  );
  
  shift : shift_out port map (
    par_in => value,
    load => load,
    ser_out => ser_out,
    clk => clk_midi,
    ce => ce
  );

  process(clk_midi, ser_out)
  begin
  --send 9A 45 45   10011010 01000101 01000101
    portc11 <= ser_out;
    if rising_edge(clk_midi) then
      if (step = 9) then
        if (byte = 0) then
          value <= not "1100100000";
          byte <= byte + 1;
        elsif (byte = 1) then 
          value <= not "1010001010";
          byte <= byte + 1;
        elsif (byte = 2) then
          value <= not "1010001010";
          byte <= byte + 1;
        elsif (byte = 3) then
          value <= "0000000000";
          byte <= byte + 1;
        else
          value <= "0000000000";
          byte <= 0;
        end if;
        load <= '1';
        step <= 0;
      elsif step = 0 then
        ce <= '1';
        load <= '0';
        step <= step + 1;
      else
        step <= step + 1;
      end if;
    end if;
  end process;
end behavioral;
