--------------------------------------------------------------------------------
-- Author       : Quang Phan
-- Author email : quang.phan@tum.de
-- Create Date  : 27/06/2022
-- Project Name : Project Lab IC Design
-- Module Name  : fifo.vhd
-- Description  : FIFO to store data for serial data transmission
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
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
end entity fifo;

architecture behavior of fifo is
    -- FIFO array to store data
    type fifo_array_t is array (0 to DEPTH_g-1) of std_logic_vector(WIDTH_g-1 downto 0);

    -- Internal registers
    signal fifo_array_r : fifo_array_t;
    signal wr_ptr_r     : integer range 0 to DEPTH_g-1;
    signal rd_ptr_r     : integer range 0 to DEPTH_g-1;
    signal fifo_cnt_r   : integer range 0 to DEPTH_g+1; -- FIFO fill level

    -- Internal signals
    signal full_s     : std_logic;
    signal empty_s    : std_logic;

begin

    -- Process
    FIFO_ACT : process (clk) is
        if ( clk'EVENT and clk = '1' ) then
            if ( reset = '1' ) then
                fifo_array_r <= (others => (others => '0'));
                wr_ptr_r     <= 0;
                rd_ptr_r     <= 0;
                fifo_cnt_r   <= 0;
            else
                -- Total number of data piece in FIFO
                if ( wr_en = '1' and rd_en = '0' and full_s = '0' ) then
                    fifo_cnt_r <= fifo_cnt_r + 1;
                elsif ( wr_en = '0' and rd_en = '1' and empty_s = '0' ) then
                    fifo_cnt_r <= fifo_cnt_r - 1;
                end if;

                -- Update write index
                if ( wr_en = '1' and full_s = '0' ) then
                    if ( wr_ptr = DEPTH_g-1 ) then
                        wr_ptr <= 0;
                    else
                        wr_ptr <= wr_ptr + 1;
                    end if;
                end if;

                -- Update read pointer
                if ( rd_en = '1' and empty_s = '0' ) then
                    if ( rd_ptr = DEPTH_g-1 ) then
                        rd_ptr <= 0;
                    else
                        rd_ptr <= rd_ptr + 1;
                    end if;
                end if;

                -- Write data to fifo
                if ( wr_en ) then
                    fifo_array_r(wr_ptr) <= wr_data;
                end if;
            end if;
        end if;
    end process FIFO_ACT;

    -- Output data
    rd_data <= fifo_array_r(rd_ptr);

    -- FIFO flags
    full_s  <= '1' when fifo_cnt_r = DEPTH_g else '0';
    empty_s <= '1' when fifo_cnt_r = 0       else '0';

    -- Output flag assignments
    full  <= full_s;
    empty <= empty_s;


end architecture behavior;