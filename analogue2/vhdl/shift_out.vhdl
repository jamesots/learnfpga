library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_out is
  generic (
    width : positive
  );
  port ( 
    par_in : in std_logic_vector((width - 1) downto 0);
    load : in std_logic;
    ser_out : out std_logic;
    clk : in std_logic;
    ce : in std_logic
  );
end shift_out;

architecture behavioral of shift_out is
  signal par : std_logic_vector((width - 1) downto 0);
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if (load = '1') then
        par <= par_in;
        ser_out <= '0';
      elsif (ce = '1') then
        ser_out <= par(width - 1);
        par <= par((width - 2) downto 0) & '0';
      else
        ser_out <= '0'; -- not necessary, but makes it easier to spot what's going on
      end if;
    end if;
  end process;
end behavioral;

