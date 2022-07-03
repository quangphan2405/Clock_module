--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 27/06/2022
-- Project Name : Project Lab IC Design
-- Module Name  : display.vhd
-- Description  : Display module of the CLOCK
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                     DISPLAY CONTROLLER DIAGRAM
--
--           -----------------    ---------------    ----------------
--  Input -> | DATA_SELECTOR | -> | BCD_encoder | -> | DATA_PROCESS |
--           -----------------    ---------------    ----------------
--                                                           |
--                                                           V
--                                ---------------    ----------------
--              Output_to_LCD  <- | Transmitter | <- |     FIFO     |
--                                ---------------    ----------------
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
    port (
        -- Clock and reset
        clk                 : in  std_logic;
        reset               : in  std_logic;
        en_100              : in  std_logic;
        -- Time
        fsm_time_start      : in  std_logic;
        lcd_time_act        : in  std_logic;
        lcd_time_data       : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Date
        fsm_date_start      : in  std_logic;
        lcd_date_dow        : in  std_logic_vector(2  downto 0);
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
end entity display;

architecture behavior of display is

    -- ***********************************
    -- Type declarations
    -- ***********************************
    -- State type declaration
    type state_t is (INIT, SEND_INIT, SEND_TIME, SEND_DATE, SEND_ALARM, SEND_SWITCHON, SEND_SWITCHOFF, SEND_TIMER, SEND_STOPWATCH, SEND_DATA);

    -- Encoding type declaration
    type encode_array2_t  is array (0 to 1) of std_logic_vector(7 downto 0);
    type encode_array3_t  is array (0 to 2) of std_logic_vector(7 downto 0);
    type encode_array4_t  is array (0 to 3) of std_logic_vector(7 downto 0);
    type encode_array5_t  is array (0 to 4) of std_logic_vector(7 downto 0);
    type encode_array6_t  is array (0 to 5) of std_logic_vector(7 downto 0);
    type encode_array8_t  is array (0 to 7) of std_logic_vector(7 downto 0);
    type encode_array10_t is array (0 to 9) of std_logic_vector(7 downto 0);
    type DOW_encode_array_t is array (0 to 6) of encode_array2_t;

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
    constant ON_encode_c      : encode_array3_t := ("01001111", "01101110", "00111010");
    constant ON_SWITCH_addr_c : encode_array3_t := (x"08"     , x"09"     , x"0A"     );

    -- OFF word -> (O, f, f, :)
    constant OFF_encode_c      : encode_array4_t := ("01001111", "01100110", "01100110", "00111010");
    constant OFF_SWITCH_addr_c : encode_array4_t := (x"1C"     , x"1D"     , x"1E"     , x"1F"     );
    constant OFF_TIMER_addr_c  : encode_array4_t := (x"62"     , x"63"     , x"64"     , x"FF"     );  -- *** (3) in Manual section 2.7.1

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
    constant MO_encode_c  : encode_array2_t    := ("01001101", "01101111");
    constant DI_encode_c  : encode_array2_t    := ("01000100", "01101001");
    constant MI_encode_c  : encode_array2_t    := ("01001101", "01101001");
    constant DO_encode_c  : encode_array2_t    := ("01000100", "01101111");
    constant FR_encode_c  : encode_array2_t    := ("01000110", "01110010");
    constant SA_encode_c  : encode_array2_t    := ("01010011", "01100001");
    constant SU_encode_c  : encode_array2_t    := ("01010011", "01101111");
    constant DOW_encode_c : DOW_encode_array_t := (MO_encode_c, DI_encode_c, MI_encode_c, DO_encode_c,
                                                   FR_encode_c, SA_encode_c, SU_encode_c);
    constant DOW_addr_c   : encode_array2_t    := (x"58"     , x"59"     );

    -- Digits from 0 to 9
    constant DIGIT_encode_c : encode_array10_t := ("00110000", "00110001", "00110010", "00110011", "00110100",
                                                   "00110101", "00110110", "00110111", "00111000", "00111001");

    -- Special characters -> (*, :, .)
    constant SPECIAL_encode_c : encode_array3_t := ("00101010", "00111010", "10100101");
    constant STAR_encode_c      : std_logic_vector(7 downto 0) := "00101010";
    constant SEMICOLON_encode_c : std_logic_vector(7 downto 0) := "00111010";
    constant DOT_encode_c       : std_logic_vector(7 downto 0) := "10100101";

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

    -- ***********************************
    -- Special commands for LCD
    -- ***********************************
    constant TURN_ON_DISPLAY_c : std_logic_vector(10 downto 0) := "10000001100";
    constant FUNCTION_SET_c    : std_logic_vector(10 downto 0) := "10000111000";

    -- Internal registers
    -- DATA_PROCESS -> FIFO
    signal data_to_fifo_r : std_logic_vector(31 downto 0);
    -- Output to LCD
    signal lcd_en_r       : std_logic;
    signal lcd_rw_r       : std_logic;
    signal lcd_rs_r       : std_logic;
    signal lcd_data_r     : std_logic_vector(7 downto 0);
    signal state_r     : mode_t;
    signal send_done_r : std_logic;
    signal cnt_r       : integer range 0 to 100;
    signal lcd_data_out_r : std_logic_vector(10 downto 0);

    -- Internal signals
    -- Data selector -> BCD decoder
    signal lcd_process_data_s : std_logic_vector(27 downto 0);
    -- BCD decoder -> DATA_PROCESS
    signal lcd_decoded_data_s : std_logic_vector(31 downto 0);
    -- signal mode_s      : std_logic_vector(6 downto 0);
    -- signal next_mode_s : mode_t;
    signal data_to_send : std_logic_vector(10 downto 0);

    -- FIFO signals
    signal fifo_wr_en   : std_logic;
    signal fifo_rd_en   : std_logic;
    signal fifo_full    : std_logic;
    signal fifo_empty   : std_logic;
    signal fifo_wr_data : std_logic_vector(10 downto 0);
    signal fifo_rd_data : std_logic_vector(10 downto 0);

    -- Component declarations
    -- Data selector
    component data_selector
    port (
        - Time
        fsm_time_start      : in  std_logic;
        lcd_time_data       : in  std_logic_vector(20 downto 0);  -- hh/mm/ss
        -- Date
        fsm_date_start      : in  std_logic;
        lcd_date_data       : in  std_logic_vector(23 downto 0);  -- DOW/YY/MM/DD
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
    end component data_selector;

    -- BCD decoder
    component BCD_decoder_28bit
    port (
        bin28_in  : in  std_logic_vector(27 downto 0);
        bcd32_out : out std_logic_vector(32 downto 0)
    );
    end component BCD_decoder_28bit;

    -- FIFO
    component fifo
    generic (
        WIDTH_g : integer := 11;
        DEPTH_g : integer := 50;
    );
    port (
        -- Clock and reset
        clk    : in  std_logic;
        reset  : in  std_logic;
        -- FIFO wrire interface
        wr_en   : in  std_logic;
        wr_data : in  std_logic_vector(WIDTH_g-1 downto 0);
        full    : out std_logic;
        -- FIFO read interface
        rd_en   : in  std_logic;
        rd_data : out std_logic_vector(WIDTH_g-1 downto 0);
        empty   : out std_logic
    );
    end component fifo;

    -- Transmitter
    component transmitter
    port (
        -- Clock and reset
        clk      : in  std_logic;
        reset    : in  std_logic;
        en_freq  : in  std_logic;
        -- Data in
        data_in  : in  std_logic_vector(10 downto 0);
        -- Output to LCD
        lcd_en   : out std_logic;
        lcd_rw   : out std_logic;
        lcd_rs   : out std_logic;
        lcd_data : out std_logic_vector(7 downto 0);
        -- Acknowledge
        lcd_ack  : out std_logic
    );
    end component transmitter;

    -- ***********************************
    -- Procedure for encoding to LCD
    -- ***********************************
    -- For each digit (0 -> 9) to LCD character
    procedure digitEncode (
        signal digit_in  : in  std_logic_vector(3 downto 0);
        signal digit_out : out std_logic_vector(7 downto 0)
    ) is
    begin
        digit_out <= DIGIT_encode_c(to_integer(unsigned(digit_in)));
    end procedure digitEncode;

    -- For DOW to German short terms
    procedure dowEncode (
        signal dow_in  : in  std_logic_vector(2 downto 0);
        signal dow_out : out encode_array_t
    ) is
    begin
        dow_out <= DOW_encode_c( to_integer(unsigned(dow_in)) - 1 ); -- Since MO <-> 1 and SU <-> 7, 0 is not used
    end procedure dowEncode;

    -- For whole BCD-decoded input data to LCD character
    procedure dataInputEncode (
        signal data_in  : in  std_logic_vector(31 downto 0);
        signal data_out : out encode_array8_t
    ) is
        variable digit : std_logic_vector(7 downto 0);
    begin
        DATA_ENCODE : for i in 0 to 7 loop
            digit := digitEncode(data_in(4*i+3 downto 4*i))
            data_out(i) <= digit;
        end loop DATA_ENCODE;
    end procedure dataInputEncode;

begin

        -- Output assignments
        lcd_en      <= lcd_en_r;
        lcd_rw      <= lcd_rw_r;
        lcd_rs      <= lcd_rs_r;
        lcd_data    <= lcd_data_r;

        -- Component instantiations
        -- Data selector
        data_selector_i : data_selector
        port map (
            -- Time
            fsm_time_start      => fsm_time_start,
            lcd_time_data       => lcd_time_data,
            -- Date
            fsm_date_start      => fsm_date_start,
            lcd_date_data       => (lcd_date_dow & lcd_date_data),
            -- Alarm
            fsm_alarm_start     => fsm_alarm_start,
            lcd_alarm_data      => lcd_alarm_data,
            -- Switch ON
            fsm_switchon_start  => fsm_switchon_start,
            lcd_switchon_data   => lcd_switchon_data,
            -- Switch ON
            fsm_switchoff_start => fsm_switchoff_start,
            lcd_switchoff_data  => lcd_switchoff_data,
            -- Countdown
            fsm_countdown_start => fsm_countdown_start,
            fsm_countdown_data  => fsm_countdown_data,
            -- Stopwatch
            fsm_stopwatch_start => fsm_stopwatch_start,
            lcd_stopwatch_data  => lcd_stopwatch_data,
            -- Output data
            lcd_process_data    => lcd_process_data_s
        );

        -- BCD decoder
        BCD_28bit_i : BCD_decoder_28bit
        port map (
            bin28_in  => lcd_process_data_s,
            bcd32_out => lcd_decoded_data_s
        );

        -- FIFO
        fifo_i : fifo
        generic (
            WIDTH_g => 11,
            DEPTH_g => 50
        );
        port (
            -- Clock and reset
            clk     => clk,
            reset   => reset,
            -- FIFO write interface
            wr_en   => fifo_wr_en,
            wr_data => fifo_wr_data,
            full    => fifo_full,
            -- FIFO read interface
            rd_en   => fifo_rd_en,
            rd_data => fifo_rd_data,
            empty   => fifo_empty
        );

        -- Transmitter
        trans_i : transmitter
        port map (
            -- Clock and reset
            clk      => clk,
            reset    => reset,
            en_freq  => en_freq,
            -- Data in
            data_in  => fifo_rd_data,
            -- Output to LCD
            lcd_en   => lcd_en_r,
            lcd_rw   => lcd_rw_r,
            lcd_rs   => lcd_rs_r,
            lcd_data => lcd_data_r,
            -- Acknowledge for transmission
            lcd_ack  => fifo_rd_en  -- ACK for next data to be read from FIFO
        );

        -- Processes
        PROCESS_DATA : process (clk) is
        begin
            if ( clk'EVENT and clk = '1' ) then
                if ( reset = '1' ) then
                    data_to_fifo_r <= (others => '0');
                else
                    -- Send data to fifo
                    if ( fsm_time_start = '1' ) then
                        fifo_wr_en <= '1';
                        
                    elsif ( fsm_date_start = '1' ) then
                    elsif ( fsm_alarm_start = '1' ) then
                    elsif ( fsm_switchon_start = '1' ) then
                    elsif ( fsm_switchoff_start = '1' ) then
                    elsif ( fsm_countdown_start = '1' ) then
                    elsif ( fsm_stopwatch_start = '1' ) then
                    end if;
                end if;
            end if;
        end process PROCESS_DATA;

        SEND_DYNAMIC : process (clk) is
        begin
            if ( clk'EVENT and clk = '1' and en_freq = '1' ) then
                if ( reset = '1' ) then
                    data_r      <= (others => '0');
                    lcd_en_r    <= '0';
                    lcd_rw_r    <= '0';              -- Tied to '0' as we are only writing to LCD
                    lcd_rs_r    <= '0';
                    lcd_data_r  <= (others => '0');
                    curr_mode_r <= TIME_M;
                    send_static_done_r <= '0';
                -- elsif ( send_static_done = '1' ) then
                end if;
            end if;
        end process SEND_DYNAMIC;

end architecture behavior;