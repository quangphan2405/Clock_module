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
--              ---------------    ----------------    ---------------
--  Input   ->  | BCD_decoder | -> |  STORE_DATA  |    |  SEND_FIFO  |
--              ---------------    ----------------    ---------------
--                                                            |
--                                                            V
--                                    ---------------    ----------
--                  Output_to_LCD  <- | Transmitter | <- |  FIFO  |
--                                    ---------------    ----------
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
end entity display;

architecture behavior of display is

    -- ***********************************
    -- Type declarations
    -- ***********************************
    -- State type declaration
    type state_t is (INIT, TURN_ON_DISPLAY, FUNCTION_SET, SEND_DATA, IDLE);
    type store_t is (STORE_INIT, STORE_TIME, STORE_DATE, STORE_ALARM, STORE_SWITCH_ON, STORE_SWITCH_OFF, STORE_TIMER, STORE_STW);

    -- Data to FIFO (address + data) type declaration
    constant MAX_FIFO_CNT_c : integer := 100; -- Max: 100 cycles of 10 kHz clock equals 1 cycle of 100 Hz clock
    type data_fifo_array_t is array (0 to MAX_FIFO_CNT_c-1) of std_logic_vector(10 downto 0);
    type cmd_fifo_array_t is array (0 to 2) of std_logic_vector(10 downto 0);

    -- Encoding type declaration
    type encode_array2_t  is array (0 to 1) of std_logic_vector(7 downto 0);
    type encode_array3_t  is array (0 to 2) of std_logic_vector(7 downto 0);
    type encode_array4_t  is array (0 to 3) of std_logic_vector(7 downto 0);
    type encode_array5_t  is array (0 to 4) of std_logic_vector(7 downto 0);
    type encode_array6_t  is array (0 to 5) of std_logic_vector(7 downto 0);
    type encode_array8_t  is array (0 to 7) of std_logic_vector(7 downto 0);
    type encode_array10_t is array (0 to 9) of std_logic_vector(7 downto 0);
    type encode_array11_t is array (0 to 10) of std_logic_vector(7 downto 0);
    type encode_array13_t is array (0 to 12) of std_logic_vector(7 downto 0);
    type DOW_encode_array_t is array (0 to 6) of encode_array2_t;

    -- ***********************************
    -- Static words / characters
    -- ***********************************
    -- Special characters -> (*, :, ., ' ')
    constant STAR_ENCODE_c      : std_logic_vector(7 downto 0) := "00101010";
    constant SEMICOLON_ENCODE_c : std_logic_vector(7 downto 0) := "00111010";
    constant DOT_ENCODE_c       : std_logic_vector(7 downto 0) := "10100101";
    constant BLANK_ENCODE_c     : std_logic_vector(7 downto 0) := "10001100";
    constant LETTER_A_ENCODE_c  : std_logic_vector(7 downto 0) := "01000001";
    constant LETTER_S_ENCODE_c  : std_logic_vector(7 downto 0) := "01010011";
    constant LETTER_Z_ENCODE_c  : std_logic_vector(7 downto 0) := "01011010";

    -- Time word -> (T, i, m, e, :)
    constant TIME_ENCODE_c : encode_array5_t := ("01010100", "01101001", "01101101", "01100101", "00111010");
    constant TIME_ADDR_c   : encode_array5_t := (x"07"     , x"08"     , x"09"     , x"0A"     , x"0B"     );

    -- Alarm "A" character and under it -> (A, *, Z)         *** (1) in Manual section 2.7.1
    constant ALARM_NOTE_ENCODE_c : encode_array3_t := ("01000001", "00101010", "01011010");
    constant ALARM_NOTE_ADDR_c   : encode_array3_t := (x"40"     , x"14"     , x"14"     );

    -- Time switch "S" character and under it -> (S, *)      *** (1) in Manual section 2.7.1
    constant SWITCH_NOTE_ENCODE_c : encode_array2_t := ("01010011", "00101010");
    constant SWITCH_NOTE_ADDR_c   : encode_array2_t := (x"53"     , x"27"     );

    -- Date word -> (D, a, t, e, :)
    constant DATE_ENCODE_c : encode_array5_t := ("01000100", "01100001", "01110100", "01100101", "00111010");
    constant DATE_ADDR_c   : encode_array5_t := (x"1B"     , x"1C"     , x"1D"     , x"1E"     , x"1F"     );

    -- DCF word -> (D, C,F)                                  *** (2) in Manual section 2.7.1
    constant DCF_ENCODE_c : encode_array3_t := ("01000100", "01000011", "01000110");
    constant DCF_ADDR_c   : encode_array3_t := (x"4F"     , x"50"     , x"51"     );

    -- Alarm word -> (A, l, a, r, m, :)
    constant ALARM_ENCODE_c : encode_array6_t := ("01000001", "01101100", "01100001", "01110010", "01101101", "00111010");
    constant ALARM_ADDR_c   : encode_array6_t := (x"1A"     , x"1B"     , x"1C"     , x"1D"     , x"1E"     , x"1F"     );

    -- ON word -> (O, n, :)
    constant ON_SWITCH_ENCODE_c : encode_array3_t := ("01001111", "01101110", "00111010");
    constant ON_SWITCH_ADDR_c   : encode_array3_t := (x"08"     , x"09"     , x"0A"     );
    constant ON_TIMER_ADDR_c    : encode_array2_t := (x"63"     , x"64"     );  -- *** (3) in Manual section 2.7.1

    -- OFF word -> (O, f, f, :)
    constant OFF_SWITCH_ENCODE_c : encode_array4_t := ("01001111", "01100110", "01100110", "00111010");
    constant OFF_SWITCH_ADDR_c   : encode_array4_t := (x"1C"     , x"1D"     , x"1E"     , x"1F"     );
    constant OFF_TIMER_ADDR_c    : encode_array3_t := (x"62"     , x"63"     , x"64"     );  -- *** (3) in Manual section 2.7.1

    -- Timer word -> (T, i, m, e, r, :)
    constant TIMER_ENCODE_c : encode_array6_t := ("01010100", "01101001", "01101101", "01100101", "01110010", "00111010");
    constant TIMER_ADDR_c   : encode_array6_t := (x"1A"     , x"1B"     , x"1C"     , x"1D"     , x"1E"     , x"1F"     );

    -- Stop watch word -> (S, t, o, p, ' ', w, a, t, c, h, :)
    constant STOPWATCH_ENCODE_c : encode_array11_t := ("01010011", "01110100", "01101111", "01110000", "10001100", "01010111",
                                                       "01100001", "01110100", "01100011", "01101000", "00111010");
    constant STOPWATCH_ADDR_c   : encode_array11_t := (x"17"     , x"18"     , x"19"     , x"1A"     , x"1B"     , x"1C"     ,
                                                       x"1D"     , x"1E"     , x"1F"     , x"20"     , x"21"     );

    -- Lap word -> (L, a, p)                                 *** (4) in Manual section 2.7.1
    constant LAP_ENCODE_c : encode_array3_t := ("01001100", "01100001", "01110000");
    constant LAP_ADDR_c   : encode_array3_t := (x"54"     , x"55"     , x"56"     );

    -- Date of week -> (M, o) / (D, i) / (M, i) / (D, o) / (F, r) / (S, a) / (S, u)
    constant MO_ENCODE_c  : encode_array2_t    := ("01001101", "01101111");
    constant DI_ENCODE_c  : encode_array2_t    := ("01000100", "01101001");
    constant MI_ENCODE_c  : encode_array2_t    := ("01001101", "01101001");
    constant DO_ENCODE_c  : encode_array2_t    := ("01000100", "01101111");
    constant FR_ENCODE_c  : encode_array2_t    := ("01000110", "01110010");
    constant SA_ENCODE_c  : encode_array2_t    := ("01010011", "01100001");
    constant SU_ENCODE_c  : encode_array2_t    := ("01010011", "01101111");
    constant DOW_ENCODE_c : DOW_encode_array_t := (MO_ENCODE_c, DI_ENCODE_c, MI_ENCODE_c, DO_ENCODE_c,
                                                   FR_ENCODE_c, SA_ENCODE_c, SU_ENCODE_c);
    constant DOW_ADDR_c   : encode_array2_t    := (x"58"     , x"59"     );

    -- Digits from 0 to 9
    constant DIGIT_ENCODE_c : encode_array10_t := ("00110000", "00110001", "00110010", "00110011", "00110100",
                                                   "00110101", "00110110", "00110111", "00111000", "00111001");

    -- ***********************************
    -- Dynamic data / characters address
    -- ***********************************
    constant TIME_DATA_ADDR_c      : encode_array6_t := (x"4C", x"4B", x"49", x"48", x"46", x"45");
    constant DATE_DATA_ADDR_c      : encode_array6_t := (x"63", x"62", x"60", x"5F", x"5D", x"5C");
    constant ALARM_DATA_ADDR_c     : encode_array4_t := (x"5F", x"5E", x"5C", x"5B");
    constant SWITCHON_DATA_ADDR_c  : encode_array6_t := (x"4C", x"4B", x"49", x"48", x"46", x"45");
    constant SWITCHOFF_DATA_ADDR_c : encode_array6_t := (x"60", x"5F", x"5D", x"5C", x"5A", x"59");
    constant TIMER_DATA_ADDR_c     : encode_array6_t := (x"60", x"5F", x"5D", x"5C", x"5A", x"59");
    constant STOPWATCH_DATA_ADDR_c : encode_array8_t := (x"62", x"61", x"5F", x"5E", x"5C", x"5B", x"59", x"58");

    -- ***********************************
    -- Perimeters address
    -- ***********************************
    constant TIME_PERIMETER_ADDR_c      : encode_array2_t := (x"47", x"4A");
    constant DATE_PERIMETER_ADDR_c      : encode_array2_t := (x"5E", x"61");
    constant ALARM_PERIMETER_ADDR_c     : std_logic_vector(7 downto 0) := x"5D";
    constant SWITCHOFF_PERIMETER_ADDR_c : encode_array2_t := (x"5B", x"5E");
    constant STOPWATCH_PERIMETER_ADDR_c : encode_array3_t := (x"5A", x"5D", x"60");

    -- ***********************************
    -- Clear-up word address
    -- ***********************************
    constant TIME_CLEAR_WORD_ADDR_c : encode_array11_t := STOPWATCH_ENCODE_c;
    constant SWON_CLEAR_WORD_ADDR_c : encode_array4_t := (x"07", x"0B", x"1A", x"1B");

    -- ***********************************
    -- Clear-up data address
    -- ***********************************
    constant TIME_CLEAR_DATA_ADDR_c  : encode_array13_t := (x"64", x"63", x"62", x"61", x"60", x"5F", x"5E",
                                                            x"5D", x"5C", x"5B", x"5A", x"59", x"58");
    constant ALARM_CLEAR_DATA_ADDR_c : encode_array6_t  := (x"63", x"62", x"61", x"60", x"59", x"58");

    -- ***********************************
    -- Clear-up symbol address
    -- ***********************************
    constant TIME_CLEAR_SYM_ADDR_c      : encode_array3_t := LAP_ADDR_c;
    constant SWITCHOFF_CLEAR_SYM_ADDR_c : std_logic_vector(7 downto 0) := x"43";
    constant TIMER_CLEAR_SYM_ADDR_c     : std_logic_vector(7 downto 0) := x"58";
    constant STOPWATCH_CLEAR_SYM_ADDR_c : encode_array2_t := (x"64", x"63");

    -- ***********************************
    -- Special symbol address
    -- ***********************************
    constant SWITCH_STAR_ADDR_c      : encode_array2_t := (x"43", x"58");
    constant ALARM_INDICATOR_ADDR_c  : encode_array2_t := (x"40", x"14");
    constant SWITCH_INDICATOR_ADDR_c : encode_array2_t := (x"53", x"27");

    -- ***********************************
    -- Special commands for LCD
    -- ***********************************
    constant CMD_SET_ADDR_PREFIX_c   : std_logic_vector(3 downto 0)  := "1001";
    constant CMD_WRITE_DATA_PREFIX_c : std_logic_vector(2 downto 0)  := "110";
    constant CMD_TURN_ON_DISPLAY_c   : std_logic_vector(10 downto 0) := "10000001100";
    constant CMD_FUNCTION_SET_c      : std_logic_vector(10 downto 0) := "10000111000";
    constant CMD_SEND_ZERO_c         : std_logic_vector(10 downto 0) := "00000000000";

    -- ***********************************
    -- Internal registers
    -- ***********************************
    -- STORE_DATA -> SEND_FIFO
    signal data_fifo_array_r : data_fifo_array_t := (others => (others => '0'));
    signal data_fifo_cnt_r   : integer range 0 to MAX_FIFO_CNT_c-1 := 0;
    -- SEND_FIFO -> FIFO
    signal data_fifo_index_r : integer range 0 to MAX_FIFO_CNT_c-1 := 0;
    -- Output to LCD
    signal lcd_en_r       : std_logic := '0';
    signal lcd_rw_r       : std_logic := '0';
    signal lcd_rs_r       : std_logic := '0';
    signal lcd_data_r     : std_logic_vector(7 downto 0) := (others => '0');
    -- State register for SEND_FIFO process
    signal state_r        : state_t := INIT;
    -- Debug signal for knowing the storing state
    signal store_r        : store_t := STORE_INIT;

    -- ***********************************
    -- Internal signal
    -- ***********************************
    -- Padded inputs
    signal padded_time_data_s  : std_logic_vector(27 downto 0);
    signal padded_date_data_s  : std_logic_vector(27 downto 0);
    signal padded_alarm_data_s : std_logic_vector(27 downto 0);
    signal padded_swon_data_s  : std_logic_vector(27 downto 0);
    signal padded_swoff_data_s : std_logic_vector(27 downto 0);
    signal padded_timer_data_s : std_logic_vector(27 downto 0);
    signal padded_stw_data_s   : std_logic_vector(27 downto 0);
    -- BCD-decoded input
    signal BCD_decoded_time_data_s  : std_logic_vector(31 downto 0);
    signal BCD_decoded_date_data_s  : std_logic_vector(31 downto 0);
    signal BCD_decoded_alarm_data_s : std_logic_vector(31 downto 0);
    signal BCD_decoded_swon_data_s  : std_logic_vector(31 downto 0);
    signal BCD_decoded_swoff_data_s : std_logic_vector(31 downto 0);
    signal BCD_decoded_timer_data_s : std_logic_vector(31 downto 0);
    signal BCD_decoded_stw_data_s   : std_logic_vector(31 downto 0);

    -- FIFO signals
    signal fifo_wr_en         : std_logic;
    signal fifo_rd_en         : std_logic;
    signal fifo_full          : std_logic;
    signal fifo_empty         : std_logic;
    signal fifo_wr_data       : std_logic_vector(10 downto 0);
    signal fifo_rd_data       : std_logic_vector(10 downto 0);
    signal fifo_rd_data_ready : std_logic;

    -- Component declarations
    -- BCD decoder
    component BCD_decoder_28bit
    port (
        bin28_in  : in  std_logic_vector(27 downto 0);
        bcd32_out : out std_logic_vector(31 downto 0)
    );
    end component BCD_decoder_28bit;

    -- FIFO
    component fifo
    generic (
        WIDTH_g : integer := 11;
        DEPTH_g : integer := 50
    );
    port (
        -- Clock and reset
        clk           : in  std_logic;
        reset         : in  std_logic;
        -- FIFO write interface
        wr_en         : in  std_logic;
        wr_data       : in  std_logic_vector(WIDTH_g-1 downto 0);
        full          : out std_logic;
        -- FIFO read interface
        rd_en         : in  std_logic;
        rd_data       : out std_logic_vector(WIDTH_g-1 downto 0);
        rd_data_ready : out std_logic;
        empty         : out std_logic
    );
    end component fifo;

    -- Transmitter
    component transmitter
    port (
        -- Clock and reset
        clk           : in  std_logic;
        reset         : in  std_logic;
        -- Data in
        data_in       : in  std_logic_vector(10 downto 0);
        data_in_ready : in  std_logic;
        -- Output to LCD
        lcd_en        : out std_logic;
        lcd_rw        : out std_logic;
        lcd_rs        : out std_logic;
        lcd_data      : out std_logic_vector(7 downto 0);
        -- Acknowledge
        lcd_ack       : out std_logic
    );
    end component transmitter;

    -- ***********************************
    -- Procedure for encoding to LCD
    -- ***********************************
    -- For each digit (0 -> 9) to LCD character
    procedure digitEncode (
        variable digit_in  : in  std_logic_vector(3 downto 0);
        variable digit_out : out std_logic_vector(7 downto 0)
    ) is
    begin
        digit_out := DIGIT_ENCODE_c(to_integer(unsigned(digit_in)));
    end procedure digitEncode;

    -- For whole BCD-decoded input data to LCD character
    procedure dataInputEncode (
        signal   data_in  : in  std_logic_vector(31 downto 0);
        variable data_out : out encode_array8_t
    ) is
        variable data_in_v : std_logic_vector(31 downto 0);
        variable digit_v : std_logic_vector(7 downto 0);
    begin
        data_in_v := data_in;
        DATA_ENCODE : for i in 0 to 7 loop
            digitEncode(data_in_v(4*i+3 downto 4*i), digit_v);
            data_out(i) := digit_v;
        end loop DATA_ENCODE;
    end procedure dataInputEncode;

