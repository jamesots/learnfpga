--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:36:23 01/29/2015
-- Design Name:   
-- Module Name:   /home/james/devroot/learnfpga/analogue2/vhdl/shift_in_tb.vhd
-- Project Name:  analogue2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_in
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
 
ENTITY shift_in_tb IS
END shift_in_tb;
 
ARCHITECTURE behavior OF shift_in_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shift_in
    GENERIC(
      width: positive
    );
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         ce : IN  std_logic;
         ser_in : IN  std_logic;
         par_out : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal ce : std_logic := '0';
   signal ser_in : std_logic := '0';

 	--Outputs
   signal par_out : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shift_in GENERIC MAP (
    width => 12
   ) PORT MAP (
          reset => reset,
          clk => clk,
          ce => ce,
          ser_in => ser_in,
          par_out => par_out
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
      wait for 100 ns;	

      ce <= '1';
      ser_in <= '1';
      wait for clk_period*10;
      
      -- insert stimulus here 

      wait;
   end process;

END;
