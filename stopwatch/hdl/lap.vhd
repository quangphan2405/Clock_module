----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 11:54:10 AM
-- Design Name: 
-- Module Name: lap - Behavioral
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

entity lap is
    Port ( sw_ena : in STD_LOGIC;
           counter_ena : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           transmitter_ena : out STD_LOGIC);
end lap;

architecture Behavioral of lap is

    signal Pre_transmitter_ena: STD_LOGIC:='0';
begin

    process(sw_ena, counter_ena, key_minus_imp) -- should I put the Pre_transmitter_ena in the p
   begin
    
      if (sw_ena = '1' and counter_ena = '1') then
                if (rising_edge(key_minus_imp) and Pre_transmitter_ena ='0') then
                    Pre_transmitter_ena <= '1';
                end if;
                 if (rising_edge(key_minus_imp) and Pre_transmitter_ena ='1') then
                    Pre_transmitter_ena <= '0';
                end if;
       end if;
        
    end process;
transmitter_ena <= Pre_transmitter_ena;
end Behavioral;
