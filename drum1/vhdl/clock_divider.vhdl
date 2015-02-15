library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
  generic (
    divisor : positive
  );
  Port (
    clk_in : in std_logic;
    clk_out : out std_logic;
    reset : in std_logic
  );
end clock_divider;

architecture behavioral of clock_divider is
begin
  process(clk_in)
    variable t : std_logic := '0';
    variable counter : integer range 0 to divisor + 1 := 0;
  begin
    if rising_edge(clk_in) then
      if (reset = '1') then
        counter := 0;
        t := '0';
      else
        if counter = divisor then
          counter := 0;

          if t = '0' then
            t := '1';
          else
            t := '0';
          end if;
        else
          counter := counter + 1;
        end if;
        clk_out <= t;
      end if;
    end if;
  end process;
end behavioral;

