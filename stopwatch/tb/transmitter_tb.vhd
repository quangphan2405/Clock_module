-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity transmitter_tb is
end;

architecture bench of transmitter_tb is

  component transmitter
      Port ( 
               clk            : in std_logic;
              sw_ena          : in std_logic;
               sw_reset :       in std_logic;
              transmitter_ena : in STD_LOGIC;
              csec_in:	      in std_logic_vector(6 downto 0);
              sec_in:	      in std_logic_vector(6 downto 0);
              min_in:	      in std_logic_vector(6 downto 0);
              hr_in:	      in std_logic_vector(6 downto 0);
              csec:	          out std_logic_vector(6 downto 0);
              sec:	          out std_logic_vector(6 downto 0);
              min:	          out std_logic_vector(6 downto 0);
              hr:	          out std_logic_vector(6 downto 0));
  end component;

    
  signal clk: STD_LOGIC;
  signal sw_ena: STD_LOGIC;
  signal sw_reset: STD_LOGIC;
  signal transmitter_ena: STD_LOGIC;
  signal csec_in: std_logic_vector(6 downto 0);
  signal sec_in: std_logic_vector(6 downto 0);
  signal min_in: std_logic_vector(6 downto 0);
  signal hr_in: std_logic_vector(6 downto 0);
  signal csec: std_logic_vector(6 downto 0);
  signal sec: std_logic_vector(6 downto 0);
  signal min: std_logic_vector(6 downto 0);
  signal hr: std_logic_vector(6 downto 0);

begin

  uut: transmitter port map ( 
                              clk          => clk,
                              sw_ena       => sw_ena,
                              sw_reset     => sw_reset,
                              transmitter_ena => transmitter_ena,
                              csec_in         => csec_in,
                              sec_in          => sec_in,
                              min_in          => min_in,
                              hr_in           => hr_in,
                              csec            => csec,
                              sec             => sec,
                              min             => min,
                              hr              => hr );
                              
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
    sw_ena <= '1';
    sw_reset <= '0';
    transmitter_ena <= '0';
    
    csec_in         <= "0000001";
    sec_in          <= "0000001";
    min_in          <= "0000001";
    hr_in           <= "0000001";
    
    wait for 20 ns;
    
    transmitter_ena <= '1';
    wait for 40 ns;
    
    csec_in         <= "0000011";
    sec_in          <= "0000011";
    min_in          <= "0000011";
    hr_in           <= "0000011";
    wait for 40 ns;

        
    transmitter_ena <= '0';
    wait for 40 ns;
    
    csec_in         <= "0000111";
    sec_in          <= "0000111";
    min_in          <= "0000111";
    hr_in           <= "0000111";
    wait for 40 ns;
    transmitter_ena <= '1';
    wait for 40 ns;
    
    csec_in         <= "0001111";
    sec_in          <= "0001111";
    min_in          <= "0001111";
    hr_in           <= "0001111";
    wait for 20 ns;
    sw_reset <= '1';
    wait for 10 ns;
    sw_reset <= '0';

    wait for 20 ns;
    
    csec_in         <= "0011111";
    sec_in          <= "0011111";
    min_in          <= "0011111";
    hr_in           <= "0011111";

    transmitter_ena <= '1';
    wait for 40 ns;
    
        
    csec_in         <= "0111111";
    sec_in          <= "0111111";
    min_in          <= "0111111";
    hr_in           <= "0111111";


    -- Put test bench stimulus code here

    wait;
  end process;


end;