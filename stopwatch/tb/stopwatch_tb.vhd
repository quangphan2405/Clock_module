-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity stopwatch_tb is
end;

architecture bench of stopwatch_tb is

  component stopwatch
      Port ( sw_ena : in STD_LOGIC;
             key_minus_imp : in STD_LOGIC;
             clk : in STD_LOGIC;
             reset : in STD_LOGIC;
             key_plus_imp : in STD_LOGIC;
             key_action_imp : in STD_LOGIC;
             cs : out STD_LOGIC_vector(6 downto 0);
             ss : out STD_LOGIC_vector(6 downto 0); 
             mm : out STD_LOGIC_vector(6 downto 0); 
             hh : out STD_LOGIC_vector(6 downto 0));
  end component;

  signal sw_ena: STD_LOGIC;
  signal key_minus_imp: STD_LOGIC;
  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal key_plus_imp: STD_LOGIC;
  signal key_action_imp: STD_LOGIC;
  signal cs: STD_LOGIC_vector(6 downto 0);
  signal ss: STD_LOGIC_vector(6 downto 0);
  signal mm: STD_LOGIC_vector(6 downto 0);
  signal hh: STD_LOGIC_vector(6 downto 0);

begin

  uut: stopwatch port map ( sw_ena         => sw_ena,
                            key_minus_imp  => key_minus_imp,
                            clk            => clk,
                            reset          => reset,
                            key_plus_imp   => key_plus_imp,
                            key_action_imp => key_action_imp,
                            cs             => cs,
                            ss             => ss,
                            mm             => mm,
                            hh             => hh );
                            
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
  
    --initialization values
    sw_ena <= '1';
    key_minus_imp <= '0';
    key_plus_imp <= '0';
    key_action_imp <= '0';
    reset <= '0';
    wait for 20 ns;
    
    --start counting
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
   -- start lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;

    
    --stop lapping 
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    wait for 40 ns;
    
    --pause 
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;   
    
        --resume
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
    --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;

    reset <= '1';
    wait for 10 ns;
    reset <= '0'; 
    wait for 40 ns;
    
    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns; 
    
    -- start lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;
    
     --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns; 
    
    -- start lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;
    
    --pause
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns; 
    
    -- stop lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;

    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;

     --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
        --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
    
    
     --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
    --------------------------------------------------------------------------------------------------------------------------------------------------------
        --start counting
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
   -- start lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;

    
    --stop lapping 
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';
    wait for 40 ns;
    
    --pause 
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;   
    
        --resume
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
    --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;

    reset <= '1';
    wait for 10 ns;
    reset <= '0'; 
    wait for 40 ns;
    
    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns; 
    
    -- start lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;
    
     --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns; 
    
    -- start lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;
    
    --pause
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns; 
    
    -- stop lapping
    key_minus_imp <= '1';
    wait for 10 ns;
    key_minus_imp <= '0';    
    wait for 40 ns;

    --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;

     --reset
    key_plus_imp <= '1';
    wait for 10 ns;
    key_plus_imp <= '0';
    wait for 40 ns;
    
        --run
    key_action_imp <= '1';
    wait for 10 ns;
    key_action_imp <= '0';
    wait for 40 ns;
    
    
    
    -- Put test bench stimulus code here

    wait;
  end process;


end;
  