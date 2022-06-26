library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use common_pkg.all;

entity display is
    port (
        -- Clock and reset
        clk                 : in  std_logic;
        reset               : in  std_logic;
        en_freq             : in  std_logic;
        -- Time
        fsm_time_start      : in  std_logic;
        lcd_time_act        : in  std_logic;
        lcd_time_data       : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Date
        fsm_date_start      : in  std_logic;
        lcd_date_dow        : in  DOW_t;
        lcd_date_data       : in  std_logic_vector(20 downto 0);  -- DD/MM/YY
        -- Alarm
        fsm_alarm_start     : in  std_logic;
        lcd_alarm_act       : in  std_logic;
        lcd_alarm_snooze    : in  std_logic;
        lcd_alarm_data      : in  std_logic_vector(13 downto 0);  -- hh/mm
        -- Switch ON
        fsm_switchon_start  : in  std_logic;
        lcd_switchon_act    : in  std_logic;
        lcd_switchon_data   : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Switch OFF
        fsm_switchoff_start : in  std_logic;
        lcd_switchoff_act   : in  std_logic;
        lcd_switchoff_data  : in  std_logic_vector(20 downto 0);  -- hh/mm/ss;
        -- Countdown
        fsm_countdown_start : in  std_logic;
        lcd_countdown_act   : in  std_logic;
        lcd_countdown_data  : in  std_logic_vector(20 downto 0);  -- hh/mm/ss;
        -- Stopwatch
        fsm_stopwatch_start : in  std_logic;
        lcd_stopwatch_act   : in  std_logic;
        lcd_stopwatch_data  : in  std_logic_vector(27 downto 0);  -- hh/mm/ss/cc;
        -- Output to LCD
        lcd_en              : out std_logic;
        lcd_rw              : out std_logic;
        lcd_rs              : out std_logic;
        lcd_data            : out std_logic_vector(7 downto 0)
    );
end entity display;

