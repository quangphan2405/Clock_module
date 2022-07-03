--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 27/06/2022
-- Project Name : Project Lab IC Design
-- Module Name  : data_selector.vhd
-- Description  : Select the data to manipulate based on START signal from FSM
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_selector is
    port (
        -- Time
        fsm_time_start      : in  std_logic;
        lcd_time_data       : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Date
        fsm_date_start      : in  std_logic;
        lcd_date_data       : in  std_logic_vector(20 downto 0);  -- YY/MM/DD, DOW is handled separately
        -- Alarm
        fsm_alarm_start     : in  std_logic;
        lcd_alarm_data      : in  std_logic_vector(13 downto 0);  -- hh/mm
        -- Switch ON
        fsm_switchon_start  : in  std_logic;
        lcd_switchon_data   : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Switch OFF
        fsm_switchoff_start : in  std_logic;
        lcd_switchoff_data  : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Countdown
        fsm_countdown_start : in  std_logic;
        lcd_countdown_data  : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Stopwatch
        fsm_stopwatch_start : in  std_logic;
        lcd_stopwatch_data  : in  std_logic_vector(27 downto 0);  -- hh/mm/ss/cc
        -- Output data
        lcd_process_data    : out std_logic_vector(27 downto 0)
    );
end entity data_selector;

architecture behavior of data_selector is
    -- Internal signals
    signal fsm_mode_s         : std_logic_vector(6 downto 0) := (others => '0');
begin
    -- Concurrent assignment
    fsm_mode_s  <= fsm_stopwatch_start & fsm_countdown_start & fsm_switchoff_start &
                   fsm_switchon_start & fsm_alarm_start & fsm_date_start & fsm_time_start;

    -- Process
    DATA_SELECT : process (fsm_mode_s) is
    begin
        SET_DATA: case fsm_mode_s is
            when "0000001" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_time_data     ), 28));
            when "0000010" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_date_data     ), 28));
            when "0000100" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_alarm_data    ), 28));
            when "0001000" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_switchon_data ), 28));
            when "0010000" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_switchoff_data), 28));
            when "0100000" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_countdown_data), 28));
            when "1000000" => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_stopwatch_data), 28));
            when others    => lcd_process_data <= std_logic_vector(resize(unsigned(lcd_time_data     ), 28));
        end case SET_DATA;
    end process DATA_SELECT;
end architecture behavior;