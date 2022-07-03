--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 27/06/2022
-- Project Name : Project Lab IC Design
-- Module Name  : transmitter.vhd
-- Description  : Transmitter to control the output flow
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmitter is
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
        -- Acknowledge for transmission
        lcd_ack  : out std_logic
    );
end entity transmitter;

architecture behavior of transmitter is

    -- Minimum interval between two transmission
    constant MIN_INTERVAL_c : integer := 50;

    -- Internal registers / signals
    signal lcd_ack_r  : std_logic;
    signal data_out_r : std_logic_vector(10 downto 0);
    signal counter_r  : integer range 0 to MIN_INTERVAL_c;

begin

    -- Output assignments
    lcd_en   <= data_out_r(10);
    lcd_rw   <= data_out_r(9);
    lcd_rs   <= data_out_r(8);
    lcd_data <= data_out_r(7 downto 0);

    -- Process
    SEND : process (clk) is
    begin
        if ( clk'EVENT and clk = '1' and en_freq = '1' ) then
            if ( reset = '1' ) then
                lcd_ack_r  <= '0';
                data_out_r <= (others => '0');
                counter_r  <= MIN_INTERVAL_c;  -- Ready to send at the beginning
            else
                if ( counter_r == MIN_INTERVAL_c ) then
                    lcd_ack_r  <= '1';
                    data_out_r <= data_in;
                    counter_r  <= 0;
                else
                    lcd_ack_r  <= '0';
                    counter_r  <= counter_r + 1;
                end if;
            end if;
        end if;
    end process SEND;

end architecture behavior;