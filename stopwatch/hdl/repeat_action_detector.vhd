----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/23/2022 07:45:39 AM
-- Design Name: 
-- Module Name: repeat_action_detector - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity repeat_action_detector is
    Port ( clk:	  in std_logic;
            key_action_imp : in STD_LOGIC;
           repeat_action_imp : out STD_LOGIC);
end repeat_action_detector;

architecture Behavioral of repeat_action_detector is
    signal cnt :std_logic_vector(1 downto 0):="00";
    signal Pre_repeat_action_imp :std_logic:='0';
    signal flag : std_logic_vector(2 downto 0):="000";

begin
    process(clk, key_action_imp)
    
    begin
        if (clk='1' and clk'event) and (not (flag = "000")) and key_action_imp = '0' then
            flag <= flag -1;
        end if;
        if flag = "000" then
             cnt <= cnt - cnt; 
        end if;
        if (clk='1' and clk'event and Pre_repeat_action_imp = '1') then
             Pre_repeat_action_imp <= '0';
        end if;
        if rising_edge(key_action_imp) then
            flag <= "000"; --"100"
            cnt <= cnt + 1;
        end if;
        if cnt = 1 then -- cnt=3
            cnt <= cnt - cnt;
            Pre_repeat_action_imp <= '1';
        end if;
        
        
    end process;
    repeat_action_imp <= Pre_repeat_action_imp;
end Behavioral;
