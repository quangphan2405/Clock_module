--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 18/07/2022
-- Project Name : Project Lab IC Design
-- Module Name  : display_standalone.vhd
-- Description  : Standalone display module of the CLOCK for testing purpose
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

entity display_standalone is
    port (
	    GCLK : in std_logic; -- Clock source running at 100.00 MHz

		BTNC : in std_logic; -- Button Center
		BTNU : in std_logic; -- Button Up
		BTND : in std_logic; -- Button Down
		BTNL : in std_logic; -- Button Left
		BTNR : in std_logic; -- Button Right
		SW : in std_logic_vector(7 downto 0); -- Switches
		LED : out std_logic_vector(7 downto 0); -- LEDs

		-- OLED_DC : out std_logic;
		-- OLED_RES : out std_logic;
		-- OLED_SCLK : out std_logic;
		-- OLED_SDIN : out std_logic;
		-- OLED_VBAT : out std_logic;
		-- OLED_VDD : out std_logic;

		LCD_E : out std_logic;
		LCD_RW : out std_logic;
		LCD_RS : out std_logic;
		LCD_DATA : out std_logic_vector(7 downto 0) -- LCD Data
	);
end entity display_standalone;

architecture behavior of display_standalone is

    -- Constant
    constant HH_MM_c       : std_logic_vector(13 downto 0) := "00100010010001"; -- 17:17
    constant HH_MM_SS_c    : std_logic_vector(20 downto 0) := "001000100100010010001"; -- 17:17:17
    constant HH_MM_SS_CS_c : std_logic_vector(27 downto 0) := "0010001001000100100010010001"; -- 17:17:17.17
    constant DD_MM_YY_c    : std_logic_vector(20 downto 0) := "001000100010100010110"; -- 17.10.22
    constant DOW_c         : std_logic_vector( 2 downto 0) := "001"; -- Mo

    -- FSM control signals
    constant fsm_time_start_c      : std_logic := '0';
    constant fsm_date_start_c      : std_logic := '0';
    constant fsm_alarm_start_c     : std_logic := '0';
    constant fsm_switchon_start_c  : std_logic := '0';
    constant fsm_switchoff_start_c : std_logic := '0';
    constant fsm_countdown_start_c : std_logic := '0';
    constant fsm_stopwatch_start_c : std_logic := '0';

    -- Clock
    signal clk : std_logic := '0'; -- Internal clock running at 10.00 kHz
	signal en_1K : std_logic := '0';
	signal en_100 : std_logic := '0';
	signal en_10 : std_logic := '0';
	signal en_1 : std_logic := '0';

    -- DCF data
	signal dcf_generated : std_logic := '0'; -- Generated DCF signal
	signal dcf : std_logic := '0'; -- Selected DCF signal

    -- LED outputs
	signal led_alarm_act : std_logic := '0';
	signal led_alarm_ring : std_logic := '0';
	signal led_countdown_act : std_logic := '0';
	signal led_countdown_ring : std_logic := '0';
	signal led_switch_act : std_logic := '0';
	signal led_switch_on : std_logic := '0';

    -- Reset signals
	signal reset : std_logic := '1';		-- Internal reset signal, high for at least 16 cycles
	signal reset_counter : std_logic_vector(3 downto 0) := (others => '0');
	signal heartbeat: std_logic := '0'; --Heartbeat signal

begin

    -- Clock generator
    clock_gen: entity work.clock_gen
    port map(
        clk => GCLK,
        clk_10K => clk,
        en_1K => en_1K,
        en_100 => en_100,
        en_10 => en_10,
        en_1 => en_1
    );

    -- DCF generator
    dcf_gen : entity work.dcf_gen
    port map(
        clk => clk,
        reset => reset,
        en_10 => en_10,
        en_1 => en_1,
        dcf => dcf_generated
    );

    -- Generate Reset signal
	reset_gen: process(clk)
	begin
		if rising_edge(clk) then
			if BTND='1' then
				reset <= '1';
				reset_counter <= (others => '0');
			elsif reset_counter=x"F" then
				reset <= '0';
			else
				reset <= '1';
				reset_counter <= reset_counter + x"1";
			end if;
		end if;
	end process;

    -- DCF MUX
	dcf_mux : process(SW, dcf_generated)
	begin
		if SW(1)='1' then
			dcf <= '0';
		else
			dcf <= dcf_generated;
		end if;
	end process;

    -- LED MUX
	led_mux : process(SW, heartbeat, dcf, led_alarm_act, led_alarm_ring, led_countdown_act, led_countdown_ring, led_switch_act, led_switch_on)
	begin
		if SW(0)='1' then
			LED <= "000000" & dcf & heartbeat;
		else
			LED <= led_alarm_act & led_alarm_ring & "0" &  led_countdown_act & led_countdown_ring & "0" & led_switch_act & led_switch_on;
		end if;
	end process;

    -- Display
    display_i : entity work.display
    port map (
        -- Clock and reset
        clk                 => clk,
        reset               => reset,
        en_100              => en_100,
        -- Time
        fsm_time_start      => fsm_time_start_c,
        lcd_time_act        => '0',
        lcd_time_data       => HH_MM_SS_c,
        -- Date
        fsm_date_start      => fsm_date_start_c,
        lcd_date_dow        => DOW_c,
        lcd_date_data       => DD_MM_YY_c,
        -- Alarm
        fsm_alarm_start     => fsm_alarm_start_c,
        lcd_alarm_act       => '0',
        lcd_alarm_snooze    => '0',
        lcd_alarm_data      => HH_MM_c,
        -- Switch ON
        fsm_switchon_start  => fsm_switchon_start_c,
        lcd_switchon_act    => '0',
        lcd_switchon_data   => HH_MM_SS_c,
        -- Switch ON
        fsm_switchoff_start => fsm_switchoff_start_c,
        lcd_switchoff_act   => '0',
        lcd_switchoff_data  => HH_MM_SS_c,
        -- Countdown
        fsm_countdown_start => fsm_countdown_start_c,
        lcd_countdown_act   => '0',
        lcd_countdown_data  => HH_MM_SS_c,
        -- Stopwatch
        fsm_stopwatch_start => fsm_stopwatch_start_c,
        lcd_stopwatch_act   => '0',
        lcd_stopwatch_data  => HH_MM_SS_CS_c,
        -- Output to LCD
        lcd_en              => LCD_E,
        lcd_rw              => LCD_RW,
        lcd_rs              => LCD_RS,
        lcd_data            => LCD_DATA
    );

end architecture behavior;
