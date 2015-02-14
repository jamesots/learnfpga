--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:32:19 01/31/2015
-- Design Name:   
-- Module Name:   /home/james/devroot/learnfpga/midi/tb/shift_out_tb.vhdl
-- Project Name:  midi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_out
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY shift_out_tb IS
END shift_out_tb;
 
ARCHITECTURE behavior OF shift_out_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shift_out
    GENERIC(
      width : positive
    );
    PORT(
         par_in : IN  std_logic_vector(width - 1 downto 0);
         load : IN  std_logic;
         ser_out : OUT  std_logic;
         clk : IN  std_logic;
         ce : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal par_in : std_logic_vector(9 downto 0) := (others => '0');
   signal load : std_logic := '0';
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';

 	--Outputs
   signal ser_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shift_out GENERIC MAP (
    width => 10
    ) PORT MAP (
          par_in => par_in,
          load => load,
          ser_out => ser_out,
          clk => clk,
          ce => ce
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
      load <= '0';
      ce <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      par_in <= "1001110001";
      load <= '1';

      wait for clk_period*10;
      
      load <= '0';
      ce <= '1';
      
      wait for clk_period * 12;
      
      load <= '1';
      
      wait for clk_period;
      load <= '0';

      wait for clk_period * 12;
      
      load <= '1';
      
      wait for clk_period * 5;
      load <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
