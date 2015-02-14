library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_out is
  generic (
    width : positive
  );
  port ( 
    par_in : in std_logic_vector(width - 1 downto 0);
    -- when load is high, par_in is loaded into the shift register
    -- if ce is also high, ser_out will immediately output the MSB
    load : in std_logic;
    ser_out : out std_logic := '1';
    clk : in std_logic;
    ce : in std_logic
  );
end shift_out;

architecture behavioral of shift_out is
begin
  process(clk)
    variable par : std_logic_vector(width - 1 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if load = '1' then
        par := par_in;
        ser_out <= '0' after 1ns;
      end if;
      if ce = '1' then
        ser_out <= par(0) after 1ns;
        par := '0' & par((width - 1) downto 1);
      else
        ser_out <= '0' after 1ns; -- not necessary, but makes it easier to spot what's going on
      end if;
    end if;
  end process;
end behavioral;

