LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY drum1_tb IS
END drum1_tb;
 
ARCHITECTURE behavior OF drum1_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT drum1
    PORT(
         clk50 : IN  std_logic;
         clk32 : IN  std_logic;
         portc11 : OUT  std_logic
      );
    END COMPONENT;
    

   --Inputs
   signal clk32 : std_logic := '0';
   signal clk50 : std_logic := '0';

 	--Outputs
   signal portc11 : std_logic;

   -- Clock period definitions
   constant clk32_period : time := 10 ns;
   constant clk50_period : time := 8 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: drum1 PORT MAP (
          clk50 => clk50,
          clk32 => clk32,
          portc11 => portc11
        );

   -- Clock process definitions
   clk32_process :process
   begin
		clk32 <= '0';
		wait for clk32_period/2;
		clk32 <= '1';
		wait for clk32_period/2;
   end process;
 
   clk50_process :process
   begin
		clk50 <= '0';
		wait for clk50_period/2;
		clk50 <= '1';
		wait for clk50_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clk32_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;