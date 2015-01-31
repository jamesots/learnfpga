--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:22:40 01/31/2015
-- Design Name:   
-- Module Name:   /home/james/devroot/learnfpga/midi/tb/midi_tb.vhdl
-- Project Name:  midi
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: midi
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
 
ENTITY midi_tb IS
END midi_tb;
 
ARCHITECTURE behavior OF midi_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT midi
    PORT(
         clk32 : IN  std_logic;
         portc11 : OUT  std_logic;
         leds : OUT  std_logic_vector(7 downto 0)
      );
    END COMPONENT;
    

   --Inputs
   signal clk32 : std_logic := '0';

 	--Outputs
   signal portc11 : std_logic;
   signal leds : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk32_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: midi PORT MAP (
          clk32 => clk32,
          portc11 => portc11,
          leds => leds
        );

   -- Clock process definitions
   clk32_process :process
   begin
		clk32 <= '0';
		wait for clk32_period/2;
		clk32 <= '1';
		wait for clk32_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clk32_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
