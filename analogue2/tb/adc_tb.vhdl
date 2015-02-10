--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:50:40 01/29/2015
-- Design Name:   
-- Module Name:   /home/james/devroot/learnfpga/analogue2/vhdl/adc_tb.vhdl
-- Project Name:  analogue2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adc
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
 
ENTITY adc_tb IS
END adc_tb;
 
ARCHITECTURE behavior OF adc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT adc
    PORT(
         ad_port : IN  std_logic_vector(2 downto 0);
         ad_value : OUT  std_logic_vector(11 downto 0);
         ad_newvalue : OUT  std_logic;
         clk : IN  std_logic;
         ad_dout : IN  std_logic;
         ad_din : OUT  std_logic;
         ad_cs : OUT  std_logic;
         ad_sclk : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ad_port : std_logic_vector(2 downto 0) := "111";
   signal clk : std_logic := '0';
   signal ad_dout : std_logic := '0';

 	--Outputs
   signal ad_value : std_logic_vector(11 downto 0);
   signal ad_newvalue : std_logic;
   signal ad_din : std_logic;
   signal ad_cs : std_logic;
   signal ad_sclk : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: adc PORT MAP (
          ad_port => ad_port,
          ad_value => ad_value,
          ad_newvalue => ad_newvalue,
          clk => clk,
          ad_dout => ad_dout,
          ad_din => ad_din,
          ad_cs => ad_cs,
          ad_sclk => ad_sclk
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

      loop
        ad_dout <= '1';
        wait for clk_period*30;
        ad_dout <= '0';
        wait for clk_period*30;
      end loop;

      wait;
   end process;

END;
