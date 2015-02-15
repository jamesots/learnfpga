library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
  port ( 
    clk : in std_logic;
    din : in std_logic;
    dout : out std_logic
  );
end debounce;

architecture behavioral of debounce is
  
begin
  process(clk) 
    variable count : natural := 0;
    variable value : std_logic := '0';
  begin
    if rising_edge(clk) then
      if value /= din then
        value := din;
        count := 0;
      else
        count := count + 1;
        if count = 1000000 then
          dout <= value after 1 ns;
        end if;
      end if;
    end if;
  end process;

end behavioral;

