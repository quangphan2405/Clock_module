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

entity reset_control is
    Port (-- clk :     in STD_LOGIC;
          -- sw_ena : in STD_LOGIC;
           sys_reset : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           sw_reset : out STD_LOGIC:='0');
end reset_control;

architecture Behavioral of reset_control is
begin
    process(key_plus_imp, sys_reset) --clk, sw_ena,
    begin
    --  if (clk='1' and clk'event) then
        --  if sw_ena = '1' then  
            sw_reset <= sys_reset OR  key_plus_imp;
          --else
        --    sw_reset <= '0';  
      --    end if;
    --  end if;

     end process;
end Behavioral;