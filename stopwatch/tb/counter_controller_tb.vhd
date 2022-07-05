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
      Port ( 
            clk : in STD_LOGIC;
         --   sw_ena : in STD_LOGIC;
             sw_reset : in STD_LOGIC;
             key_action_imp : in STD_LOGIC;
             counter_ena : out STD_LOGIC);
  end component;

  signal clk: STD_LOGIC;
  --signal sw_ena: STD_LOGIC;
  signal sw_reset: STD_LOGIC;
  signal key_action_imp: STD_LOGIC;
  signal counter_ena: STD_LOGIC;


begin

  uut: counter_controller port map ( 
                                     clk         =>  clk,
                                   --  sw_ena            => sw_ena,
                                     sw_reset             => sw_reset,
                                     key_action_imp    => key_action_imp,
                                     counter_ena       => counter_ena );
                                     
    process				 
    begin
    clk <= '0';			-- clock cycle is 10 ns
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
    end process;

  stimulus: process
  begin
  
    -- Put initialisation code here
  --  sw_ena <= '1';
    sw_reset <= '0';
    key_action_imp <= '0';

    wait for 20 ns;
    
    --start counting
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
    --stop counting
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
     wait for 40 ns;
    
    -- start counting
     key_action_imp <= '1';
     wait for 10 ns;
     key_action_imp <= '0';
     wait for 40 ns;
     
     
    -- reset  
    sw_reset <= '1';
    wait for 10 ns;
    sw_reset <= '0';
     wait for 40 ns;

        --start counting
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
    --stop counting
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
     wait for 40 ns;
    
    -- start counting
     key_action_imp <= '1';
     wait for 10 ns;
     key_action_imp <= '0';
     wait for 40 ns;
     


    -- Put test bench stimulus code here

    wait;
  end process;


end;