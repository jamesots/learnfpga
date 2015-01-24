library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analogue is
  Port (
    clk50 : in STD_LOGIC;
    sw : in STD_LOGIC_VECTOR (3 downto 0);
    leds : out STD_LOGIC_VECTOR (7 downto 0);
    ad_dout : in STD_LOGIC;
    ad_din : out STD_LOGIC;
    ad_cs : out STD_LOGIC;
    ad_sclk : out STD_LOGIC
  );
end analogue;

architecture Behavioral of analogue is
  component clock_divider 
  port (
    clk_in : in  STD_LOGIC;
    clk_out : out  STD_LOGIC;
    reset : in STD_LOGIC
  );
  end component;

  signal value : STD_LOGIC_VECTOR (11 downto 0);
  signal step : integer range 0 to 20 := 0;
  signal ad_port : STD_LOGIC_VECTOR (2 downto 0) := "111"; 
  signal reset : STD_LOGIC := '0';
  signal clk : STD_LOGIC;
  signal init : boolean := true;
begin
  div : clock_divider port map (
    clk_in => clk50,
    clk_out => clk,
    reset => reset
  );
  process(clk)
  begin
      ad_sclk <= clk;

      if (rising_edge(clk)) then
        if (not init) then
          if (step >= 5 and step < 16) then
            -- dout is clocked out on the falling edge of the clock,
            -- so read it on the rising edge

            value(16 - step) <= ad_dout;
          elsif (step = 16) then
            value(0) <= ad_dout;
            if (unsigned(value) < 256) then
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
            elsif (unsigned(value) < 3840) then
              leds <= "01111111";
            else
              leds <= "11111111";
            end if;
          end if;
        end if;
      end if;
      if (falling_edge(clk)) then
        if (init) then
          -- send cs high for one clock cycle to make sure
          -- we know where our frames start
          ad_cs <= '1';
          -- 18 = not a normal step - used to send cs low and start the frame
          step <= 18;
          init <= false;
        else 
          step <= step + 1;

          if (step = 18) then
            step <= 1;
            ad_cs <= '0';
            ad_din <= '0';
            value <= "000000000000";
          elsif (step = 16) then
            init <= true;
          end if;

          if ((step >= 2) and (step < 5)) then
            -- din is sampled on rising edge of clock, so set it on
            -- the falling edge
            ad_din <= ad_port(4 - step);
          else
            ad_din <= '0';
          end if;
        end if;
      end if;
  end process;
end Behavioral;
