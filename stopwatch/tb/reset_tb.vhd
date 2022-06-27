-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity reset_tb is
end;

architecture bench of reset_tb is

  component reset
      Port (
             sys_reset : in STD_LOGIC;
             key_plus_imp : in STD_LOGIC;
             sw_reset : out STD_LOGIC);
  end component;

  signal sys_reset: STD_LOGIC;
  signal key_plus_imp: STD_LOGIC;
  signal sw_reset: STD_LOGIC;

begin

  uut: reset port map ( sys_reset    => sys_reset,
                        key_plus_imp => key_plus_imp,
                        sw_reset     => sw_reset );

  stimulus: process
  begin
  
    -- Put initialisation code here
        sys_reset <= '0';
        key_plus_imp <= '0';
        wait for 10 ns; -- what is out clockperiod
        
        sys_reset <= '0';
        key_plus_imp <= '1';
        wait for 10 ns; 
        sys_reset <= '1';
        key_plus_imp <= '0';
        wait for 10 ns; 
        sys_reset <= '1';
        key_plus_imp <= '1';
        wait for 10 ns; 
        sys_reset <= '0';
        key_plus_imp <= '0';
    -- Put test bench stimulus code here

    wait;
  end process;


end;