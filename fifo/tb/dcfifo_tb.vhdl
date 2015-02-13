LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY dcfifo_tb IS
END dcfifo_tb;

ARCHITECTURE behavior OF dcfifo_tb IS 

component dcfifo is
  generic (
    width : positive;
    depth : positive -- in bits, (i.e. real_depth = 2 ** depth)
  );
  port ( 
    wr : in std_logic;
    wr_data : in std_logic_vector(width - 1 downto 0);
    wr_clk : in std_logic;
    wr_full : out std_logic;
    rd : in std_logic;
    rd_data : out std_logic_vector(width - 1 downto 0);
    rd_clk : in std_logic;
    rd_empty : out std_logic
  );
end component;

signal wr : std_logic;
signal wr_data : std_logic_vector(3 downto 0);
signal wr_clk : std_logic;
signal wr_full : std_logic;
signal rd : std_logic;
signal rd_data : std_logic_vector(3 downto 0);
signal rd_clk : std_logic;
signal rd_empty : std_logic;

   -- Clock period definitions
   constant rd_clk_period : time := 10 ns;
   constant wr_clk_period : time := 12 ns;

BEGIN

-- Component Instantiation
  uut: dcfifo 
  generic map (
    width => 4,
    depth => 2
  )
  port map ( 
    wr => wr,
    wr_data => wr_data,
    wr_clk => wr_clk, 
    wr_full => wr_full, 
    rd => rd,
    rd_data => rd_data,
    rd_clk => rd_clk,
    rd_empty => rd_empty
  );


   -- Clock process definitions
   wr_clk_process :process
   begin
		wr_clk <= '0';
		wait for wr_clk_period/2;
		wr_clk <= '1';
		wait for wr_clk_period/2;
   end process;

   rd_clk_process :process
   begin
		rd_clk <= '0';
		wait for rd_clk_period/2;
		rd_clk <= '1';
		wait for rd_clk_period/2;
   end process;

--  Test Bench Statements
   wr_tb : PROCESS
    variable count : integer := 0;
   BEGIN
    wr <= '0';
    wr_data <= "0000";

      wait for 10ns;
      
        wr_data <= std_logic_vector(to_unsigned(count, 4));
        count := count + 1;
        wr <= '1';
        wait for wr_clk_period;
        wr_data <= std_logic_vector(to_unsigned(count, 4));
        count := count + 1;
        wr <= '1';
        wait for wr_clk_period;
        wr_data <= std_logic_vector(to_unsigned(count, 4));
        count := count + 1;
        wr <= '1';
        wait for wr_clk_period;
        wr_data <= std_logic_vector(to_unsigned(count, 4));
        count := count + 1;
        wr <= '1';
        wait for wr_clk_period * 20;
        wr <= '0';
        wait for wr_clk_period * 2;

        wr <= '1';

      loop
        wr_data <= std_logic_vector(to_unsigned(count, 4));
        count := count + 1;
        wait for wr_clk_period;
      end loop;

      wait; -- will wait forever
   END PROCESS wr_tb;

   rd_tb : PROCESS
   BEGIN
      rd <= '0';

      wait until wr_full = '1';
      
      loop
        rd <= '1';
        wait for rd_clk_period * 20;
        rd <= '0';
        wait for rd_clk_period * 2;
      end loop;


      wait; -- will wait forever
   END PROCESS rd_tb;

END;
