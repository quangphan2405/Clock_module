library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCD_decoder_28bit is
    port (
        bin_in  : in  std_logic_vector(27 downto 0);
        bcd_out : out std_logic_vector(32 downto 0);
    );
end entity BCD_decoder_28bit;

architecture behavior of BCD_decoder_28bit is

    -- Component declarations
    component BCD_decoder_7bit
    port (
        bin_in  : in  std_logic_vector(6 downto 0);
        bcd_out : out std_logic_vector(7 downto 0)
    );
    end component BCD_decoder_7bit;

begin

    -- Component instantiations
    BCD_7bit_0_i : BCD_decoder_7bit
    port map (
        bin_in  => bin_in(6 downto 0),
        bcd_out => bdc_out(7 downto 0)
    );

    BCD_7bit_1_i : BCD_decoder_7bit
    port map (
        bin_in  => bin_in(13 downto 7),
        bcd_out => bdc_out(15 downto 8)
    );

    BCD_7bit_2_i : BCD_decoder_7bit
    port map (
        bin_in  => bin_in(20 downto 14),
        bcd_out => bdc_out(23 downto 16)
    );

    BCD_7bit_3_i : BCD_decoder_7bit
    port map (
        bin_in  => bin_in(27 downto 21),
        bcd_out => bdc_out(32 downto 24)
    );

end architecture behavior;