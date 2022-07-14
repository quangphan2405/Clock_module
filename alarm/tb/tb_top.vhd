----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2022 21:41:50
-- Design Name: 
-- Module Name: tb_top - Behavioral
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

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is
    component alarm
        Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           key_action_long : in STD_LOGIC;
           key_plus_minus : in STD_LOGIC;
           key_enable : in STD_LOGIC;
           fsm_alarm_start : in STD_LOGIC;
           second : in STD_LOGIC_VECTOR (6 downto 0);
           minute : in STD_LOGIC_VECTOR (6 downto 0);
           hour : in STD_LOGIC_VECTOR (6 downto 0);
           led_alarm_act : out STD_LOGIC;
           led_alarm_ring : out STD_LOGIC;
           lcd_alarm_act : out STD_LOGIC;
           lcd_alarm_snooze : out STD_LOGIC;
           --lcd_alarm_ss : out STD_LOGIC_VECTOR (5 downto 0);
           lcd_alarm_mm : out STD_LOGIC_VECTOR (6 downto 0);
           lcd_alarm_hh : out STD_LOGIC_VECTOR (6 downto 0));
           --lcd_alarm_data : out STD_LOGIC_VECTOR (13 downto 0));
    end component;
    
    signal clk, reset, key_action_imp, key_action_long, key_plus_minus, key_enable, fsm_alarm_start: std_logic := '0';
    signal second : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
    signal minute : STD_LOGIC_VECTOR (6 downto 0) := "0010000";
    signal hour : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
    signal led_alarm_act, led_alarm_ring, lcd_alarm_act, lcd_alarm_snooze: std_logic;
    --signal ss : STD_LOGIC_VECTOR (5 downto 0);
    signal mm : STD_LOGIC_VECTOR (6 downto 0);
    signal hh : STD_LOGIC_VECTOR (6 downto 0);
    --signal data : STD_LOGIC_VECTOR (13 downto 0);
    constant clk_period: time := 100 ns;

begin
    uut: alarm port map (clk=>clk, reset=>reset, key_action_imp=>key_action_imp, key_action_long=>key_action_long, key_plus_minus=>key_plus_minus, 
                       key_enable=>key_enable, fsm_alarm_start=>fsm_alarm_start, second=>second, minute=>minute, hour=>hour, led_alarm_act=>led_alarm_act,
                       led_alarm_ring=>led_alarm_ring, lcd_alarm_act=>lcd_alarm_act, lcd_alarm_snooze=>lcd_alarm_snooze, lcd_alarm_mm=>mm, lcd_alarm_hh=>hh);
    clock: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clock;
    process
    begin 
    --case1
        wait for 100 ns;
        fsm_alarm_start <= '1';
        key_action_imp <= '1'; wait for 100 ns; key_action_imp <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for 200 ns;
        if (led_alarm_act='0') then
            report "reset successful";
        else
            report "reset failed";
        end if;
     --case2
        wait for 100 ns;
        reset <= '0'; 
        fsm_alarm_start <= '0';  
        wait for 100 ns;
        key_action_imp <= '1'; wait for 100 ns; key_action_imp <= '0';
        wait for 100 ns;
        key_enable <= '1';
        key_plus_minus <= '0';
     --case3
        wait for 100 ns;
        fsm_alarm_start <= '1';
        key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_action_imp <= '1'; wait for 100 ns; key_action_imp <= '0';
        wait for 100 ns;
        key_action_imp <= '1'; wait for 100 ns; key_action_imp <= '0';
        wait for 100 ns;
        key_action_long <= '1'; wait for 100 ns; key_action_long <= '0';
     --case4
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_plus_minus <= '1';
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
     --case5
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        fsm_alarm_start <= '0';
        --reset <= '1';
        wait for 400 ns;
        fsm_alarm_start <= '1';
     --case6
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_action_long <= '1'; wait for 100 ns; key_action_long <= '0';
     --case7
        wait for 100 ns;
        key_plus_minus <= '0';
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 10 ms;
        fsm_alarm_start <= '0';
        wait for 10 ms;
        fsm_alarm_start <= '1';
     --case8 
        wait for 41 ms;
        key_plus_minus <= '1';
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 100 ns;
        key_enable <= '1'; wait for 100 ns; key_enable <= '0';
        wait for 200 us;
        key_action_imp <= '1'; wait for 100 ns; key_action_imp <= '0';
        wait for 200 ns;
        fsm_alarm_start <= '0';
        wait for 10 ms;
        fsm_alarm_start <= '0';
        wait for 60 ms;
        key_action_long <= '1'; wait for 100 ns; key_action_long <= '0';
        --wait for 200 us;
        --key_plus_minus <= '1';
        
        
        wait;
    end process;
    
end Behavioral;
