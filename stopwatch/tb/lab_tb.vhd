-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity lap_tb is
end;

architecture bench of lap_tb is

  component lap
      Port ( sw_ena : in STD_LOGIC;
             counter_ena : in STD_LOGIC;
             key_minus_imp : in STD_LOGIC;
             transmitter_ena : out STD_LOGIC);
  end component;

  signal sw_ena: STD_LOGIC;
  signal counter_ena: STD_LOGIC;
  signal key_minus_imp: STD_LOGIC;
  signal transmitter_ena: STD_LOGIC;

  --constant clock_period: time := 10 ns;


begin

  uut: lap port map ( sw_ena          => sw_ena,
                      counter_ena     => counter_ena,
                      key_minus_imp   => key_minus_imp,
                      transmitter_ena => transmitter_ena );

  stimulus: process
  begin
  
    -- Put initialisation code here

    sw_ena <= '0';
    counter_ena <='0';
    key_minus_imp <= '0';
   
    wait for 20 ns;
    
    sw_ena <= '1';
    counter_ena <='1';
   
    
    wait for 40 ns;
    
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    
    wait for 40 ns;
    
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    
    wait for 40 ns;
    
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    
    wait for 40 ns;
    
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    
    wait for 80 ns;
    
    sw_ena <= '1';
    counter_ena <='0';
   
    
    wait for 40 ns;
    
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    
    wait for 40 ns;
    
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';

    
    -- Put test bench stimulus code here

    wait;
  end process;


end;
  