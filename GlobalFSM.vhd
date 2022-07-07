----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.07.2022 17:25:55
-- Design Name: 
-- Module Name: GlobalFSM - Behavioral
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
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GlobalFSM is
    generic ( wait_3sec : signed(5 downto 0) := "000011");
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           key_mode_imp : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           key_enable : in STD_LOGIC;
           fsm_time_start : out STD_LOGIC;
           fsm_date_start : out STD_LOGIC;
           fsm_alarm_start : out STD_LOGIC;
           fsm_switch_on_start : out STD_LOGIC;
           fsm_switch_off_start : out STD_LOGIC;
           fsm_count_down_start : out STD_LOGIC;
           fsm_stop_watch_start : out STD_LOGIC;
           fsm_alarm_wait : out STD_LOGIC;
           fsm_switch_on_wait : out STD_LOGIC;
           fsm_siwtch_off_wait : out STD_LOGIC);
end GlobalFSM;

architecture Behavioral of GlobalFSM is
TYPE state IS (time_display, date_display, alarm, switch_on, switch_off,
               switch_off_2, countdown, stopwatch,
               wait_alarm,wait_siwtch_on,wait_switch_off);
signal reg_state, nx_state : state;
signal t : unsigned(5 downto 0) := (others => '0');

signal n_fsm_time_start, 
       n_fsm_alarm_start, 
       n_fsm_date_start, 
       n_fsm_switch_on_start , 
       n_fsm_switch_off_start,
       n_fsm_stop_watch_start, 
       n_fsm_count_down_start, 
       n_fsm_alarm_wait ,
       n_fsm_switch_on_wait,
       n_fsm_siwtch_off_wait : std_logic;
begin

   -- Timer 
   timer : process(clk,reset)
   begin
     if reset = '1' then 
         t <= "000000";
     elsif clk'EVENT and clk = '1' then
         if reg_state /= nx_state then
             t <= "000000";
         elsif reg_state = date_display then
             t <= t + "000001";
         end if;      
     end if;
   end process timer;
