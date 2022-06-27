-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity counter_controller_tb is
end;

architecture bench of counter_controller_tb is

  component counter_controller
      Port ( sw_ena : in STD_LOGIC;
             key_action_imp : in STD_LOGIC;
             repeat_action_imp : in STD_LOGIC;
             key_plus_imp : in STD_LOGIC;
             reset : in STD_LOGIC;
             counter_ena : out STD_LOGIC);
  end component;

  signal sw_ena: STD_LOGIC;
  signal key_action_imp: STD_LOGIC;
  signal repeat_action_imp: STD_LOGIC;
  signal key_plus_imp: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal counter_ena: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: counter_controller port map ( sw_ena            => sw_ena,
                                     key_action_imp    => key_action_imp,
                                     repeat_action_imp => repeat_action_imp,
                                     key_plus_imp      => key_plus_imp,
                                     reset             => reset,
                                     counter_ena       => counter_ena );

  stimulus: process
  begin
  
    -- Put initialisation code here
    sw_ena <= '1';
    reset <= '0';
    wait for 20 ns;
    
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';

    wait for 40 ns;
    
    repeat_action_imp <= '1';
    wait for 10 ns;
    repeat_action_imp <= '0';
    
    wait for 40 ns;
    
    repeat_action_imp <= '1';
    wait for 10 ns;
    repeat_action_imp <= '0';
    
    wait for 40 ns;
    
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    
    wait for 40 ns;
    
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    
     wait for 40 ns;
    
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    
    wait for 40 ns;
    
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';

     

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  --clocking: process
  --begin
  --  while not stop_the_clock loop
  --    reset <= '0', '1' after clock_period / 2;
  --    wait for clock_period;
  --  end loop;
  ---  wait;
  --end process;

end;