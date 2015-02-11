library ieee;
use ieee.std_logic_1164.all;
 
entity adc_tb is
end adc_tb;
 
architecture behavior of adc_tb is
 
  component adc
  port (
    ad_port : in std_logic_vector(2 downto 0);
    ad_value : out std_logic_vector(11 downto 0);
    ad_newvalue : out std_logic;
    clk : in std_logic;
    ad_dout : in std_logic;
    ad_din : out std_logic;
    ad_cs : out std_logic
  );
  end component;

  --Inputs
  signal ad_port : std_logic_vector(2 downto 0) := "111";
  signal clk : std_logic := '0';
  signal ad_dout : std_logic := '0';

  --Outputs
  signal ad_value : std_logic_vector(11 downto 0);
  signal ad_newvalue : std_logic;
  signal ad_din : std_logic;
  signal ad_cs : std_logic;
  
  signal test : std_logic := '0';

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin 
  uut: adc 
  port map (
    ad_port => ad_port,
    ad_value => ad_value,
    ad_newvalue => ad_newvalue,
    clk => clk,
    ad_dout => ad_dout,
    ad_din => ad_din,
    ad_cs => ad_cs
  );

  -- Clock process definitions
  clk_process :process
  begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
  end process;

   -- Stimulus process
  stim_proc: process
  begin		
    wait for clk_period * 1.5;	
    
    ad_dout <= '0';
    
    wait for clk_period * 4;
    ad_dout <= '1';
    wait for clk_period * 12;
    ad_dout <= '0';
    wait for clk_period;
    
    ad_dout <= '1';
    wait for clk_period * 4;
    ad_dout <= '0';
    wait for clk_period * 12;
    ad_dout <= '1';
    wait for clk_period;
    ad_dout <= '0';

    loop
      ad_dout <= '0';
      wait for clk_period*10;
      ad_dout <= '1';
      wait for clk_period*10;
    end loop;

    wait;
  end process;
  
  test_proc: process
  begin
    -- toggling test so I can see where the asserts are in ISIM
    wait for clk_period;	
    test <= '1';
    assert ad_newvalue = '0';
    assert ad_cs = '1';
    
    wait for clk_period;
    test <= '0';
    assert ad_newvalue = '1';
    assert ad_cs = '0';
    assert ad_value = "000000000000";
    
    wait for clk_period * 2;
    test <= '1';
    assert ad_newvalue = '0';
    assert ad_cs = '0';
    assert ad_din = '1';
    
    wait for clk_period;
    test <= '0';
    assert ad_din = '1';
    
    wait for clk_period;
    test <= '1';
    assert ad_din = '1';
    
    wait for clk_period * 12;
    test <= '0';
    assert ad_cs = '1';

    wait for clk_period;
    test <= '1';
    assert ad_newvalue = '1';
    assert ad_value = "111111111111";
    
    wait;
  end process;
end;
