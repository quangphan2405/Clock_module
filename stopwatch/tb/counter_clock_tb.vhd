-----------------------------------------------------------------------
-- Test Bench for counter (ESD figure 2.6)
-- by Weijun Zhang, 04/2001
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;			 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter_TB is			-- entity declaration
end counter_TB;

-----------------------------------------------------------------------

architecture TB of counter_TB is

    component counter
    port(   clk:	in std_logic;
	    reset:	in std_logic;
	    count_ena:	in std_logic;
	    csec:		out std_logic_vector(6 downto 0);
	    sec:		out std_logic_vector(5 downto 0);
	    min:		out std_logic_vector(5 downto 0);
	    hr:		out std_logic_vector(4 downto 0)
    );
    end component;

    signal T_clk:     std_logic;
    signal T_reset:     std_logic;
    signal T_count_ena:     std_logic;
    signal T_csec:         std_logic_vector(6 downto 0);
    signal T_sec:         std_logic_vector(5 downto 0);
    signal T_min:         std_logic_vector(5 downto 0);
    signal T_hr:         std_logic_vector(4 downto 0);

begin
    
    U_counter: counter port map (T_clk, T_reset, T_count_ena, T_csec, T_sec, T_min, T_hr);
	
    process				 
    begin
	T_clk <= '0';			-- clock cycle is 10 ns
	wait for 5 ns;
	T_clk <= '1';
	wait for 5 ns;
    end process;
	
    process

	variable err_cnt: integer :=0;

    begin								
			
	T_reset <= '1';			-- start counting
	T_count_ena <= '1';
	wait for 20 ns;	
		
	T_reset <= '0';			-- clear output
		
	-- test case 1
	wait for 10 ns;
	assert (T_csec=1) report "Failed case 1" severity error;
	if (T_csec/=1) then
	    err_cnt := err_cnt+1;
	end if;
			
	-- test case 2
	wait for 10 ns;
	assert (T_csec=2) report "Failed case 2" severity error;	
	if (T_csec/=2) then
	    err_cnt := err_cnt+1;
	end if;
			
	-- test case 3
	wait for 10 ns;
	assert (T_csec=3) report "Failed case 3" severity error;
	if (T_csec/=3) then
	    err_cnt := err_cnt+1;
	end if;
	
	-- test case 4
	wait for 70 ns;
	assert (T_csec=10) report "Failed case 4" severity error;
	if (T_csec/=10) then
	    err_cnt := err_cnt+1;
	end if;
	
	-- test case 5
	wait for 890 ns;
	assert (T_csec=99) report "Failed case 5" severity error;
	if (T_csec/=99) then
	    err_cnt := err_cnt+1;
	end if;	
	
	-- test case 6
	wait for 10 ns;
	assert (T_csec=0) report "Failed case 6" severity error;
	if (T_csec/=0) then
	    err_cnt := err_cnt+1;
	end if;	
	
	
	-- test case 7
	wait for 510010 ns;
	assert (T_sec=59) report "Failed case 7" severity error;
	if (T_sec/=59) then
	    err_cnt := err_cnt+1;
	end if;	
	
	-- test case 8
	wait for 10 ns;
	assert (T_sec=0) report "Failed case 8" severity error;
	if (T_sec/=0) then
	    err_cnt := err_cnt+1;
	end if;
	
	-- test case 9
	wait for 20 ms;
	T_count_ena <= '0';
	assert (T_hr=05) report "Failed case 9" severity error;
	if (T_hr/=05) then
	    err_cnt := err_cnt+1;
	end if;	
	
	-- test case 10
	wait for 100 ms;
	T_count_ena <= '0';	
	assert (T_hr=05) report "Failed case 10" severity error;
	if (T_hr/=05) then
	    err_cnt := err_cnt+1;
	end if;	

	-- test case 11
	T_count_ena <= '1';
	wait for 40 ms;
	assert (T_hr=23) report "Failed case 11" severity error;
	if (T_hr/=23) then
	    err_cnt := err_cnt+1;
	end if;	
	
	-- test case 12
	wait for 1 ms;
	assert (T_hr=0) report "Failed case 12" severity error;
	if (T_hr/=0) then
	    err_cnt := err_cnt+1;
	end if;
	
	-- test case 13
	wait for 20 ns;	
	T_reset <= '1';
	wait for 10 ns;
	assert (T_csec=0) report "Failed case 13" severity error;
	if (T_csec/=0) then
	    err_cnt := err_cnt+1;
	end if;
				
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
		
	wait;
		
    end process;

end TB;

----------------------------------------------------------------
configuration CFG_TB of counter_TB is
	for TB
	end for;
end CFG_TB;
----------------------------------------------------------------