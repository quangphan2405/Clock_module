----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 11:54:10 AM
-- Design Name: 
-- Module Name: counter_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity countdown is
    Port ( 
           clk: in STD_LOGIC;
           countdown_ena : in STD_LOGIC;
           countdown_reset : in STD_LOGIC;
           counter_ena : out STD_LOGIC);
end countdown;

architecture Behavioral of countdown is
    
    

begin      
    process(clk,countdown_ena, countdown_reset)
    begin
        if (clk='1' and clk'event) then
		 if countdown_ena = '1' then 
		        if countdown_reset = '1' then
		                counter_ena <= '0';   
		         else
		        	counter_ena <= '1';  
		         end if;
		 end if;
        end if;
    end process;

end Behavioral;
