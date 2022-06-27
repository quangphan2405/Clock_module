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

entity counter_controller is
    Port ( sw_ena : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           repeat_action_imp : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           reset : in STD_LOGIC;
           counter_ena : out STD_LOGIC);
end counter_controller;

architecture Behavioral of counter_controller is
    
    signal Pre_counter_ena: STD_LOGIC;

begin

    process(sw_ena,key_action_imp, repeat_action_imp, key_plus_imp, reset )
    begin
        if (reset='1' and reset'event) then -- should this be after if sw_ena = '1'? then
            Pre_counter_ena <= '0';
        end if;
        if sw_ena = '1' then
            if (key_action_imp = '1' and key_action_imp'event) then --rising edge
                Pre_counter_ena <= '1';
            end if;
            
            if (key_plus_imp = '1' and key_plus_imp'event) then --rising edge
                Pre_counter_ena <= '0';
            end if;
            
            if(repeat_action_imp = '1' and repeat_action_imp'event and Pre_counter_ena ='1') then
                 Pre_counter_ena <= '0';
            end if;
            
             if(repeat_action_imp = '1' and repeat_action_imp'event and Pre_counter_ena ='0') then
                 Pre_counter_ena <= '1';
            end if;
            end if;    
    end process;

counter_ena <= Pre_counter_ena;
end Behavioral;
