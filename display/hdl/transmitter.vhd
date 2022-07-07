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
    generic (
        MIN_INTERVAL_g : integer := 1 -- Minimum interval between two transmission
    );
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
        -- Acknowledge for transmission
        lcd_ack       : out std_logic
    );
end entity transmitter;

architecture behavior of transmitter is

    -- Zero command
    constant CMD_ALL_ZEROS_c : std_logic_vector(10 downto 0) := "00000000000";
    -- Internal registers / signals
    signal lcd_ack_r  : std_logic;
    signal data_out_r : std_logic_vector(10 downto 0);
    signal counter_r  : integer range 0 to MIN_INTERVAL_g;

begin

    -- Output assignments
    lcd_en   <= data_out_r(10);
    lcd_rw   <= data_out_r(9);
    lcd_rs   <= data_out_r(8);
    lcd_data <= data_out_r(7 downto 0);
    lcd_ack  <= lcd_ack_r;

    -- Process
    SEND : process (clk) is
    begin
        if ( clk'EVENT and clk = '1') then
            if ( reset = '1' ) then
                lcd_ack_r  <= '0';
                data_out_r <= (others => '0');
                counter_r  <= 0;  -- Ready to send at the beginning
            else
                if ( counter_r = MIN_INTERVAL_g-1 ) then
                    if ( data_in_ready = '1' ) then
                        data_out_r <= data_in;
                    else
                        data_out_r <= CMD_ALL_ZEROS_c; -- Disregard fail-synchronized command
                    end if;
                    lcd_ack_r  <= '1';
                    counter_r  <= 0;
                else
                    lcd_ack_r  <= '0';
                    counter_r  <= counter_r + 1;
                end if;
            end if;
        end if;
    end process SEND;

end architecture behavior;