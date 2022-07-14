-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity reset_tb is
end;

architecture bench of reset_tb is

  component reset_control
      Port (
           --  clk : in STD_LOGIC;
           --  sw_ena : in STD_LOGIC;
             sys_reset : in STD_LOGIC;
             key_plus_imp : in STD_LOGIC;
             sw_reset : out STD_LOGIC);
  end component;

 -- signal clk: STD_LOGIC;
--  signal sw_ena: STD_LOGIC;
  signal sys_reset: STD_LOGIC;
  signal key_plus_imp: STD_LOGIC;
  signal sw_reset: STD_LOGIC;

begin

  uut: reset_control port map ( --clk  => clk,
                               -- sw_ena       => sw_ena,
                                sys_reset    => sys_reset,
                                key_plus_imp => key_plus_imp,
                                sw_reset     => sw_reset );


--  process				 
--    begin
--    clk <= '0';			-- clock cycle is 10 ns
--    wait for 5 ns;
 --   clk <= '1';
 --   wait for 5 ns;
 --   end process;
    
        
  stimulus: process
  begin
  

      
    -- Put initialisation code here
   --     sw_ena <= '0';
        sys_reset <= '0';
        key_plus_imp <= '0';
        wait for 20 ns;
        
        key_plus_imp <= '1';
        wait for 10 ns; 
        key_plus_imp <= '0';
        wait for 40 ns; 
        
        sys_reset <= '1';
        wait for 10 ns; 
        sys_reset <= '0';
        wait for 40 ns; 
        
  --      sw_ena <= '1';
     
        key_plus_imp <= '1';
        wait for 10 ns; 
        key_plus_imp <= '0';
        wait for 40 ns; 
        
        sys_reset <= '1';
        wait for 10 ns; 
        sys_reset <= '0';
        wait for 40 ns; 
                
   
    -- Put test bench stimulus code here

    wait;
  end process;


end;