----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.07.2022 15:29:43
-- Design Name: 
-- Module Name: switch - Behavioral
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

entity switch is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           key_action_long : in STD_LOGIC;
           key_plus_minus : in STD_LOGIC;
           key_enable : in STD_LOGIC;
           fsm_switch_on : in STD_LOGIC;
           fsm_switch_off : in STD_LOGIC;
           second : in STD_LOGIC_VECTOR (5 downto 0);
           minute : in STD_LOGIC_VECTOR (5 downto 0);
           hour : in STD_LOGIC_VECTOR (4 downto 0);
           led_switch_act : out STD_LOGIC;
           lcd_switch_act : out STD_LOGIC;
           led_switch_on : out STD_LOGIC;
           lcd_switchon_data : out STD_LOGIC_VECTOR (20 downto 0);
           lcd_switchoff_data : out STD_LOGIC_VECTOR (20 downto 0));
end switch;

architecture Behavioral of switch is
    component active
        Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           switch_on : in STD_LOGIC;
           switch_off : in STD_LOGIC;
           act_imp : in STD_LOGIC;
           act_long : in STD_LOGIC;
           switch_act : out STD_LOGIC);
    end component;
    component modify_off
        Port ( clk : in STD_LOGIC;
           switch_off : in STD_LOGIC;
           key_enable : in STD_LOGIC;
           key_p_m : in STD_LOGIC;
           rst : in STD_LOGIC;
           ss : out STD_LOGIC_VECTOR (5 downto 0);
           mm : out STD_LOGIC_VECTOR (5 downto 0);
           hh : out STD_LOGIC_VECTOR (4 downto 0));
    end component;
    component modify_on
        Port ( clk : in STD_LOGIC;
           switch_on : in STD_LOGIC;
           key_enable : in STD_LOGIC;
           key_p_m : in STD_LOGIC;
           rst : in STD_LOGIC;
           ss : out STD_LOGIC_VECTOR (5 downto 0);
           mm : out STD_LOGIC_VECTOR (5 downto 0);
           hh : out STD_LOGIC_VECTOR (4 downto 0));
    end component;
    component led
        Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           active : in STD_LOGIC;
           ss_on : in STD_LOGIC_VECTOR (5 downto 0);
           mm_on : in STD_LOGIC_VECTOR (5 downto 0);
           hh_on : in STD_LOGIC_VECTOR (4 downto 0);
           ss_off : in STD_LOGIC_VECTOR (5 downto 0);
           mm_off : in STD_LOGIC_VECTOR (5 downto 0);
           hh_off : in STD_LOGIC_VECTOR (4 downto 0);
           ss : in STD_LOGIC_VECTOR (5 downto 0);
           mm : in STD_LOGIC_VECTOR (5 downto 0);
           hh : in STD_LOGIC_VECTOR (4 downto 0);
           led : out STD_LOGIC);
    end component;
    
    signal switch_act: std_logic;
    signal ss_on, mm_on, ss_off, mm_off : std_logic_vector (5 downto 0);
    signal hh_on, hh_off : std_logic_vector (4 downto 0);
begin
    u1: active port map (clk=>clk, rst=>reset, switch_on=>fsm_switch_on, switch_off=>fsm_switch_off, act_imp=>key_action_imp,
                         act_long=>key_action_long, switch_act=>switch_act);
    u2: modify_off port map(clk=>clk, rst=>reset, switch_off=>fsm_switch_off, key_enable=>key_enable, key_p_m=>key_plus_minus,
                            ss=>ss_off, mm=>mm_off, hh=>hh_off);
    u3: modify_on port map(clk=>clk, rst=>reset, switch_on=>fsm_switch_on, key_enable=>key_enable, key_p_m=>key_plus_minus,
                            ss=>ss_on, mm=>mm_on, hh=>hh_on);
    u4: led port map(clk=>clk, rst=>reset, active=>switch_act, ss_off=>ss_off, mm_off=>mm_off, hh_off=>hh_off, ss_on=>ss_on, mm_on=>mm_on, hh_on=>hh_on,
                     ss=>second, mm=>minute, hh=>hour, led=>led_switch_on);
    led_switch_act <= switch_act;
    lcd_switch_act <= switch_act;
    lcd_switchon_data <= "00" & hh_on & "0" & mm_on & "0" & ss_on;
    lcd_switchoff_data <= "00" & hh_off & "0" & mm_off & "0" & ss_off;
end Behavioral;
