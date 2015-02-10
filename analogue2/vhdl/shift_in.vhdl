library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- shifts data into the LSB
entity shift_in is
  generic (
    width : positive
  );
  port (
    reset : in std_logic;
    clk : in std_logic;
    ce : in std_logic;
    ser_in : in std_logic;
    par_out : out std_logic_vector(width - 1 downto 0)
  );
end shift_in;

architecture behavioral of shift_in is
  signal par : std_logic_vector(width - 1 downto 0) := (others => '0');
begin
process(clk)
  begin
    if (rising_edge(clk)) then
      if (reset = '1') then
        par <= (others => '0');
      elsif (ce = '1') then
        par <= par(width - 2 downto 0) & ser_in;
      end if;
    end if;
  end process;
  par_out <= par;
end behavioral;
