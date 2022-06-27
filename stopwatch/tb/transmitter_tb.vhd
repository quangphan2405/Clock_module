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
      Port ( transmitter_ena : in STD_LOGIC;
              csec_in:	  in std_logic_vector(6 downto 0);
              sec_in:	      in std_logic_vector(5 downto 0);
              min_in:	      in std_logic_vector(5 downto 0);
              hr_in:	      in std_logic_vector(4 downto 0);
              csec:	      out std_logic_vector(6 downto 0);
              sec:	      out std_logic_vector(5 downto 0);
              min:	      out std_logic_vector(5 downto 0);
              hr:	          out std_logic_vector(4 downto 0));
  end component;

  signal transmitter_ena: STD_LOGIC;
  signal csec_in: std_logic_vector(6 downto 0);
  signal sec_in: std_logic_vector(5 downto 0);
  signal min_in: std_logic_vector(5 downto 0);
  signal hr_in: std_logic_vector(4 downto 0);
  signal csec: std_logic_vector(6 downto 0);
  signal sec: std_logic_vector(5 downto 0);
  signal min: std_logic_vector(5 downto 0);
  signal hr: std_logic_vector(4 downto 0);

begin

  uut: transmitter port map ( transmitter_ena => transmitter_ena,
                              csec_in         => csec_in,
                              sec_in          => sec_in,
                              min_in          => min_in,
                              hr_in           => hr_in,
                              csec            => csec,
                              sec             => sec,
                              min             => min,
                              hr              => hr );

  stimulus: process
  begin
  
    -- Put initialisation code here
    
    transmitter_ena <= '0';
    
    csec_in         <= "0000001";
    sec_in          <= "000001";
    min_in          <= "000001";
    hr_in           <= "00001";
    
    wait for 20 ns;
    
    transmitter_ena <= '1';
    wait for 40 ns;
    
    csec_in         <= "0000011";
    sec_in          <= "000011";
    min_in          <= "000011";
    hr_in           <= "00011";
    wait for 40 ns;

        
    transmitter_ena <= '0';
    wait for 40 ns;
    
    csec_in         <= "0000111";
    sec_in          <= "000111";
    min_in          <= "000111";
    hr_in           <= "00111";
    wait for 40 ns;
    transmitter_ena <= '1';
    wait for 40 ns;
    
    csec_in         <= "0000011";
    sec_in          <= "000011";
    min_in          <= "000011";
    hr_in           <= "00011";
    wait for 40 ns;

        
    transmitter_ena <= '0';
    wait for 40 ns;
    
    csec_in         <= "0000111";
    sec_in          <= "000111";
    min_in          <= "000111";
    hr_in           <= "00111";



    -- Put test bench stimulus code here

    wait;
  end process;


end;