-- This is combinational of the sequential design, 
-- which contains the logic for next-state
-- include all signals and input in sensitive-list except state_next
   state_change : process (key_mode_imp, key_action_imp,key_plus_imp, key_minus_imp, key_enable, reg_state,t)
   begin
      CASE reg_state IS 
         WHEN time_display => 
             if key_mode_imp = '1' then
                nx_state <= date_display;
             elsif (key_minus_imp = '1') OR (key_minus_imp ='1') then 
                nx_state <= stopwatch;
             else
                nx_state <= time_display;
             end if;   
         WHEN date_display =>    
             -- "000011" stands for 3 seconds 
             if (key_mode_imp = '1') and (t < "000011")then
                 nx_state <= alarm;
             elsif t = "000011" then
                 nx_state <= time_display;
             end if;
         when alarm => 
             if (key_action_imp or key_plus_imp or key_minus_imp = '1') then
                 nx_state <= wait_alarm;
             elsif key_mode_imp = '1' then 
                 nx_state <= switch_on;
             else 
                 nx_state <= alarm;
             end if;
         when switch_on=> 
             if key_action_imp = '1' then
                 nx_state <= wait_siwtch_on;
             elsif key_mode_imp = '1' then
                 nx_state <= switch_off;
             else 
                 nx_state <= switch_on;
             end if;
         when switch_off=> 
             if key_action_imp = '1' then 
                 nx_state <= wait_switch_off;
             elsif key_mode_imp = '1' then
                 nx_state <= countdown; 
             end if;
         when switch_off_2 => 
             if key_action_imp = '1' then 
                 nx_state <= wait_switch_off;
             elsif key_mode_imp = '1' then
                 nx_state <= time_display; 
             end if;
         when countdown=> 
             if key_mode_imp = '1' then
                 nx_state <= time_display;
             end if;
         when stopwatch=> 
             if key_mode_imp = '1' then 
                 nx_state <= time_display;
             end if;
         when wait_alarm=> 
             if key_mode_imp = '1' then
                 nx_state <= time_display;
             end if;
         when wait_siwtch_on=> 
             if key_mode_imp = '1' then 
                 nx_state <= switch_off;
             end if;
         when wait_switch_off=> 
             if key_mode_imp = '1' then
                 nx_state <= time_display;
             end if;
         when others => 
             reg_state <= time_display;
      end CASE;
   end process state_change;

   -- combination output logic
   -- This part contains the output of the design
   -- no if-else statement is used in this part
   -- include all signals and input in sensitive-list except state_next
   output_change : process (reg_state)
   begin 
       case reg_state is 
       when time_display => 
            fsm_time_start <= '1';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when date_display =>
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '1';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when alarm => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '1';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when wait_alarm =>
            fsm_time_start <= '0';
            fsm_alarm_start <= '1';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '1';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when switch_on => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '1';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when wait_siwtch_on => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '1';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '1';
            fsm_siwtch_off_wait <= '0';
       when switch_off => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '1';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when switch_off_2 => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '1';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when wait_switch_off => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '1';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '1';
       when countdown => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '0';
            fsm_count_down_start <= '1';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       when stopwatch => 
            fsm_time_start <= '0';
            fsm_alarm_start <= '0';
            fsm_date_start <= '0';
            fsm_switch_on_start <= '0';
            fsm_switch_off_start <= '0';
            fsm_stop_watch_start <= '1';
            fsm_count_down_start <= '0';
            fsm_alarm_wait <= '0';
            fsm_switch_on_wait <= '0';
            fsm_siwtch_off_wait <= '0';
       end case;
   end process output_change;

   -- Reset funtionality
   -- This process contains the squential part and D-FF s are included.
   State_reset : process (clk, reset)
   begin 
     if clk'EVENT and clk = '1' then
       if reset = '1' then 
         reg_state <= time_display;
       else 
          reg_state <= nx_state;
       end if;
     end if;
   end process State_reset;
   
   -- here reset all the outputs, using D-FF to delete the gliches
   Output_reset : process (clk, reset)
   begin 
     if clk'EVENT and clk = '1' then
       if reset = '1' then 
         fsm_time_start <= '1';
         fsm_alarm_start <= '0';
         fsm_date_start <= '0';
         fsm_switch_on_start <= '0';
         fsm_switch_off_start <= '0';
         fsm_stop_watch_start <= '0';
         fsm_count_down_start <= '0';
         fsm_alarm_wait <= '0';
         fsm_switch_on_wait <= '0';
         fsm_siwtch_off_wait <= '0';
       else 
         n_fsm_time_start <= fsm_time_start;
         n_fsm_alarm_start <= fsm_alarm_start;
         n_fsm_date_start <= fsm_date_start;
         n_fsm_switch_on_start <= fsm_switch_on_start;
         n_fsm_switch_off_start <= fsm_switch_off_start;
         n_fsm_stop_watch_start <= fsm_stop_watch_start;
         n_fsm_count_down_start <= fsm_count_down_start;
         n_fsm_alarm_wait <= fsm_alarm_wait;
         n_fsm_switch_on_wait <= fsm_switch_on_wait;
         n_fsm_siwtch_off_wait <= fsm_siwtch_off_wait;
       end if;
     end if;
   end process Output_reset;
  
  fsm_time_start <= n_fsm_time_start;
  fsm_alarm_start <= n_fsm_alarm_start;
  n_fsm_date_start <= n_fsm_date_start;
  fsm_switch_on_start <= n_fsm_switch_on_start;
  fsm_switch_off_start <= n_fsm_switch_off_start;
  fsm_stop_watch_start <= n_fsm_stop_watch_start;
  fsm_count_down_start <= n_fsm_count_down_start;
  fsm_alarm_wait <= n_fsm_alarm_wait;
  fsm_switch_on_wait <= n_fsm_switch_on_wait;
  fsm_siwtch_off_wait <= n_fsm_siwtch_off_wait;
  
  
end Behavioral;
