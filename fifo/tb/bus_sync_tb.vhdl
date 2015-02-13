LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bus_sync_tb IS
END bus_sync_tb;
 
ARCHITECTURE behavior OF bus_sync_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bus_sync
    GENERIC(
      width : positive
    );
    PORT(
         bus_in : IN  std_logic_vector(7 downto 0);
         bus_out : OUT  std_logic_vector(7 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal bus_in : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal bus_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bus_sync GENERIC MAP(
      width => 8
   )
   PORT MAP (
          bus_in => bus_in,
          bus_out => bus_out,
          clk => clk
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
   begin		
      -- hold reset state for 100 ns.
      wait for clk_period;
      
      bus_in <= "11111111";
      wait for clk_period;
      
      bus_in <= "00000000";
      wait for clk_period;

      bus_in <= "01010101";
      wait for clk_period;

      bus_in <= "11110000";
      wait for clk_period;

      bus_in <= "00001111";
      wait for clk_period;

      wait;
   end process;

END;
