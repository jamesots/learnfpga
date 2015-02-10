library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adc is
  port (
    ad_port : in std_logic_vector (2 downto 0);
    ad_value : out std_logic_vector (11 downto 0);
    ad_newvalue : out std_logic;

    clk : in std_logic;
    ad_dout : in std_logic;
    ad_din : out std_logic;
    ad_cs : out std_logic;
    ad_sclk : out std_logic
  );
end adc;

architecture behavioral of adc is
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

  component shift_in
    generic (
      width : positive
    );
    port (
      reset : in std_logic;
      clk : in std_logic;
      ce : in std_logic;
      ser_in : in std_logic;
      par_out : out std_logic_vector(11 downto 0)
    );
  end component;

  component shift_out is
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
  end component;

  signal step : integer range 0 to 18 := 16;
  signal reset : std_logic := '0';
  signal clk_adc : std_logic;

  signal si_ce : std_logic;
  signal si_clk : std_logic;
  signal si_par_out : std_logic_vector(11 downto 0);
  
  signal so_ce : std_logic;
  signal so_load : std_logic;
  signal so_clk : std_logic;
begin
  div : clock_divider 
  generic map (
    divisor => 1
  )
  port map (
    clk_in => clk,
    clk_out => clk_adc,
    reset => reset
  );
  
  si : shift_in
  generic map (
    width => 12
  )
  port map (
    reset => '0',
    clk => clk_adc,
    ce => si_ce,
    
    ser_in => ad_dout,
    par_out => si_par_out
  );
  
  so : shift_out 
  generic map (
    width => 3
  )
  port map (
    par_in => ad_port,
    load => so_load,
    ser_out => ad_din,
    clk => so_clk,
    ce => so_ce
  );

  ad_sclk <= clk_adc;
  so_clk <= not clk_adc;
  
  process(clk_adc)
  begin
      if falling_edge(clk_adc) then
        if step > 3 and step < 16 then
          si_ce <= '1' after 5ns; -- try to keep isim happy
        else
          si_ce <= '0' after 5ns;
        end if;
        
        if step > 0 and step < 4 then
          so_ce <= '1' after 5ns;
        else
          so_ce <= '0' after 5ns;
        end if;

        step <= step + 1;
        if step = 16 then
          ad_value <= si_par_out;
          ad_cs <= '1';
          step <= 0;
          
          so_load <= '1';
        elsif step = 0 then
          -- send cs high for one clock cycle to make sure
          -- we know where our frames start
          ad_cs <= '0';

          ad_newvalue <= '1';
          
          so_load <= '0' after 5ns;
          
          step <= 1;
        else
          ad_cs <= '0';
          ad_newvalue <= '0';
        end if;
      end if;
  end process;
end behavioral;
