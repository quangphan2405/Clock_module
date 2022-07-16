-- Testbench created online at:
-- https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY counter_clock_tb IS
END;

ARCHITECTURE bench OF counter_clock_tb IS

	COMPONENT counter_clock
		PORT (
			clk : IN STD_LOGIC;
			fsm_stopwatch_start : IN STD_LOGIC;
			sw_reset : IN std_logic;
		    key_plus_imp : IN STD_LOGIC;
		    count_ena : IN std_logic;
			csec : OUT std_logic_vector(6 DOWNTO 0);
			sec : OUT std_logic_vector(6 DOWNTO 0);
			min : OUT std_logic_vector(6 DOWNTO 0);
			hr : OUT std_logic_vector(6 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL clk : STD_LOGIC;
	SIGNAL fsm_stopwatch_start : STD_LOGIC;
	SIGNAL sw_reset : std_logic;
	SIGNAL count_ena : std_logic;
	SIGNAL key_plus_imp : std_logic;
	SIGNAL csec : std_logic_vector(6 DOWNTO 0);
	SIGNAL sec : std_logic_vector(6 DOWNTO 0);
	SIGNAL min : std_logic_vector(6 DOWNTO 0);
	SIGNAL hr : std_logic_vector(6 DOWNTO 0);

BEGIN
	uut : counter_clock
	PORT MAP(
		clk => clk, 
		fsm_stopwatch_start => fsm_stopwatch_start,
		sw_reset => sw_reset, 
		count_ena => count_ena, 
		key_plus_imp => key_plus_imp,
		csec => csec, 
		sec => sec, 
		min => min, 
		hr => hr 
	);

	stimulus : PROCESS
	BEGIN
		-- Put initialisation code here

		clk <= '0'; -- clock cycle is 10 ns
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 5 ns;
	END PROCESS;
 
	PROCESS

	VARIABLE err_cnt : INTEGER := 0;

		BEGIN
			sw_reset <= '1'; -- start counting
			count_ena <= '1';
			WAIT FOR 20 ns; 
 
			sw_reset <= '0'; -- clear output
 
			-- test case 1
			WAIT FOR 10 ns;
			--assert (csec=1) report "Failed case 1" severity error;
			-- if csec = "0000001" then
			-- err_cnt := err_cnt+1;
			-- end if;
 
 
			-- summary of all the tests
			IF (err_cnt = 0) THEN 
				ASSERT false
				REPORT "Testbench OF Adder completed successfully!"
					SEVERITY note;
			ELSE
				ASSERT true
				REPORT "Something wrong, try again"
					SEVERITY error;
			END IF;
 
			-- Put test bench stimulus code here

			WAIT;
		END PROCESS;

END;