--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:48:46 01/29/2015
-- Design Name:   
-- Module Name:   /home/james/devroot/learnfpga/analogue2/vhdl/analogue_tb.vhdl
-- Project Name:  analogue2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: analogue
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
 
ENTITY analogue_tb IS
END analogue_tb;
 
ARCHITECTURE behavior OF analogue_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT analogue2
    PORT(
         clk50 : IN  std_logic;
         ad_dout : IN  std_logic;
         ad_din : OUT  std_logic;
         ad_cs : OUT  std_logic;
         ad_sclk : OUT  std_logic;
         leds : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk50 : std_logic := '0';
   signal ad_dout : std_logic := '0';

 	--Outputs
   signal ad_din : std_logic;
   signal ad_cs : std_logic;
   signal ad_sclk : std_logic;
   signal leds : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk50_period : time := 10 ns;
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: analogue2 PORT MAP (
          clk50 => clk50,
          ad_dout => ad_dout,
          ad_din => ad_din,
          ad_cs => ad_cs,
          ad_sclk => ad_sclk,
          leds => leds
        );

   -- Clock process definitions
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
      -- hold reset state for 100 ns.
      wait for 105 ns;	
      
      ad_dout <= '0';
      
      wait for clk50_period * 13;
      ad_dout <= '1';
      wait for clk50_period * 48;
      ad_dout <= '0';
      wait for clk50_period * 4;
      
      ad_dout <= '1';
      wait for clk50_period * 16;
      ad_dout <= '0';
      wait for clk50_period * 48;
      ad_dout <= '1';
      wait for clk50_period * 4;
      ad_dout <= '0';

      loop
        ad_dout <= '0';
        wait for clk50_period*50;
        ad_dout <= '1';
        wait for clk50_period*50;
      end loop;

      wait;
   end process;

END;
