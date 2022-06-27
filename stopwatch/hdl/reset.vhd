----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 11:54:10 AM
-- Design Name: 
-- Module Name: reset - Behavioral
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

entity reset is
    Port ( --Clk      : in STD_LOGIC;
           sys_reset : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           sw_reset : out STD_LOGIC);
end reset;

architecture Behavioral of reset is
begin

   -- process(Clk) is
   -- begin
    
        --if rising_edge(Clk) then --is the clock needed
            sw_reset <= sys_reset OR  key_plus_imp;
        --end if;
        
    --end process;
end Behavioral;
