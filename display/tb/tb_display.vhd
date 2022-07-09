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
        lcd_time_act        : in  std_logic;                      -- DCF
        lcd_time_data       : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Date
        fsm_date_start      : in  std_logic;
        lcd_date_dow        : in  std_logic_vector(2  downto 0);
        lcd_date_data       : in  std_logic_vector(20 downto 0);  -- DD/MM/YY
        -- Alarm
        fsm_alarm_start     : in  std_logic;
        lcd_alarm_act       : in  std_logic;                      -- Letter * under A
        lcd_alarm_snooze    : in  std_logic;                      -- Letter Z under A
        lcd_alarm_data      : in  std_logic_vector(13 downto 0);  -- hh/mm
        -- Switch ON
        fsm_switchon_start  : in  std_logic;
        lcd_switchon_act    : in  std_logic;                      -- Letter * under S
        lcd_switchon_data   : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Switch OFF
        fsm_switchoff_start : in  std_logic;
        lcd_switchoff_act   : in  std_logic;                      -- Letter * under S
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
    signal clk_10k             : std_logic := '0';
    signal clk_100             : std_logic := '0';
    signal reset               : std_logic := '0';
    signal en_100              : std_logic := '0';
    -- Time
    signal fsm_time_start      : std_logic := '0';
    signal lcd_time_act        : std_logic := '0';                                  -- DCF
    signal lcd_time_data       : std_logic_vector(20 downto 0) := (others => '0');  -- hh/mm/ss
    -- Date
    signal fsm_date_start      : std_logic := '0';
    signal lcd_date_dow        : std_logic_vector(2  downto 0) := (others => '0');
    signal lcd_date_data       : std_logic_vector(20 downto 0) := (others => '0');  -- DD/MM/YY
    -- Alarm
    signal fsm_alarm_start     : std_logic := '0';
    signal lcd_alarm_act       : std_logic := '0';                                  -- Letter * under A
    signal lcd_alarm_snooze    : std_logic := '0';                                  -- Letter Z under A
    signal lcd_alarm_data      : std_logic_vector(13 downto 0) := (others => '0');  -- hh/mm
    -- Switch ON
    signal fsm_switchon_start  : std_logic := '0';
    signal lcd_switchon_act    : std_logic := '0';                                  -- Letter * under S
    signal lcd_switchon_data   : std_logic_vector(20 downto 0) := (others => '0');  -- hh/mm/ss
    -- Switch OFF
    signal fsm_switchoff_start : std_logic := '0';
    signal lcd_switchoff_act   : std_logic := '0';                                  -- Letter * under S
    signal lcd_switchoff_data  : std_logic_vector(20 downto 0) := (others => '0');  -- hh/mm/ss
    -- Countdown
    signal fsm_countdown_start : std_logic := '0';
    signal lcd_countdown_act   : std_logic := '0';
    signal lcd_countdown_data  : std_logic_vector(20 downto 0) := (others => '0');  -- hh/mm/ss
    -- Stopwatch
    signal fsm_stopwatch_start : std_logic := '0';
    signal lcd_stopwatch_act   : std_logic := '0';
    signal lcd_stopwatch_data  : std_logic_vector(27 downto 0) := (others => '0');  -- hh/mm/ss/cc

    -- *** Outputs ***
    signal lcd_en   : std_logic;
    signal lcd_rw   : std_logic;
    signal lcd_rs   : std_logic;
    signal lcd_data : std_logic_vector(7 downto 0);

    -- *** Output wrapper ***
    signal lcd_output : std_logic_vector(10 downto 0);

    -- Input data
    constant MAX_DATA_c : integer := 20;

    -- Input type declaration
    type input_dow_array_t    is array(0 to MAX_DATA_c-1) of std_logic_vector(2  downto 0);
    type input_2parts_array_t is array(0 to MAX_DATA_c-1) of std_logic_vector(13 downto 0);
    type input_3parts_array_t is array(0 to MAX_DATA_c-1) of std_logic_vector(20 downto 0);
    type input_4parts_array_t is array(0 to MAX_DATA_c-1) of std_logic_vector(27 downto 0);

    -- Output type declaration
    type output_data_array_t  is array(0 to 100) of std_logic_vector(10 downto 0);  -- For one piece of data
    type output_func_array_t  is array(0 to MAX_DATA_c-1) of output_data_array_t;   -- For one functionality

    -- Input declaration
    signal lcd_time_input_array      : input_3parts_array_t := (others => (others => '0'));
    signal lcd_date_input_array      : input_3parts_array_t := (others => (others => '0'));
    signal lcd_alarm_input_array     : input_2parts_array_t := (others => (others => '0'));
    signal lcd_switchon_input_array  : input_3parts_array_t := (others => (others => '0'));
    signal lcd_switchoff_input_array : input_3parts_array_t := (others => (others => '0'));
    signal lcd_timer_input_array     : input_3parts_array_t := (others => (others => '0'));
    signal lcd_stopwatch_input_array : input_4parts_array_t := (others => (others => '0'));
    signal lcd_dow_input_array       : input_dow_array_t    := (others => (others => '0'));

    -- Output declaration
    signal lcd_time_output_array      : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_date_output_array      : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_alarm_output_array     : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_switchon_output_array  : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_switchoff_output_array : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_timer_output_array     : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_stopwatch_output_array : output_func_array_t := (others => (others => (others => '0')));
    signal lcd_dow_output_array       : output_func_array_t := (others => (others => (others => '0')));

    -- Clock period
    constant CLK_10K_PERIOD_c : time := 100 us;
    constant CLK_100_PERIOD_c : time :=  10 ms;

    -- Special commands for LCD
    constant CMD_TURN_ON_DISPLAY_c : std_logic_vector(10 downto 0) := "10000001100";
    constant CMD_FUNCTION_SET_c    : std_logic_vector(10 downto 0) := "10000111000";

    -- Error counter
    signal error_cnt : integer := 0;

    -- Process to decode commands to LCD

