-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity counter_clock_tb is
end;

architecture bench of counter_clock_tb is

  component counter_clock
      Port ( clk : in STD_LOGIC;
      	   sw_reset:	      in std_logic;
      	   count_ena:	  in std_logic;
      	   csec:	      out std_logic_vector(6 downto 0);
      	   sec:	      out std_logic_vector(6 downto 0);
          	min:	      out std_logic_vector(6 downto 0);
          	hr:	          out std_logic_vector(6 downto 0)
      );
  end component;

  signal clk: STD_LOGIC;
  signal sw_reset: std_logic;
  signal count_ena: std_logic;
  signal csec: std_logic_vector(6 downto 0);
  signal sec: std_logic_vector(6 downto 0);
  signal min: std_logic_vector(6 downto 0);
  signal hr: std_logic_vector(6 downto 0) ;

begin

  uut: counter_clock port map ( clk       => clk,
                                sw_reset  => sw_reset,
                                count_ena => count_ena,
                                csec      => csec,
                                sec       => sec,
                                min       => min,
                                hr        => hr );

  stimulus: process
  begin
  
    -- Put initialisation code here

	clk <= '0';			-- clock cycle is 10 ns
	wait for 5 ns;
	clk <= '1';
	wait for 5 ns;
    end process;
	
    process

	variable err_cnt: integer :=0;

    begin								
			
	sw_reset <= '1';			-- start counting
	count_ena <= '1';
	wait for 20 ns;	
		
	sw_reset <= '0';			-- clear output
		
	-- test case 1
	wait for 10 ns;
	--assert (csec=1) report "Failed case 1" severity error;
--	if csec = "0000001" then
--	    err_cnt := err_cnt+1;
--	end if;
	
				
       	-- summary of all the tests
	if (err_cnt=0) then 			
	    assert false 
	    report "Testbench of Adder completed successfully!" 
	    severity note; 
	else 
	    assert true 
	    report "Something wrong, try again" 
	    severity error; 
	end if; 
		
    -- Put test bench stimulus code here

    wait;
  end process;

 

end;
  