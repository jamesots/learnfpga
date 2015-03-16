library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- this component sends stuff to the ftdi without caring whether the buffer
-- is full or not
entity ftdi is
  port (
    ftdi_write : in std_logic;
    ftdi_value : in std_logic_vector(7 downto 0);
    ftdi_ready : out std_logic := '1';

    clk : in std_logic;
    ftdi_d : inout std_logic_vector(7 downto 0);
    ftdi_txe : in std_logic;
    ftdi_rd: out std_logic := '1';
    ftdi_wr: out std_logic  := '1';
    ftdi_siwua: out std_logic := '1'
  );
end ftdi;

architecture Behavioral of ftdi is
  signal data : std_logic_vector(7 downto 0);
  signal step : natural := 0;
begin
process(clk)
  variable char : std_logic_vector(7 downto 0);
  begin
    if rising_edge(clk) then
      case step is
        when 0 =>
          if ftdi_write = '1' then
            data <= ftdi_value after 1 ns;
            ftdi_ready <= '0' after 1 ns;
            step <= step + 1;
          end if;
        when 1 =>
          if ftdi_txe = '0' then
            ftdi_d <= data;
            step <= step + 1;
          end if;
        when 4 =>
          ftdi_wr <= '0';
          step <= step + 1;
        when 8 =>
          ftdi_wr <= '1';
          ftdi_ready <= '1';
          ftdi_d <= "ZZZZZZZZ";
          step <= 0;
        when others =>
          step <= step + 1;
      end case;
    end if;
  end process;

end Behavioral;
