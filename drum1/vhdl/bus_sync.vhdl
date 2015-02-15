library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Synchronise all signals in a bus. The value on bus_in will
-- appear on bus_out two rising edges later.
-- Use this to synchronize gray counters. Synchronizing 
-- busses with more than one signal changing at a time is
-- pointless.
entity bus_sync is
  generic (
    width : positive
  );
  port ( 
    bus_in : in std_logic_vector(width - 1 downto 0) := (others => '0');
    bus_out : out std_logic_vector(width - 1 downto 0);
    clk : in std_logic
  );
end bus_sync;

architecture behavioral of bus_sync is
  signal temp : std_logic_vector(width - 1 downto 0) := (others => '0');

  attribute shreg_extract : string;
  attribute shreg_extract of temp : signal is "no";
begin
  process(clk)
  begin
    if rising_edge(clk) then
      for i in 0 to width - 1 loop
        temp(i) <= bus_in(i);
        bus_out(i) <= temp(i);
      end loop;
    end if;
  end process;
end behavioral;

