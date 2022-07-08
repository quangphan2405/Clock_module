--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 27/06/2022
-- Project Name : Project Lab IC Design
-- Module Name  : tb_display.vhd
-- Description  : VHDL testbench for module: display
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_display is
end entity tb_display;

architecture behavior of tb_display is

    -- Component Declaration for the Unit Under Test (UUT)
    component display
    port (
        -- Clock and reset
        clk                 : in  std_logic;
        reset               : in  std_logic;
        en_100              : in  std_logic;
        -- Time
        fsm_time_start      : in  std_logic;
        lcd_time_act        : in  std_logic;  -- DCF
        lcd_time_data       : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Date
        fsm_date_start      : in  std_logic;
        lcd_date_dow        : in  std_logic_vector(2  downto 0);
        lcd_date_data       : in  std_logic_vector(20 downto 0);  -- DD/MM/YY
        -- Alarm
        fsm_alarm_start     : in  std_logic;
        lcd_alarm_act       : in  std_logic;  -- Letter * under A
        lcd_alarm_snooze    : in  std_logic;  -- Letter Z under A
        lcd_alarm_data      : in  std_logic_vector(13 downto 0);  -- hh/mm
        -- Switch ON
        fsm_switchon_start  : in  std_logic;
        lcd_switchon_act    : in  std_logic;  -- Letter * under S
        lcd_switchon_data   : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Switch OFF
        fsm_switchoff_start : in  std_logic;
        lcd_switchoff_act   : in  std_logic;  -- Letter * under S
        lcd_switchoff_data  : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Countdown
        fsm_countdown_start : in  std_logic;
        lcd_countdown_act   : in  std_logic;
        lcd_countdown_data  : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Stopwatch
        fsm_stopwatch_start : in  std_logic;
        lcd_stopwatch_act   : in  std_logic;
        lcd_stopwatch_data  : in  std_logic_vector(27 downto 0);  -- hh/mm/ss/cc
        -- Output to LCD
        lcd_en              : out std_logic;
        lcd_rw              : out std_logic;
        lcd_rs              : out std_logic;
        lcd_data            : out std_logic_vector(7 downto 0)
    );
    end component display;

    -- *** Inputs ***
    -- Clock and reset
    clk                 : std_logic;
    reset               : std_logic;
    en_100              : std_logic;
    -- Time
    fsm_time_start      : std_logic;
    lcd_time_act        : std_logic;  -- DCF
    lcd_time_data       : std_logic_vector(20 downto 0);  -- hh/mm/ss
    -- Date
    fsm_date_start      : std_logic;
    lcd_date_dow        : std_logic_vector(2  downto 0);
    lcd_date_data       : std_logic_vector(20 downto 0);  -- DD/MM/YY
    -- Alarm
    fsm_alarm_start     : std_logic;
    lcd_alarm_act       : std_logic;  -- Letter * under A
    lcd_alarm_snooze    : std_logic;  -- Letter Z under A
    lcd_alarm_data      : std_logic_vector(13 downto 0);  -- hh/mm
    -- Switch ON
    fsm_switchon_start  : std_logic;
    lcd_switchon_act    : std_logic;  -- Letter * under S
    lcd_switchon_data   : std_logic_vector(20 downto 0);  -- hh/mm/ss
    -- Switch OFF
    fsm_switchoff_start : std_logic;
    lcd_switchoff_act   : std_logic;  -- Letter * under S
    lcd_switchoff_data  : std_logic_vector(20 downto 0);  -- hh/mm/ss
    -- Countdown
    fsm_countdown_start : std_logic;
    lcd_countdown_act   : std_logic;
    lcd_countdown_data  : std_logic_vector(20 downto 0);  -- hh/mm/ss
    -- Stopwatch
    fsm_stopwatch_start : std_logic;
    lcd_stopwatch_act   : std_logic;
    lcd_stopwatch_data  : std_logic_vector(27 downto 0);  -- hh/mm/ss/cc

    -- *** Outputs ***
    lcd_en   : std_logic;
    lcd_rw   : std_logic;
    lcd_rs   : std_logic;
    lcd_data : std_logic_vector(7 downto 0);

    -- Clock period
    constant CLK_PERIOD_c : time := 100 us;

    -- Error counter
    signal error_cnt : integer := 0;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : display
    port map (
        -- Clock and reset
        clk => clk,
        reset => reset,
        en_100 => en_100,
        -- Time
        fsm_time_start => fsm_time_start,
        lcd_time_act => lcd_time_act,
        lcd_time_data => lcd_time_data,
        -- Date
        fsm_date_start => fsm_date_start,
        lcd_date_dow   => lcd_date_dow,
        lcd_date_data  => lcd_date_date,
        -- Alarm
        fsm_alarm_start => fsm_alarm_start,
        lcd_alarm_act   => lcd_alarm_act,
        lcd_alarm_snooze => lcd_alarm_snooze,
        lcd_alarm_data   => lcd_alarm_data,
    )

end architecture behavior;