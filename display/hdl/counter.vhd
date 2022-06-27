--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 27/06/2022
-- Project Name : Project Lab IC Design
-- Module Name  : counter.vhd
-- Description  : Counter for adjusting the frequency of commands to LCD
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
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
end entity counter;

architecture behavior of counter is
    signal cnt_r : integer range 0 to max;
begin
    -- Output assignment
    cnt_out <= cnt_r;

    -- Process
    COUNT : process (clk) is
    begin
        if ( clk'EVENT and clk = '1' and en_freq = '1' ) then
            if ( reset = '1' ) then
                cnt_r <= (others => '0');
            else
                if ( cnt_r < max ) then
                    cnt_r <= cnt_r + 1;
                else
                    cnt_r <= 0;
                end if;
            end if;
        end if;
    end process COUNT;
end architecture behavior;