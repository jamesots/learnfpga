library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analogue2 is
  Port (
    clk50 : in STD_LOGIC;
    ad_dout : in STD_LOGIC;
    ad_din : out STD_LOGIC;
    ad_cs : out STD_LOGIC;
    ad_sclk : out STD_LOGIC;
    leds : out STD_LOGIC_VECTOR(7 downto 0)
  );
end analogue2;

architecture Behavioral of analogue2 is
  component clock_divider 
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
    ad_port : in STD_LOGIC_VECTOR (2 downto 0);
    ad_value : out STD_LOGIC_VECTOR (11 downto 0);
    ad_newvalue : out STD_LOGIC;

    clk : in STD_LOGIC;
    ad_dout : in STD_LOGIC;
    ad_din : out STD_LOGIC;
    ad_cs : out STD_LOGIC
  );
  end component;

  signal clk_adc : std_logic;
  signal newvalue : std_logic;
  signal value : std_logic_vector(11 downto 0);
begin
  div : clock_divider 
  generic map (
    divisor => 1
  )
  port map (
    clk_in => clk50,
    clk_out => clk_adc,
    reset => '0'
  );

  adc1 : adc port map (
    ad_port => "111",
    ad_value => value,
    ad_newvalue => newvalue,
    
    clk => clk_adc,
    ad_dout => ad_dout,
    ad_din => ad_din,
    ad_cs => ad_cs
  );
  
  ad_sclk <= clk_adc;
  
  process(clk50)
  begin
    if rising_edge(clk50) then
      if newvalue = '1' then
        if (unsigned(value) < 1) then -- was 256, changed to 1 to check if we actually get a zero at all
          leds <= "00000000";
        elsif (unsigned(value) < 768) then
          leds <= "00000001";
        elsif (unsigned(value) < 1280) then
          leds <= "00000011";
        elsif (unsigned(value) < 1792) then
          leds <= "00000111";
        elsif (unsigned(value) < 2304) then
          leds <= "00001111";
        elsif (unsigned(value) < 2816) then
          leds <= "00011111";
        elsif (unsigned(value) < 3328) then
          leds <= "00111111";
        elsif (unsigned(value) < 4095) then -- changed to 4095 to seee if we actually get a 4095
          leds <= "01111111";
        else
          leds <= "11111111";
        end if;
      end if;
    end if;
  end process;
end Behavioral;
