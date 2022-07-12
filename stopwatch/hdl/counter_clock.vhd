----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2022 02:26:58 PM
-- Design Name: 
-- Module Name: counter_clock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- reference: http://esd.cs.ucr.edu/labs/tutorial/counter.vhd
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_clock is
    Port ( clk : in STD_LOGIC;
    	   sw_reset:	      in std_logic;
    	   count_ena:	  in std_logic;
    	   csec:	      out std_logic_vector(6 downto 0);
    	   sec:	      out std_logic_vector(6 downto 0);
        	min:	      out std_logic_vector(6 downto 0);
        	hr:	          out std_logic_vector(6 downto 0)
    
    );
end counter_clock;

architecture Behavioral of counter_clock is		 	  
	
    signal csec_signal: std_logic_vector(6 downto 0):="0000000";
    signal sec_signal: std_logic_vector(6 downto 0):="0000000";
    signal min_signal: std_logic_vector(6 downto 0):="0000000";
    signal hr_signal: std_logic_vector(6 downto 0):="0000000";
begin

    process(clk) 
    begin
    
    if (clk='1' and clk'event) then
    
        if sw_reset = '1' then
            csec_signal <= "0000000";
            sec_signal <= "0000000";
            min_signal <= "0000000";
            hr_signal <= "0000000";
 	      
         else
            if count_ena = '1' then
                csec_signal <= csec_signal + 1;
                if csec_signal = "1100011" then
                   csec_signal <= "0000000";
                   sec_signal <= sec_signal + 1;
                   if sec_signal = "111011" then
                      sec_signal <= "0000000";
                      min_signal <= min_signal + 1;
                      if min_signal = "0111011"  then
                          min_signal <= "0000000";
                          hr_signal <= hr_signal + 1;
                          if hr_signal = "0010111" then
                              csec_signal <= csec_signal - csec_signal;
                              sec_signal <= sec_signal - sec_signal;
                              min_signal <= min_signal - min_signal;
                               hr_signal <= hr_signal - hr_signal;
                          end if;
                       end if;
                   end if;
                end if;
            end if;
          end if;
	end if;
    end process;	
	
    csec <= csec_signal;
    sec <= sec_signal;
    min <= min_signal;
    hr <= hr_signal;

end Behavioral;

