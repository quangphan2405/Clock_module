----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2022 02:05:50 PM
-- Design Name: 
-- Module Name: stopwatch - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stopwatch is
    Port ( sw_ena : in STD_LOGIC;
           reset : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           clk : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           key_action_imp : in STD_LOGIC;
           cs : out STD_LOGIC_vector(6 downto 0);
           ss : out STD_LOGIC_vector(6 downto 0); 
           mm : out STD_LOGIC_vector(6 downto 0); 
           hh : out STD_LOGIC_vector(6 downto 0));
end stopwatch;

architecture Behavioral of stopwatch is

component counter_controller
    Port ( clk : in STD_LOGIC:= '0';
          --  sw_ena : in STD_LOGIC:='0';
           sw_reset : in STD_LOGIC:='0';
           key_action_imp : in STD_LOGIC:='0';
           counter_ena : out STD_LOGIC);
end component counter_controller;

component reset_control
    Port (  --clk : in STD_LOGIC;
           -- sw_ena : in STD_LOGIC;
            sys_reset : in STD_LOGIC;
           key_plus_imp : in STD_LOGIC;
           sw_reset : out STD_LOGIC);
end component reset_control;

component counter_clock
    port(	clk:	  in std_logic;
	        sw_reset:	      in std_logic;
	        count_ena:	  in std_logic;
    	    csec:	      out std_logic_vector(6 downto 0);
    	    sec:	      out std_logic_vector(6 downto 0);
    	    min:	      out std_logic_vector(6 downto 0);
    	    hr:	          out std_logic_vector(6 downto 0)
);
end component counter_clock;


component lap
    Port ( 
           clk : in STD_LOGIC;
           sw_ena : in STD_LOGIC;
           sw_reset : in STD_LOGIC;
           counter_ena : in STD_LOGIC;
           key_minus_imp : in STD_LOGIC;
           transmitter_ena : out STD_LOGIC);
end component lap;

component transmitter
    Port ( 
            clk : in STD_LOGIC;
            sw_ena : in STD_LOGIC;
            sw_reset : in STD_LOGIC;
            transmitter_ena : in STD_LOGIC;
            csec_in:	  in std_logic_vector(6 downto 0);
            sec_in:	      in std_logic_vector(6 downto 0);
            min_in:	      in std_logic_vector(6 downto 0);
            hr_in:	      in std_logic_vector(6 downto 0);
            csec:	      out std_logic_vector(6 downto 0);
            sec:	      out std_logic_vector(6 downto 0);
            min:	      out std_logic_vector(6 downto 0);
            hr:	          out std_logic_vector(6 downto 0));
end component transmitter;

signal counter_ena_signal: std_logic;
signal transmitter_ena_signal: std_logic;
signal sw_reset_signal: std_logic;
signal csec_signal : std_logic_vector(6 downto 0);
signal sec_signal: std_logic_vector(6 downto 0);
signal min_signal: std_logic_vector(6 downto 0);
signal hr_signal: std_logic_vector(6 downto 0);

begin

counter_controller_port : counter_controller port map (
          clk => clk,
         --  sw_ena => sw_ena,
           sw_reset => sw_reset_signal,
           key_action_imp => key_action_imp,
           counter_ena => counter_ena_signal);
           
reset_control_port : reset_control port map (
            --clk => clk,
           -- sw_ena => sw_ena, 
           sys_reset => reset,
           key_plus_imp => key_plus_imp,
           sw_reset => sw_reset_signal);

counter_clock_port : counter_clock port map(
	           clk => clk,
               sw_reset => sw_reset_signal,
               count_ena => counter_ena_signal,
	           csec => csec_signal,
	           sec => sec_signal,
	           min => min_signal,
	           hr => hr_signal);

lap_port : lap port map (
            clk => clk,
           sw_ena => sw_ena, 
           sw_reset => sw_reset_signal,
           counter_ena => counter_ena_signal, 
           key_minus_imp => key_minus_imp, 
           transmitter_ena => transmitter_ena_signal);
           
transmitter_port: transmitter port map( 
            clk => clk,
            sw_ena => sw_ena, 
            sw_reset => sw_reset_signal,
            transmitter_ena =>  transmitter_ena_signal,
            csec_in=> csec_signal,
            sec_in => sec_signal,
            min_in => min_signal,
            hr_in => hr_signal,
            csec => cs,
            sec => ss,
            min => mm,
            hr => hh);          
           
end Behavioral;
