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
  signal t : STD_LOGIC;
  signal counter : integer range 0 to 10 := 10;
  signal value : STD_LOGIC_VECTOR (11 downto 0);
  signal step : integer range 0 to 20 := 0;
  signal ad_port : STD_LOGIC_VECTOR (2 downto 0) := "010"; -- 2
begin
process(clk50)
  begin
    if rising_edge(clk50) then
      if (counter = 10) then
        -- make sure cs is set high to start with so we know where to
        -- start counting steps from
        ad_cs <= '1';
        counter <= 0;

        -- divide clock down to 12.5MHz
      elsif (counter = 2) then
        counter <= 0;

        if (t = '0') then
          t <= '1';

          if (step < 5) then
            ad_cs <= '0';
            step <= step + 1;
          elsif (step < 16) then
            -- dout is clocked out on the falling edge of the clock,
            -- so read it on the rising edge

            value(16 - step) <= ad_dout;
            step <= step + 1;
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
            step <= 1;
          end if;
        else
          t <= '0';

          if ((step >= 3) and (step < 6)) then
            -- din is sampled on rising edge of clock, so set it on
            -- the falling edge
            ad_din <= ad_port(5 - step);
          else
            ad_din <= '0';
          end if;
        end if;
      else
        counter <= counter + 1;
      end if;
    end if;
    ad_sclk <= t;
  end process;
end Behavioral;
