-- Testbench created online at:
-- https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY transmitter_tb IS
END;

ARCHITECTURE bench OF transmitter_tb IS

	COMPONENT transmitter
		PORT (
			clk : IN std_logic;
			fsm_stopwatch_start : IN std_logic;
			sw_reset : IN std_logic;
			transmitter_ena : IN STD_LOGIC;
			csec_in : IN std_logic_vector(6 DOWNTO 0);
			sec_in : IN std_logic_vector(6 DOWNTO 0);
			min_in : IN std_logic_vector(6 DOWNTO 0);
			hr_in : IN std_logic_vector(6 DOWNTO 0);
			csec : OUT std_logic_vector(6 DOWNTO 0);
			sec : OUT std_logic_vector(6 DOWNTO 0);
			min : OUT std_logic_vector(6 DOWNTO 0);
			hr : OUT std_logic_vector(6 DOWNTO 0)
		);
	END COMPONENT;

 
	SIGNAL clk : STD_LOGIC;
	SIGNAL fsm_stopwatch_start : STD_LOGIC;
	SIGNAL sw_reset : STD_LOGIC;
	SIGNAL transmitter_ena : STD_LOGIC;
	SIGNAL csec_in : std_logic_vector(6 DOWNTO 0);
	SIGNAL sec_in : std_logic_vector(6 DOWNTO 0);
	SIGNAL min_in : std_logic_vector(6 DOWNTO 0);
	SIGNAL hr_in : std_logic_vector(6 DOWNTO 0);
	SIGNAL csec : std_logic_vector(6 DOWNTO 0);
	SIGNAL sec : std_logic_vector(6 DOWNTO 0);
	SIGNAL min : std_logic_vector(6 DOWNTO 0);
	SIGNAL hr : std_logic_vector(6 DOWNTO 0);

BEGIN
	uut : transmitter
	PORT MAP(
		clk => clk, 
		fsm_stopwatch_start => fsm_stopwatch_start, 
		sw_reset => sw_reset, 
		transmitter_ena => transmitter_ena, 
		csec_in => csec_in, 
		sec_in => sec_in, 
		min_in => min_in, 
		hr_in => hr_in, 
		csec => csec, 
		sec => sec, 
		min => min, 
		hr => hr 
	);
 
	PROCESS 
	BEGIN
		clk <= '0'; -- clock cycle is 10 ns
		WAIT FOR 5 ns;
		clk <= '1';
		WAIT FOR 5 ns;
	END PROCESS;
	stimulus : PROCESS
	BEGIN
		-- Put initialisation code here
		fsm_stopwatch_start <= '1';
		sw_reset <= '0';
		transmitter_ena <= '0';
 
		csec_in <= "0000001";
		sec_in <= "0000001";
		min_in <= "0000001";
		hr_in <= "0000001";
 
		WAIT FOR 20 ns;
 
		transmitter_ena <= '1';
		WAIT FOR 40 ns;
 
		csec_in <= "0000011";
		sec_in <= "0000011";
		min_in <= "0000011";
		hr_in <= "0000011";
		WAIT FOR 40 ns;

 
		transmitter_ena <= '0';
		WAIT FOR 40 ns;
 
		csec_in <= "0000111";
		sec_in <= "0000111";
		min_in <= "0000111";
		hr_in <= "0000111";
		WAIT FOR 40 ns;
		transmitter_ena <= '1';
		WAIT FOR 40 ns;
 
		csec_in <= "0001111";
		sec_in <= "0001111";
		min_in <= "0001111";
		hr_in <= "0001111";
		WAIT FOR 20 ns;
		sw_reset <= '1';
		WAIT FOR 10 ns;
		sw_reset <= '0';

		WAIT FOR 20 ns;
 
		csec_in <= "0011111";
		sec_in <= "0011111";
		min_in <= "0011111";
		hr_in <= "0011111";

		transmitter_ena <= '1';
		WAIT FOR 40 ns;
 
 
		csec_in <= "0111111";
		sec_in <= "0111111";
		min_in <= "0111111";
		hr_in <= "0111111";
		-- Put test bench stimulus code here

		WAIT;
	END PROCESS;
END;