begin

    -- Instantiate the Unit Under Test (UUT)
    uut : display
    port map (
        -- Clock and reset
        clk                 => clk_10k,
        reset               => reset,
        en_100              => clk_100,
        -- Time
        fsm_time_start      => fsm_time_start,
        lcd_time_act        => lcd_time_act,
        lcd_time_data       => lcd_time_data,
        -- Date
        fsm_date_start      => fsm_date_start,
        lcd_date_dow        => lcd_date_dow,
        lcd_date_data       => lcd_date_data,
        -- Alarm
        fsm_alarm_start     => fsm_alarm_start,
        lcd_alarm_act       => lcd_alarm_act,
        lcd_alarm_snooze    => lcd_alarm_snooze,
        lcd_alarm_data      => lcd_alarm_data,
        -- Switch ON
        fsm_switchon_start  => fsm_switchon_start,
        lcd_switchon_act    => lcd_switchon_act,
        lcd_switchon_data   => lcd_switchon_data,
        -- Switch ON
        fsm_switchoff_start => fsm_switchoff_start,
        lcd_switchoff_act   => lcd_switchoff_act,
        lcd_switchoff_data  => lcd_switchoff_data,
        -- Countdown
        fsm_countdown_start => fsm_countdown_start,
        lcd_countdown_act   => lcd_countdown_act,
        lcd_countdown_data  => lcd_countdown_data,
        -- Stopwatch
        fsm_stopwatch_start => fsm_stopwatch_start,
        lcd_stopwatch_act   => lcd_stopwatch_act,
        lcd_stopwatch_data  => lcd_stopwatch_data,
        -- Output to LCD
        lcd_en              => lcd_en,
        lcd_rw              => lcd_rw,
        lcd_rs              => lcd_rs,
        lcd_data            => lcd_data
    );

    -- Wrap the LCD outputs from display module
    lcd_output <= lcd_en & lcd_rw & lcd_rs & lcd_data;

    -- Clock 10 kHz generator
    CLK_10K_GEN : process
    begin
        wait for CLK_10K_PERIOD_c/2; -- 50/50 duty cycle
        clk_10k <= not clk_10k;
    end process CLK_10K_GEN;

    -- Clock 100 Hz generator
    CLK_100_GEN : process
    begin
        wait for CLK_10K_PERIOD_c/2;
        clk_100 <= '1';
        wait for CLK_10K_PERIOD_c;    -- 1/99 duty cycle, actually "en_100"
        clk_100 <= '0';
        wait for CLK_10K_PERIOD_c/2;
        wait for CLK_10K_PERIOD_c*98;
    end process CLK_100_GEN;

    -- EN_100 generator
    -- EN_GEN : process
    -- begin
    --     wait for CLK_10K_PERIOD_c/2;   -- Get clock rising edge
    --     EN_100 <= '1';
    --     wait for CLK_10K_PERIOD_c;     -- Enable for 1 clock cycle
    --     EN_100 <= '0';
    --     wait for CLK_10K_PERIOD_c/2;
    --     wait for CLK_PERIOd_c*98;  -- Enough 100 cycles
    -- end process EN_GEN;

    -- Stimulus
    STIM : process
    begin
        -- Generate input array
        INPUT_GEN : for i in 0 to MAX_DATA_c-1 loop
            lcd_time_input_array(i)      <= std_logic_vector(to_unsigned(i+1, 21)); -- Input data: 1 -> MAX_DATA_c
            lcd_date_input_array(i)      <= std_logic_vector(to_unsigned(i+1, 21));
            lcd_alarm_input_array(i)     <= std_logic_vector(to_unsigned(i+1, 14));
            lcd_switchon_input_array(i)  <= std_logic_vector(to_unsigned(i+1, 21));
            lcd_switchoff_input_array(i) <= std_logic_vector(to_unsigned(i+1, 21));
            lcd_timer_input_array(i)     <= std_logic_vector(to_unsigned(i+1, 21));
            lcd_stopwatch_input_array(i) <= std_logic_vector(to_unsigned(i+1, 28));
            -- Since 0 is not used in DOW encoding
            if ( i rem 8 /= 7 ) then
                lcd_dow_input_array(i)   <= std_logic_vector(to_unsigned(i+1,  3)); -- Auto trimming -> return back to 0
            end if;
        end loop INPUT_GEN;

        -- Generate reset
        wait for CLK_10K_PERIOD_c*2;
        reset <= '1';
        wait for CLK_10K_PERIOD_c*2;
        reset <= '0';
        wait for CLK_10K_PERIOD_c/2;

        -- Wake up the display
        fsm_time_start <= '1';
        wait for CLK_10K_PERIOD_c*3/2; -- Wait for data to transmit thru FIFO
        -- Check TURN_ON_DISPLAY command after waking up
        if ( lcd_output /= CMD_TURN_ON_DISPLAY_c ) then
            error_cnt <= error_cnt + 1;
            report "TURN_ON_DISPLAY command not received!";
        end if;
        -- Check FUNCTION_SET command in the next cycle
        wait for CLK_10K_PERIOD_c;
        if ( lcd_output /= CMD_FUNCTION_SET_c ) then
            error_cnt <= error_cnt + 1;
            report "FUNCTION_SET command not received!";
        end if;

        -- Print testbench output
        if ( error_cnt /= 0 ) then
            report "TEST FAILED! Number of unmatched results is " & integer'image(error_cnt);
        else
            report "TEST PASSED!";
        end if;

        wait;
    end process STIM;

end architecture behavior;