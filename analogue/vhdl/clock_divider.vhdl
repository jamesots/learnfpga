library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
  Port (
    clk_in : in STD_LOGIC;
    clk_out : out STD_LOGIC;
    reset : in STD_LOGIC
  );
end clock_divider;

architecture Behavioral of clock_divider is
  signal t : STD_LOGIC := '0';
  signal counter : integer range 0 to 2 := 0;
begin
  process(clk_in, t)
  begin
    if rising_edge(clk_in) then
      if (reset = '1') then
        counter <= 0;
        t <= '0';
      else
        if (counter = 1) then
          counter <= 0;

          if (t = '0') then
            t <= '1';
          else
            t <= '0';
          end if;
        else
          counter <= counter + 1;
        end if;
      end if;
    end if;
    clk_out <= t;
  end process;
end Behavioral;

