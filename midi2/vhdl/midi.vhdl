library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity midi is
  port (
    -- clk must be a 31.25Hz clock
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(7 downto 0);
    midi_out : out std_logic := '0';
    ready : out std_logic := '1'
  );
end midi;

architecture behavioral of midi is
  component shift_out is
    generic (
      width : integer
    );
    port ( 
      par_in : in std_logic_vector(width - 1 downto 0);
      load : in std_logic;
      ser_out : out std_logic;
      clk : in std_logic;
      ce : in std_logic
    );
  end component;
  
  signal ce : std_logic := '1';
  signal step : integer range 0 to 10 := 10;
  signal is_ready : std_logic := '1';
begin
  shift : shift_out 
  generic map (
    width => 10
  )
  port map (
    par_in => '0' & not data_in & '1',
    load => load and is_ready,
    ser_out => midi_out,
    clk => clk,
    ce => ce
  );
  
  ready <= is_ready;

  process(clk)
  begin
    if rising_edge(clk) then
      if load = '1' and is_ready = '1' then
        step <= 0 after 1ns;
        is_ready <= '0' after 1ns;
      else
        if step = 7 then
          is_ready <= '1' after 1ns;
        end if;
        if step < 10 then
          step <= step + 1 after 1ns;
        end if;
      end if;
    end if;
  end process;
end behavioral;
