library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adc is
  port (
    ad_port : in std_logic_vector (2 downto 0);
    ad_value : out std_logic_vector (11 downto 0);
    ad_newvalue : out std_logic := '0';

    clk : in std_logic;
    ad_dout : in std_logic;
    ad_din : out std_logic := '0';
    ad_cs : out std_logic := '0'
  );
end adc;

architecture behavioral of adc is
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

  signal si_par_out : std_logic_vector(11 downto 0);
  
  signal so_load : std_logic;
  signal so_clk : std_logic;
begin
  
  si : shift_in
  generic map (
    width => 12
  )
  port map (
    reset => '0',
    clk => clk,
    ce => '1',
    
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
    ce => '1'
  );

  so_clk <= not clk;
  
  process(clk)
  begin
    if falling_edge(clk) then
      case step is
        when 16 =>
          ad_value <= si_par_out;
          ad_cs <= '1';
          
          step <= 0;
        when 0 =>
          -- send cs high for one clock cycle to make sure
          -- we know where our frames start
          ad_cs <= '0';
          ad_newvalue <= '1';
          
          step <= 1;
        when others =>
          ad_cs <= '0';
          ad_newvalue <= '0';
          
          step <= step + 1;
      end case;
    end if;
  end process;
  
  process(clk)
  begin
    if rising_edge(clk) then
      case step is
        when 1 =>
          so_load <= '1';
        when others =>
          so_load <= '0';
      end case;
    end if;
  end process;
end behavioral;
