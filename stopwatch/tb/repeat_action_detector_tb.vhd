-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity repeat_action_detector_tb is
end;

architecture bench of repeat_action_detector_tb is

  component repeat_action_detector
      Port ( clk : in STD_LOGIC;
             key_action_imp : in STD_LOGIC;
             repeat_action_imp : out STD_LOGIC);
  end component;

  signal clk:     std_logic;
  signal key_action_imp: STD_LOGIC;
  signal repeat_action_imp: STD_LOGIC;


begin

  uut: repeat_action_detector port map ( clk               => clk,
                                         key_action_imp    => key_action_imp,
                                         repeat_action_imp => repeat_action_imp );

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
        key_action_imp <= '0';
        
        wait for 20 ns;
        
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;
        
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;
         
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
         wait for 60ns;
         
         
         
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;
         
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;
         
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;

        
         key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;
         
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        
        wait for 40ns;
         
        key_action_imp <= '1';
        wait for 10 ns;
        key_action_imp <= '0';
        

    -- Put test bench stimulus code here

    wait;
  end process;


end;