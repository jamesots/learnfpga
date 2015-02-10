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
      par_out : out std_logic_vector(width - 1 downto 0)
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

  signal si_ce : std_logic := '0';
  signal si_clk : std_logic;
  signal si_par_out : std_logic_vector(11 downto 0);
  
  signal so_ce : std_logic := '0';
  signal so_load : std_logic;
  signal so_clk : std_logic;
  
  signal par_out_nc : std_logic_vector(2 downto 0);
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
    width => 15
  )
  port map (
    reset => '0',
    clk => clk_adc,
    ce => si_ce,
    
    ser_in => ad_dout,
    par_out(11 downto 0) => si_par_out,
    par_out(14 downto 12) => par_out_nc -- we don't care about these bits
  );
  
  so : shift_out 
  generic map (
    width => 15
  )
  port map (
    par_in(13 downto 11) => ad_port,
    par_in(14) => '0',  -- adc doesn't care about these bits
    par_in(10 downto 0) => "00000000000",  -- or these
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
        case step is
          when 16 =>
            ad_value <= si_par_out;
            ad_cs <= '1';
            
            si_ce <= '0' after 5ns;
            so_ce <= '0' after 5ns;
            so_load <= '1' after 5ns;

            step <= 0;
          when 0 =>
            -- send cs high for one clock cycle to make sure
            -- we know where our frames start
            ad_cs <= '0';
            ad_newvalue <= '1';
            
            si_ce <= '1' after 5ns;
            so_ce <= '1' after 5ns;
            so_load <= '0' after 5ns;
            
            step <= 1;
          when others =>
            ad_cs <= '0';
            ad_newvalue <= '0';
            
            step <= step + 1;
        end case;
      end if;
  end process;
end behavioral;