begin

    -- ***********************************
    -- Output assignments
    -- ***********************************
    lcd_en      <= lcd_en_r;
    -- lcd_rw      <= '0';          -- Tied to 0
    lcd_rw      <= lcd_rw_r;
    lcd_rs      <= lcd_rs_r;
    lcd_data    <= lcd_data_r;

    -- ***********************************
    -- Concurrent assignments
    -- ***********************************
    -- Zero padded inputs
    padded_time_data_s  <= "0000000" & lcd_time_data;
    padded_date_data_s  <= "0000000" & lcd_date_data;
    padded_alarm_data_s <= "00000000000000" & lcd_alarm_data;
    padded_swon_data_s  <= "0000000" & lcd_switchon_data;
    padded_swoff_data_s <= "0000000" & lcd_switchoff_data;
    padded_timer_data_s <= "0000000" & lcd_countdown_data;
    padded_stw_data_s   <= lcd_stopwatch_data;

    -- BCD decoder
    BCD_28bit_time_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_time_data_s,
        bcd32_out => BCD_decoded_time_data_s
    );

    BCD_28bit_date_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_date_data_s,
        bcd32_out => BCD_decoded_date_data_s
    );

    BCD_28bit_alarm_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_alarm_data_s,
        bcd32_out => BCD_decoded_alarm_data_s
    );

    BCD_28bit_swon_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_swon_data_s,
        bcd32_out => BCD_decoded_swon_data_s
    );

    BCD_28bit_swoff_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_swoff_data_s,
        bcd32_out => BCD_decoded_swoff_data_s
    );

    BCD_28bit_timer_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_timer_data_s,
        bcd32_out => BCD_decoded_timer_data_s
    );

    BCD_28bit_stw_i : BCD_decoder_28bit
    port map (
        bin28_in  => padded_stw_data_s,
        bcd32_out => BCD_decoded_stw_data_s
    );

    -- FIFO
    fifo_i : fifo
    generic map (
        WIDTH_g => 11,
        DEPTH_g => MAX_FIFO_CNT_c
    )
    port map (
        -- Clock and reset
        clk           => clk,
        reset         => reset,
        -- FIFO write interface
        wr_en         => fifo_wr_en,
        wr_data       => fifo_wr_data,
        full          => fifo_full,
        -- FIFO read interface
        rd_en         => fifo_rd_en,
        rd_data       => fifo_rd_data,
        rd_data_ready => fifo_rd_data_ready,
        empty         => fifo_empty
    );

    -- Transmitter
    trans_i : transmitter
    port map (
        -- Clock and reset
        clk           => clk,
        reset         => reset,
        -- Data in
        data_in       => fifo_rd_data,
        data_in_ready => fifo_rd_data_ready,
        -- Output to LCD
        lcd_en        => lcd_en_r,
        lcd_rw        => lcd_rw_r,
        lcd_rs        => lcd_rs_r,
        lcd_data      => lcd_data_r,
        -- Acknowledge for transmission
        lcd_ack       => fifo_rd_en  -- ACK for next data to be read from FIFO
    );

    -- Processes
    -- STORE_DATA: Update the data from other modules with the lowest period
    --             (every 1/100 second from the stopwatch) -> Additional 100 Hz clk
    STORE_DATA : process (en_100) is
        variable data_line2_v : encode_array8_t;
        variable data_line4_v : encode_array8_t;
        variable dow_cnt_v    : integer range 0 to 8;
        variable data_cnt_v   : integer range 0 to MAX_FIFO_CNT_c;
        variable fifo_array_v : data_fifo_array_t;
        variable store_v      : store_t;
    begin
        if ( en_100'EVENT and en_100 = '1' ) then  -- Sync to 100 Hz clock rising edge
            if ( reset = '1' ) then
                -- Global registers
                data_fifo_cnt_r   <= 0;
                data_fifo_array_r <= (others => (others => '0'));
                -- Local variables
                dow_cnt_v         := 0;
                data_cnt_v        := 0;
                data_line2_v      := (others => (others => '0'));
                data_line4_v      := (others => (others => '0'));
                fifo_array_v      := (others => (others => '0'));
                store_v           := STORE_INIT;
            else
                -- *******************************
                -- Reset storage every 1/100 Hz
                -- *******************************
                -- Reset data counter
                data_cnt_v := 0;

                -- Reset the data_array and assign later on
                fifo_array_v := (others => (others => '0'));


                -- *******************************
                -- Always-on display
                -- *******************************
                -- *** Send alarm indicator ***
                -- Send letter A
                fifo_array_v(data_cnt_v)     := CMD_SET_ADDR_PREFIX_c & ALARM_INDICATOR_ADDR_c(0)(6 downto 0);
                fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & LETTER_A_ENCODE_c;
                -- Send indicative letter if present
                fifo_array_v(data_cnt_v + 2) := CMD_SET_ADDR_PREFIX_c & ALARM_INDICATOR_ADDR_c(1)(6 downto 0);
                if ( lcd_alarm_act = '1' ) then
                    fifo_array_v(data_cnt_v + 3) := CMD_WRITE_DATA_PREFIX_c & STAR_ENCODE_c;
                elsif ( lcd_alarm_snooze = '1' ) then
                    fifo_array_v(data_cnt_v + 3) := CMD_WRITE_DATA_PREFIX_c & LETTER_Z_ENCODE_c;
                else
                    fifo_array_v(data_cnt_v + 3) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                end if;
                data_cnt_v := data_cnt_v + 2*2;

                -- *** Send switch indicator ***
                -- Send letter S
                fifo_array_v(data_cnt_v)     := CMD_SET_ADDR_PREFIX_c & SWITCH_INDICATOR_ADDR_c(0)(6 downto 0);
                fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & LETTER_S_ENCODE_c;
                -- Send indicative letter if present
                fifo_array_v(data_cnt_v + 2) := CMD_SET_ADDR_PREFIX_c & SWITCH_INDICATOR_ADDR_c(1)(6 downto 0);
                if ( lcd_switchon_act = '1' or lcd_switchoff_act = '1' ) then
                    fifo_array_v(data_cnt_v + 3) := CMD_WRITE_DATA_PREFIX_c & STAR_ENCODE_c;
                else
                    fifo_array_v(data_cnt_v + 3) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                end if;
                data_cnt_v := data_cnt_v + 2*2;

                -- *** Send "DCF" ***
                SEND_DCF_WORD : for i in 0 to 2 loop
                    fifo_array_v(data_cnt_v + 2*i) := CMD_SET_ADDR_PREFIX_c & DCF_ADDR_c(i)(6 downto 0);
                    if ( lcd_time_act = '1' ) then
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & DCF_ENCODE_c(i);
                    else
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end if;
                end loop SEND_DCF_WORD;
                data_cnt_v := data_cnt_v + 2*3;


                -- *******************************
                -- State display
                -- *******************************
                -- Store data to be sent to fifo
                if ( fsm_time_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_TIME;

                    -- Get time data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_time_data_s, data_line2_v);

                    -- Line 1: "Time:" word
                    SEND_TIME_WORD_T_M : for i in 0 to 4 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & TIME_ENCODE_c(i);
                    end loop SEND_TIME_WORD_T_M;
                    data_cnt_v := data_cnt_v + 2*5;

                    -- Line 2: Actual time data
                    SEND_TIME_DATA_T_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_TIME_DATA_T_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 2: Send perimeters ":" for TIME data
                    SEND_PERIMETER_T_M: for i in 0 to 1 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_PERIMETER_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & SEMICOLON_ENCODE_c;
                    end loop SEND_PERIMETER_T_M;
                    data_cnt_v := data_cnt_v + 2*2;

                    -- TIME state can be driven from DATE, ALARM, SWITCHOFF, COUNTDOWN and STOPWATCH
                    -- Therefore, clean up any fields left from all possible previous state
                    -- Line 3: Clear "Stop Watch:" word (longest and covers all cases)
                    CLEAR_WORD_T_M : for i in 0 to 10 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_CLEAR_WORD_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end loop CLEAR_WORD_T_M;
                    data_cnt_v := data_cnt_v + 2*11;

                    -- Line 4: Clear basically STOPWATCH data line 4 + 2 more on the right due to TIMER off
                    CLEAR_DATA_T_M : for i in 0 to 12 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_CLEAR_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end loop CLEAR_DATA_T_M;
                    data_cnt_v := data_cnt_v + 2*13;

                    -- Line 4: Clear "Lap" from STOPWATCH state
                    CLEAR_SYM_T_M : for i in 0 to 2 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_CLEAR_SYM_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end loop CLEAR_SYM_T_M;
                    data_cnt_v := data_cnt_v + 6;

                elsif ( fsm_date_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_DATE;

                    -- Get time data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_time_data_s, data_line2_v);

                    -- Get date data input encoded to LCD characters - DD/MM/YY
                    dataInputEncode(BCD_decoded_date_data_s, data_line4_v);

                    -- Line 1: "Time:" word
                    SEND_TIME_WORD_D_M : for i in 0 to 4 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & TIME_ENCODE_c(i);
                    end loop SEND_TIME_WORD_D_M;
                    data_cnt_v := data_cnt_v + 2*5;

                    -- Line 2: Actual time data
                    SEND_TIME_DATA_D_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_TIME_DATA_D_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 3: "Date:" word
                    SEND_DATE_WORD_D_M : for i in 0 to 4 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & DATE_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & DATE_ENCODE_c(i);
                    end loop SEND_DATE_WORD_D_M;
                    data_cnt_v := data_cnt_v + 2*5;

                    -- Line 4: Actual date data
                    SEND_DATE_DATA_D_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & DATE_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line4_v(i);
                    end loop SEND_DATE_DATA_D_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 4: "DOW" word
                    dow_cnt_v := to_integer(unsigned(lcd_date_dow)) - 1; -- -1 since index starts from 1 to 7
                    SEND_DOW_WORD_D_M : for i in 0 to 1 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & DOW_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & DOW_ENCODE_c(dow_cnt_v)(i);
                    end loop SEND_DOW_WORD_D_M;
                    data_cnt_v := data_cnt_v + 2*2;

                    -- Line 2: Perimeter for TIME data was sent from TIME state

                    -- Line 4: Send perimeters "." for DATE data
                    SEND_PERIMETER_D_M: for i in 0 to 1 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & DATE_PERIMETER_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & DOT_ENCODE_c;
                    end loop SEND_PERIMETER_D_M;
                    data_cnt_v := data_cnt_v + 2*2;

                    -- No need to clear as we are sending more characters than TIME state

                elsif ( fsm_alarm_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_ALARM;

                    -- Get time data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_time_data_s, data_line2_v);

                    -- Get alarm data input encoded to LCD characters - hh/mm
                    dataInputEncode(BCD_decoded_alarm_data_s, data_line4_v);

                    -- Line 1: "Time:" word
                    SEND_TIME_WORD_A_M : for i in 0 to 4 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & TIME_ENCODE_c(i);
                    end loop SEND_TIME_WORD_A_M;
                    data_cnt_v := data_cnt_v + 2*5;

                    -- Line 2: Actual time data
                    SEND_TIME_DATA_A_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_TIME_DATA_A_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 3: "Alarm:" word
                    SEND_ALARM_WORD_A_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & ALARM_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & ALARM_ENCODE_c(i);
                    end loop SEND_ALARM_WORD_A_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 4: Actual alarm data
                    SEND_ALARM_DATA_A_M : for i in 0 to 3 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & ALARM_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line4_v(i);
                    end loop SEND_ALARM_DATA_A_M;
                    data_cnt_v := data_cnt_v + 2*4;

                    -- Line 2: Perimeter for TIME data was sent from TIME state

                    -- Line 4: Send perimeters "." for ALARM data
                    fifo_array_v(data_cnt_v + 0) := CMD_SET_ADDR_PREFIX_c   & ALARM_PERIMETER_ADDR_c(6 downto 0);
                    fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & SEMICOLON_ENCODE_c;
                    data_cnt_v := data_cnt_v + 2*1;

                    -- ALARM state can only be reached from DATE state, where the English words are written more
                    -- Therefore only clear extra data characters from DATE state
                    CLEAR_DATA_A_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & ALARM_CLEAR_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end loop CLEAR_DATA_A_M;
                    data_cnt_v := data_cnt_v + 2*6;

                elsif ( fsm_switchon_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_SWITCH_ON;

                    -- Get switchon data input encoded to LCD characters  - hh/mm/ss
                    dataInputEncode(BCD_decoded_swon_data_s, data_line2_v);

                    -- Get switchoff data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_swoff_data_s, data_line4_v);

                    -- Line 1: "On:" word
                    SEND_SWON_WORD_SWON_M : for i in 0 to 2 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & ON_SWITCH_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & ON_SWITCH_ENCODE_c(i);
                    end loop SEND_SWON_WORD_SWON_M;
                    data_cnt_v := data_cnt_v + 2*3;

                    -- Line 2: Actual switch-on data
                    SEND_SW_ON_DATA_SWON_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & SWITCHON_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_SW_ON_DATA_SWON_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 3: "Off:" word
                    SEND_SWOFF_WORD_SWON_M : for i in 0 to 3 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & OFF_SWITCH_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & OFF_SWITCH_ENCODE_c(i);
                    end loop SEND_SWOFF_WORD_SWON_M;
                    data_cnt_v := data_cnt_v + 2*4;

                    -- Line 4: Actual switch-off data
                    SEND_SW_OFF_DATA_SWON_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & SWITCHOFF_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line4_v(i);
                    end loop SEND_SW_OFF_DATA_SWON_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 2: Send STAR symbol
                    fifo_array_v(data_cnt_v)     := CMD_SET_ADDR_PREFIX_c   & SWITCH_STAR_ADDR_c(0)(6 downto 0);
                    fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & STAR_ENCODE_c;
                    data_cnt_v := data_cnt_v + 2*1;

                    -- Line 2: Perimeter for SWITCHON data was sent from TIME state

                    -- Line 4: Send perimeters "." for SWITCHOFF data
                    SEND_PERIMETER_SWON_M: for i in 0 to 1 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & SWITCHOFF_PERIMETER_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & SEMICOLON_ENCODE_c;
                    end loop SEND_PERIMETER_SWON_M;
                    data_cnt_v := data_cnt_v + 2*2;

                    -- Less English characters are written in SWITCHON state compared to ALARM
                    -- Therefore clear extra data characters from ALARM state
                    CLEAR_WORD_SWON_M : for i in 0 to 3 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & SWON_CLEAR_WORD_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end loop CLEAR_WORD_SWON_M;
                    data_cnt_v := data_cnt_v + 2*4;

                elsif ( fsm_switchoff_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_SWITCH_OFF;

                    -- Get switchon data input encoded to LCD characters  - hh/mm/ss
                    dataInputEncode(BCD_decoded_swon_data_s, data_line2_v);

                    -- Get switchoff data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_swoff_data_s, data_line4_v);

                    -- Line 1: "On:" word
                    SEND_SWON_WORD_SWOFF_M : for i in 0 to 2 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & ON_SWITCH_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & ON_SWITCH_ENCODE_c(i);
                    end loop SEND_SWON_WORD_SWOFF_M;
                    data_cnt_v := data_cnt_v + 2*3;

                    -- Line 2: Actual switch-on data
                    SEND_SW_ON_DATA_SWOFF_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & SWITCHON_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_SW_ON_DATA_SWOFF_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 3: "Off:" word
                    SEND_SWOFF_WORD_SWOFF_M : for i in 0 to 3 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & OFF_SWITCH_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & OFF_SWITCH_ENCODE_c(i);
                    end loop SEND_SWOFF_WORD_SWOFF_M;
                    data_cnt_v := data_cnt_v + 2*4;

                    -- Line 4: Actual switch-off data
                    SEND_SW_OFF_DATA_SWOFF_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & SWITCHOFF_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line4_v(i);
                    end loop SEND_SW_OFF_DATA_SWOFF_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 4: Send STAR symbol
                    fifo_array_v(data_cnt_v)     := CMD_SET_ADDR_PREFIX_c   & SWITCH_STAR_ADDR_c(1)(6 downto 0);
                    fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & STAR_ENCODE_c;
                    data_cnt_v := data_cnt_v + 2*1;

                    -- Line 2: Perimeter for SWITCHON data was sent from TIME state

                    -- Line 4: Perimeter for SWITCHOFF data was sent from SWITCHON state

                    -- Line 2: Clear STAR symbol from SWITCHON state
                    fifo_array_v(data_cnt_v + 0) := CMD_SET_ADDR_PREFIX_c   & SWITCHOFF_CLEAR_SYM_ADDR_c(6 downto 0);
                    fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    data_cnt_v := data_cnt_v + 2*1;

                elsif ( fsm_countdown_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_TIMER;

                    -- Get time data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_time_data_s, data_line2_v);

                    -- Get countdown timer data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_timer_data_s, data_line4_v);

                    -- Line 1: "Time:" word
                    SEND_TIME_WORD_TM_M : for i in 0 to 4 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & TIME_ENCODE_c(i);
                    end loop SEND_TIME_WORD_TM_M;
                    data_cnt_v := data_cnt_v + 2*5;

                    -- Line 2: Actual time data
                    SEND_TIME_DATA_TM_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIME_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_TIME_DATA_TM_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 3: "Timer:" word
                    SEND_ALARM_WORD_TM_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIMER_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & TIMER_ENCODE_c(i);
                    end loop SEND_ALARM_WORD_TM_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 4: Actual timer data
                    SEND_TIMER_DATA_TM_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & TIMER_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line4_v(i);
                    end loop SEND_TIMER_DATA_TM_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 2: Perimeter for TIME data was sent from TIME state

                    -- Line 4: Perimeter for TIMER data was sent from SWITCHON state

                    -- Line 4: Clear STAR symbol from SWITCHOFF state
                    fifo_array_v(data_cnt_v + 0) := CMD_SET_ADDR_PREFIX_c   & TIMER_CLEAR_SYM_ADDR_c(6 downto 0);
                    fifo_array_v(data_cnt_v + 1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    data_cnt_v := data_cnt_v + 2*1;

                elsif ( fsm_stopwatch_start = '1' ) then

                    -- Report the type of data to be stored
                    store_v := STORE_STW;

                    -- Get time data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_time_data_s, data_line2_v);

                    -- Get stopwatch data input encoded to LCD characters - hh/mm/ss
                    dataInputEncode(BCD_decoded_stw_data_s, data_line4_v);

                    -- Line 1: "Time:" word
                    SEND_TIME_WORD_STW_M : for i in 0 to 4 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c & TIME_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & TIME_ENCODE_c(i);
                    end loop SEND_TIME_WORD_STW_M;
                    data_cnt_v := data_cnt_v + 2*5;

                    -- Line 2: Actual time data
                    SEND_TIME_DATA_STW_M : for i in 0 to 5 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c & TIME_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line2_v(i);
                    end loop SEND_TIME_DATA_STW_M;
                    data_cnt_v := data_cnt_v + 2*6;

                    -- Line 3: "Stop Watch:" word
                    SEND_STW_WORD_STW_M : for i in 0 to 10 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c & STOPWATCH_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & STOPWATCH_ENCODE_c(i);
                    end loop SEND_STW_WORD_STW_M;
                    data_cnt_v := data_cnt_v + 2*11;

                    -- Line 4: Actual stopwatch data
                    SEND_STW_DATA_STW_M : for i in 0 to 7 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c & STOPWATCH_DATA_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & data_line4_v(i);
                    end loop SEND_STW_DATA_STW_M;
                    data_cnt_v := data_cnt_v + 2*8;

                    -- Line 4: Send LAP word
                    SEND_LAP_WORD_STW_M : for i in 0 to 2 loop
                        fifo_array_v(data_cnt_v + 2*i) := CMD_SET_ADDR_PREFIX_c & LAP_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & LAP_ENCODE_c(i);
                    end loop SEND_LAP_WORD_STW_M;
                    data_cnt_v := data_cnt_v + 2*3;

                    -- Line 2: Perimeter for TIME data was sent from TIME state

                    -- Line 4: Send perimeters "." for STOPWATCH data
                    SEND_PERIMETER_STW_M: for i in 0 to 2 loop
                        fifo_array_v(data_cnt_v + 2*i) := CMD_SET_ADDR_PREFIX_c   & STOPWATCH_PERIMETER_ADDR_c(i)(6 downto 0);
                        if ( i /= 2 ) then
                            fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & SEMICOLON_ENCODE_c;
                        else
                            fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & DOT_ENCODE_c;
                        end if;
                    end loop SEND_PERIMETER_STW_M;
                    data_cnt_v := data_cnt_v + 2*3;

                    -- Line 4: Clear extra characters from "On" / "Off" word from TIMER state
                    CLEAR_DATA_STW_M : for i in 0 to 1 loop
                        fifo_array_v(data_cnt_v + 2*i)   := CMD_SET_ADDR_PREFIX_c   & STOPWATCH_CLEAR_SYM_ADDR_c(i)(6 downto 0);
                        fifo_array_v(data_cnt_v + 2*i+1) := CMD_WRITE_DATA_PREFIX_c & BLANK_ENCODE_c;
                    end loop CLEAR_DATA_STW_M;
                    data_cnt_v := data_cnt_v + 2*2;

                end if;


                -- *******************************
                -- Retrieve global data & count
                -- *******************************
                -- Get data & count to global variable
                data_fifo_cnt_r   <= data_cnt_v;
                data_fifo_array_r <= fifo_array_v;
                store_r           <= store_v;       -- debug purposes

            end if;
        end if;
    end process STORE_DATA;

    -- SEND_FIFO: FSM to send data to FIFO with the fastest clock (10 kHz)
    SEND_FIFO : process(clk) is
    begin
        if ( clk'EVENT and clk = '1' ) then
            if ( reset = '1' ) then
                state_r           <= INIT;
                fifo_wr_en        <= '0';
                fifo_wr_data      <= (others => '0');
                data_fifo_index_r <= 0;
            else
                case state_r is
                    when INIT =>
                        -- FIXME: Wake up from TIME mode?
                        if ( fsm_time_start = '1' ) then
                            state_r <= TURN_ON_DISPLAY;
                        else
                            state_r <= INIT;
                        end if;
                    when TURN_ON_DISPLAY =>
                        fifo_wr_en   <= '1';
                        fifo_wr_data <= CMD_TURN_ON_DISPLAY_c;
                        state_r      <= FUNCTION_SET;
                    when FUNCTION_SET =>
                        fifo_wr_en   <= '1';
                        fifo_wr_data <= CMD_FUNCTION_SET_c;
                        state_r      <= SEND_DATA;
                    when SEND_DATA =>
                        if ( data_fifo_index_r < data_fifo_cnt_r ) then
                            fifo_wr_en        <= '1';
                            fifo_wr_data      <= data_fifo_array_r(data_fifo_index_r);
                            data_fifo_index_r <= data_fifo_index_r + 1;
                            state_r           <= SEND_DATA;
                        else
                            fifo_wr_en        <= '0';
                            state_r           <= IDLE;
                        end if;
                    when IDLE =>
                        if ( en_100 = '1' ) then
                            data_fifo_index_r <= 0;
                            state_r <= SEND_DATA;
                        else
                            state_r <= IDLE;
                        end if;
                    when others =>
                        state_r <= INIT;
                end case;
            end if;
        end if;
    end process SEND_FIFO;

end architecture behavior;