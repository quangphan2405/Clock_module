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
    Port ( 
           clk: in STD_LOGIC;
           --sw_ena : in STD_LOGIC;
           sw_reset : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           counter_ena : out STD_LOGIC);
end counter_controller;

architecture Behavioral of counter_controller is
    
    signal Pre_counter_ena: STD_LOGIC:='0';
    

begin    
    
    process(clk, sw_reset, key_action_imp, Pre_counter_ena)
    begin
        if (clk='1' and clk'event) then
       --  if sw_ena = '1' then 
                if sw_reset = '1' then
                        Pre_counter_ena <= '0';   
                 else
                     if key_action_imp = '1' then
                      
                                if  Pre_counter_ena ='1' then 
                                          Pre_counter_ena <= '0';
                                 else
                                          Pre_counter_ena <= '1';
                               end if;                    
                    end if;
                 end if;
      --   end if;
          end if;
    end process;

counter_ena <= Pre_counter_ena;
end Behavioral;