architecture behavior of display is

    -- ***********************************
    -- Type declarations
    -- ***********************************
    -- MODE type declaration
    type mode_t is (TIME_M, DATE_M, ALARM_M, SWITCHON_M, SWITCHOFF_M, TIMER_M, STOPWATCH_M);

    -- Encoding type declaration
    type encode_array2_t  is array (0 to 1) of std_logic_vector(7 downto 0);
    type encode_array3_t  is array (0 to 2) of std_logic_vector(7 downto 0);
    type encode_array4_t  is array (0 to 3) of std_logic_vector(7 downto 0);
    type encode_array5_t  is array (0 to 4) of std_logic_vector(7 downto 0);
    type encode_array6_t  is array (0 to 5) of std_logic_vector(7 downto 0);
    type encode_array8_t  is array (0 to 7) of std_logic_vector(7 downto 0);
    type encode_array10_t is array (0 to 9) of std_logic_vector(7 downto 0);

    -- ***********************************
    -- Static words / characters
    -- ***********************************
    -- Time word -> (T, i, m, e, :)
    constant TIME_encode_c : encode_array5_t := ("01010100", "01101001", "01101101", "01100101", "00111010");
    constant TIME_addr_c   : encode_array5_t := (x"07"     , x"08"     , x"09"     , x"0A"     , x"0B"     );

    -- Alarm "A" character and under it -> (A, *, Z)         *** (1) in Manual section 2.7.1
    constant ALARM_NOTE_encode_c : encode_array3_t := ("01000001", "00101010", "01011010");
    constant ALARM_NOTE_addr_c   : encode_array3_t := (x"40"     , x"14"     , x"14"     );

    -- Time switch "S" character and under it -> (S, *)      *** (1) in Manual section 2.7.1
    constant SWITCH_NOTE_encode_c : encode_array2_t := ("01010011", "00101010");
    constant SWITCH_NOTE_addr_c   : encode_array2_t := (x"53"     , x"27"     );

    -- Date word -> (D, a, t, e, :)
    constant DATE_encode_c : encode_array5_t := ("01000100", "01100001", "01110100", "01100101", "00111010");
    constant DATE_addr_c   : encode_array5_t := (x"1B"     , x"1C"     , x"1D"     , x"1E"     , x"1F"     );

    -- DCF word -> (D, C,F)                                  *** (2) in Manual section 2.7.1
    constant DCF_encode_c : encode_array3_t := ("01000100", "01000011", "01000110");
    constant DCF_addr_c   : encode_array3_t := (x"4F"     , x"50"     , x"51"     );

    -- Alarm word -> (A, l, a, r, m, :)
    constant ALARM_encode_c : encode_array6_t := ("01000001", "01101100", "01100001", "01110010", "01101101", "00111010");
    constant ALARM_TIMER_addr_c : encode_array6_t := (x"1A"     , x"1B"     , x"1C"     , x"1D"     , x"1E"     , x"1F"     );

    -- ON word -> (O, n, :)
    constant ON_SWITCH_encode_c : encode_array3_t := ("01001111", "01101110", "00111010");
    constant ON_SWITCH_addr_c   : encode_array3_t := (x"08"     , x"09"     , x"0A"     );

    -- OFF word -> (O, f, f, :)
    constant OFF_SWITCH_encode_c : encode_array4_t := ("01001111", "01100110", "01100110", "00111010");
    constant OFF_SWITCH_addr_c   : encode_array4_t := (x"1C"     , x"1D"     , x"1E"     , x"1F"     );
    constant OFF_TIMER_addr_c    : encode_array4_t := (x"62"     , x"63"     , x"64"     , x"FF"     );  -- *** (3) in Manual section 2.7.1

    -- Timer word -> (T, i, m, e, r, :)
    constant TIMER_encode_c : encode_array6_t := ("01010100", "01101001", "01101101", "01100101", "01110010", "00111010");

    -- Stopwatch word -> (S, t, o, p, w, a, t, c, h, :)
    constant STOPWATCH_encode_c : encode_array10_t := ("01010011", "01110100", "01101111", "01110000", "01010111",
                                                       "01100001", "01110100", "01100011", "01101000", "00111010");
    constant STOPWATCH_addr_c   : encode_array10_t := (x"17"     , x"18"     , x"19"     , x"1A"     , x"1C"     ,
                                                       x"1D"     , x"1E"     , x"1F"     , x"20"     , x"21"     );

    -- Lap word -> (L, a, p)                                 *** (4) in Manual section 2.7.1
    constant LAP_encode_c : encode_array3_t := ("01001100", "01100001", "01110000");
    constant LAP_addr_c   : encode_array3_t := (x"54"     , x"55"     , x"56"     );

    -- Date of week -> (M, o) / (D, i) / (M, i) / (D, o) / (F, r) / (S, a) / (S, u)
    constant MO_encode_c : encode_array2_t := ("01001101", "01101111");
    constant DI_encode_c : encode_array2_t := ("01000100", "01101001");
    constant MI_encode_c : encode_array2_t := ("01001101", "01101001");
    constant DO_encode_c : encode_array2_t := ("01000100", "01101111");
    constant FR_encode_c : encode_array2_t := ("01000110", "01110010");
    constant SA_encode_c : encode_array2_t := ("01010011", "01100001");
    constant SU_encode_c : encode_array2_t := ("01010011", "01101111");
    constant DOW_addr_c  : encode_array2_t := (x"58"     , x"59"     );

    -- Digits from 0 to 9
    constant DIGIT_encode_c : encode_array10_t := ("00110000", "00110001", "00110010", "00110011", "00110100",
                                                   "00110101", "00110110", "00110111", "00111000", "00111001");

    -- Special characters -> (*, :, .)
    constant SPECIAL_encode_c : encode_array3_t := ("00101010", "00111010", "10100101")

    -- ***********************************
    -- Dynamic data / characters address
    -- ***********************************
    constant TIME_DATA_STARTING_c      : std_logic_vector(7 downto 0) := x"45";
    constant DATE_DATA_STARTING_c      : std_logic_vector(7 downto 0) := x"5C";
    constant ALARM_DATA_STARTING_c     : std_logic_vector(7 downto 0) := x"5B";
    constant SWITCHON_DATA_STARTING_c  : std_logic_vector(7 downto 0) := x"45";
    constant SWITCHOFF_DATA_STARTING_c : std_logic_vector(7 downto 0) := x"59";
    constant SWITCH_STAR_addr_c        : encode_array2_t := (x"43", x"58");
    constant TIMER_DATA_STARTING_c     : std_logic_vector(7 downto 0) := x"59";
    constant STOPWATCH_DATA_STARTING_c : std_logic_vector(7 downto 0) := x"58";

    -- Internal registers
    signal data_r      : std_logic_vector(31 downto 0);
    signal lcd_en_r    : std_logic;
    signal lcd_rw_r    : std_logic;
    signal lcd_rs_r    : std_logic;
    signal lcd_data_r  : std_logic_vector(7 downto 0);
    signal curr_mode_r : mode_t;
    signal send_static_done_r : std_logic;

    -- Internal signals
    signal data_in_s   : std_logic_vector(27 downto 0);
    signal data_out_s  : std_logic_vector(31 downto 0);
    signal mode_s      : std_logic_vector(6 downto 0);
    signal next_mode_s : mode_t;

    -- Component declarations
    -- BCD decoder
    component BCD_decoder_28bit
    port (
        bin_in  : in  std_logic_vector(27 downto 0),
        bcd_out : out std_logic_vector(32 downto 0)
    );
    end component BCD_decoder_28bit;

    -- Counter
    component counter
    generic (
        max : integer := 59;
        N   : integer := 7
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        en_freq : in  std_logic;
        cnt_out : out std_logic_vector(N-1 downto 0)
    );
    end component counter;

