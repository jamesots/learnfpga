LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY gray_compare_tb IS
END gray_compare_tb;
 
ARCHITECTURE behavior OF gray_compare_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT gray_compare
    GENERIC(
      width : positive
    );
    PORT(
         gray : IN  std_logic_vector(width - 1 downto 0);
         other_gray : IN  std_logic_vector(width - 1 downto 0);
         clk : IN  std_logic;
         eq : OUT  std_logic;
         looped : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal head_gc : std_logic_vector(2 downto 0) := (others => '0');
   signal tail_gc : std_logic_vector(2 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal eq : std_logic;
   signal looped : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: gray_compare GENERIC MAP (
      width => 3
   ) PORT MAP (
          gray => head_gc,
          other_gray => tail_gc,
          clk => clk,
          eq => eq,
          looped => looped
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
      -- to start with, gcs are identical - same values, same loopiness,
      -- so it should be empty
      wait for 50 ns;	

      head_gc <= "000";
      tail_gc <= "000";
      wait for clk_period;

      head_gc <= "001";
      tail_gc <= "000";
      wait for clk_period;

      head_gc <= "011";
      tail_gc <= "000";
      wait for clk_period;

      head_gc <= "010";
      tail_gc <= "000";
      wait for clk_period;

      head_gc <= "110";
      tail_gc <= "000";
      wait for clk_period * 4;

      head_gc <= "110";
      tail_gc <= "001";
      wait for clk_period * 4;

      wait;
   end process;

END;
