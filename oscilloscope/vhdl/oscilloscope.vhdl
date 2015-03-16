library IEEE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity oscilloscope is
  port (
    clk50 : in STD_LOGIC;
    ad_dout : in STD_LOGIC;
    ad_din : out STD_LOGIC;
    ad_cs : out STD_LOGIC;
    ad_sclk : out STD_LOGIC;
    ftdi_d : inout STD_LOGIC_VECTOR (7 downto 0);
    ftdi_txe : in STD_LOGIC;
    ftdi_rd : out STD_LOGIC;
    ftdi_wr : out STD_LOGIC;
    ftdi_siwua : out STD_LOGIC
  );
end oscilloscope;

architecture Behavioral of oscilloscope is
  component clock_divider is
    generic (
      divisor : positive
    );
    port (
      clk_in : in std_logic;
      clk_out : out std_logic;
      reset : in std_logic
    );
  end component;

  component adc
  port (
    ad_port : in std_logic_vector (2 downto 0);
    ad_value : out std_logic_vector (11 downto 0);
    ad_newvalue : out std_logic := '0';

    clk : in std_logic;
    ad_dout : in std_logic;
    ad_din : out std_logic := '0';
    ad_cs : out std_logic := '0'
  );
  end component;

  component ftdi
  port (
    ftdi_write : in STD_LOGIC;
    ftdi_value : in STD_LOGIC_VECTOR (7 downto 0);
    ftdi_ready : out STD_LOGIC;

    clk : in STD_LOGIC;
    ftdi_d : inout STD_LOGIC_VECTOR (7 downto 0);
    ftdi_txe : in STD_LOGIC;
    ftdi_rd: out STD_LOGIC;
    ftdi_wr: out STD_LOGIC;
    ftdi_siwua: out STD_LOGIC
  );
  end component;

  component tohex
  port (
    clk : in STD_LOGIC;
    newvalue : in std_logic;
    value : in STD_LOGIC_VECTOR(11 downto 0);
    hex0 : out STD_LOGIC_VECTOR(7 downto 0);
    hex1 : out STD_LOGIC_VECTOR(7 downto 0);
    hex2 : out STD_LOGIC_VECTOR(7 downto 0)
  );
  end component;

  signal value : std_logic_vector(11 downto 0);
  signal newvalue : std_logic;

  signal latestvalue : std_logic_vector(11 downto 0);
  signal step : integer := -1;

  signal data_ready : std_logic := '0';
  signal data : std_logic_vector(7 downto 0);
  signal data_written : std_logic;

  signal hex0 : std_logic_vector(7 downto 0);
  signal hex1 : std_logic_vector(7 downto 0);
  signal hex2 : std_logic_vector(7 downto 0);
  
  signal newhex : std_logic;
  
  signal clk : std_logic;
begin
  comp_div : clock_divider
  generic map (
    divisor => 1
  )
  port map (
    clk_in => clk50,
    clk_out => clk,
    reset => '0'
  );

  comp_adc : adc
  port map (
    ad_port => "000",
    ad_value => value,
    ad_newvalue => newvalue,
    clk => clk,
    ad_dout => ad_dout,
    ad_din => ad_din,
    ad_cs => ad_cs
  );
  
  comp_ftdi : ftdi 
  port map (
    ftdi_write => data_ready,
    ftdi_value => data,
    ftdi_ready => data_written,

    clk => clk,
    ftdi_d => ftdi_d,
    ftdi_txe => ftdi_txe,
    ftdi_rd => ftdi_rd,
    ftdi_wr => ftdi_wr,
    ftdi_siwua => ftdi_siwua
  );
  
  comp_tohex : tohex port map (
    clk => clk,
    newvalue => newhex,
    value => value,
    hex0 => hex0,
    hex1 => hex1,
    hex2 => hex2
  );
  
  ad_sclk <= clk;
  
  process(clk)
    variable data1 : std_logic_vector(7 downto 0);
    variable data2 : std_logic_vector(7 downto 0);
  begin
    if (rising_edge(clk)) then
      if (newvalue = '1' and step = -1) then
--        latestvalue <= value;
        newhex <= '1' after 1 ns;
        step <= 0 after 1 ns;
        data1 := "0" & value(11 downto 6) & 
          (value(11) xor value(10) xor value(9) xor value(8) xor value(7) xor value(6));
        data2 := "1" & value(5 downto 0) & 
          (value(5) xor value(4) xor value(3) xor value(2) xor value(1) xor value(0));
      else
        if data_written = '1' and data_ready = '0' then
          case step is
            when 0 =>
              newhex <= '0' after 1 ns;
              data <= data1 after 1 ns;
              data_ready <= '1' after 1 ns;
              step <= step + 1 after 1 ns;
            when 1 =>
              data <= data2 after 1 ns;
              data_ready <= '1' after 1 ns;
              step <= -1 after 1 ns;
            when others =>
          end case;
        else
          data_ready <= '0' after 1 ns;
        end if;
      end if;
    end if;
  end process;
end Behavioral;