begin

        -- Output assignments
        lcd_en      <= lcd_en_r;
        lcd_rw      <= lcd_rw_r;
        lcd_rs      <= lcd_rs_r;
        lcd_data    <= lcd_data_r;

        -- Concurrent assignments
        mode_s  <= fsm_stopwatch_start & fsm_countdown_start & fsm_switchoff_start &
                       fsm_switchon_start & fsm_alarm_start & fsm_date_start & fsm_time_start;

        with mode_s select next_mode_s <=
            TIME_M      when "0000001",
            DATE_M      when "0000010",
            ALARM_M     when "0000100",
            SWITCHON_M  when "0001000",
            SWITCHOFF_M when "0010000",
            TIMER_M     when "0100000",
            STOPWATCH_M when "1000000",
            TIME_M      when others;

        data_in_s <= fsm_time_start      ? std_logic_vector(resize(unsigned(lcd_time_data     ), 28)) :
                     fsm_date_start      ? std_logic_vector(resize(unsigned(lcd_date_data     ), 28)) :
                     fsm_alarm_start     ? std_logic_vector(resize(unsigned(lcd_alarm_data    ), 28)) :
                     fsm_switchon_start  ? std_logic_vector(resize(unsigned(lcd_switchon_data ), 28)) :
                     fsm_switchoff_start ? std_logic_vector(resize(unsigned(lcd_switchoff_data), 28)) :
                     fsm_countdown_start ? std_logic_vector(resize(unsigned(lcd_countdown_data), 28)) :
                     fsm_stopwatch_start ? std_logic_vector(resize(unsigned(lcd_stopwatch_data), 28)) :
                     x"0000000";

        -- Component instantiations
        BCD_28bit_i : BCD_decoder_28bit
        port map (
            bin_in  => data_in_s,
            bcd_out => data_out_s
        );

        -- Processes
        SEND_STATIC : process (clk) is
        begin
            if ( clk'EVENT and clk = '1' and en_freq = '1' ) then
                if ( reset = '1' ) then
                    begin
                        data_r      <= (others => '0');
                        lcd_en_r    <= '0';
                        lcd_rw_r    <= '0';              -- Tied to '0' as we are only writing to LCD
                        lcd_rs_r    <= '0';
                        lcd_data_r  <= (others => '0');
                        curr_mode_r <= (others => '0');
                        send_static_done_r <= '0';
                    end;
                else
                    begin
                        -- Send static data
                        if ( fsm_time_start = '1' ) then
                            begin
                            end;
                        elsif ( fsm_date_start = '1' ) then
                            begin
                            end;
                        elsif ( fsm_alarm_start = '1' ) then
                            begin
                            end;
                        elsif ( fsm_switchon_start = '1' ) then
                            begin
                            end;
                        elsif ( fsm_switchoff_start = '1' ) then
                            begin
                            end;
                        elsif ( fsm_countdown_start = '1' ) then
                            begin
                            end;
                        elsif ( fsm_stopwatch_start = '1' ) then
                            begin
                            end;
                        end if;
                    end;
                end if;
            end if;
        end process SEND_STATIC;

        SEND_DYNAMIC : process (clk) is
        begin
            if ( clk'EVENT and clk = '1' and en_freq = '1' ) then
                if ( reset = '1' ) then
                    begin
                        data_r      <= (others => '0');
                        lcd_en_r    <= '0';
                        lcd_rw_r    <= '0';              -- Tied to '0' as we are only writing to LCD
                        lcd_rs_r    <= '0';
                        lcd_data_r  <= (others => '0');
                        curr_mode_r <= (others => '0');
                    end;
                elsif ( send_static_finished = '1' ) then
                    begin
                    end;
                end if;
            end if;
        end process SEND_DYNAMIC;

end architecture behavior;