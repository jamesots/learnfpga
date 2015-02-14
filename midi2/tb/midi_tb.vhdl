LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY midi_tb IS
END midi_tb;
 
ARCHITECTURE behavior OF midi_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
component midi is
  port (
    -- clk must be a 31.25Hz clock
    clk : in std_logic;
    load : in std_logic;
    data_in : in std_logic_vector(7 downto 0);
    midi_out : out std_logic := '0';
    ready : out std_logic := '1'
  );
end component;

   --Inputs
   
   signal value : std_logic_vector(7 downto 0) := (others => '0');
   signal load : std_logic := '0';
   signal clk : std_logic := '0';
   signal midi_out : std_logic;
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: midi port map (
    clk => clk,
    load => load,
    data_in => value,
    midi_out => midi_out,
    ready => ready
   );
   
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
    variable byte : integer range 0 to 40 := 0;
    variable load_value : boolean := false;
   begin		
      wait for clk_period / 2;

      loop
        wait for clk_period;
      if ready = '1' then
        if load_value then
          load <= '1' after 1ns;
          load_value := false;
        else 
          load <= '0' after 1ns;
          if byte = 0 then
            value <= "10010000" after 1ns;
            byte := 1;
            load_value := true;
          elsif byte = 1 then 
            value <= "01000101" after 1ns;
            byte := 2;
            load_value := true;
          elsif byte = 2 then
            value <= "01000101" after 1ns;
            byte := 3;
            load_value := true;
          elsif byte = 39 then
            byte := 0;
          else
            byte := byte + 1;
          end if;
        end if;
      else
        load <= '0' after 1ns;
      end if;
      end loop;
      wait;
   end process;

END;
