library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity echotest is
    Port ( clk50 : in  STD_LOGIC;
             sw : in STD_LOGIC_VECTOR (3 downto 0);
             ftdi_d : inout STD_LOGIC_VECTOR (7 downto 0);
             ftdi_rxe : in STD_LOGIC;
             ftdi_txe : in STD_LOGIC;
             ftdi_rd: out STD_LOGIC;
             ftdi_wr: out STD_LOGIC;
             ftdi_siwua: out STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (7 downto 0));
   attribute PULLUP: string;
   attribute PULLUP of sw: signal is "TRUE";
end echotest;

architecture Behavioral of echotest is
   signal rd_wait : std_logic := '0';
   signal wr_wait : std_logic := '0';
   signal wr_done : std_logic := '0';
   signal char : std_logic_vector(7 downto 0);
begin

process(clk50)
   begin
      ftdi_siwua <= '1';
      if rising_edge(clk50) then
         if (sw(0) = '1') then 
            if (rd_wait = '1') then
               leds <= ftdi_d(7 downto 0);
               char <= ftdi_d(7 downto 0);
               ftdi_rd <= '1';
               rd_wait <= '0';

               wr_wait <= '1';
            elsif (wr_wait = '1') then
               if (ftdi_txe = '0') then
                  ftdi_d <= char(7 downto 0);
                  ftdi_wr <= '0';
                  wr_wait <= '0';
                  wr_done <= '1';
               end if;
            elsif (wr_done = '1') then
               ftdi_wr <= '1';
               wr_done <= '0';
               ftdi_d <= "ZZZZZZZZ";
            elsif (ftdi_rxe = '0') then
               ftdi_rd <= '0';
               rd_wait <= '1';
            end if;
         end if;
      end if;
   end process;

end Behavioral;
