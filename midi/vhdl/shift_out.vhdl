library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_out is
  port ( 
    par_in : in std_logic_vector(9 downto 0);
    load : in std_logic;
    ser_out : out std_logic;
    clk : in std_logic;
    ce : in std_logic
  );
end shift_out;

architecture behavioral of shift_out is
  signal par : std_logic_vector(9 downto 0);
begin
  process(clk, load)
    variable data : std_logic;
  begin
    if rising_edge(clk) then
      if (load = '1') then
        par <= par_in;
        data := '0';
      elsif (ce = '1') then
        data := par(0);
        par <= '0' & par(9 downto 1);
      end if;
    end if;
    ser_out <= data;
  end process;
end behavioral;

