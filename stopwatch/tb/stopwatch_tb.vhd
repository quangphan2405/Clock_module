-- Testbench created online at:
-- https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY stopwatch_tb IS
END;

ARCHITECTURE bench OF stopwatch_tb IS

	COMPONENT stopwatch
		PORT (
			fsm_stopwatch_start : IN STD_LOGIC;
			key_minus_imp : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			key_plus_imp : IN STD_LOGIC;
			key_action_imp : IN STD_LOGIC;
			lcd_stopwatch_act : OUT STD_LOGIC;
			cs : OUT STD_LOGIC_vector(6 DOWNTO 0);
			ss : OUT STD_LOGIC_vector(6 DOWNTO 0);
			mm : OUT STD_LOGIC_vector(6 DOWNTO 0);
			hh : OUT STD_LOGIC_vector(6 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL fsm_stopwatch_start : STD_LOGIC;
	SIGNAL key_minus_imp : STD_LOGIC;
	SIGNAL clk : STD_LOGIC;
	SIGNAL reset : STD_LOGIC;
	SIGNAL key_plus_imp : STD_LOGIC;
	SIGNAL key_action_imp : STD_LOGIC;
	SIGNAL lcd_stopwatch_act : STD_LOGIC;
	SIGNAL cs : STD_LOGIC_vector(6 DOWNTO 0);
	SIGNAL ss : STD_LOGIC_vector(6 DOWNTO 0);
	SIGNAL mm : STD_LOGIC_vector(6 DOWNTO 0);
	SIGNAL hh : STD_LOGIC_vector(6 DOWNTO 0);

BEGIN
	uut : stopwatch
	PORT MAP(
		fsm_stopwatch_start => fsm_stopwatch_start, 
		key_minus_imp => key_minus_imp, 
		clk => clk, 
		reset => reset, 
		key_plus_imp => key_plus_imp, 
		key_action_imp => key_action_imp, 
		lcd_stopwatch_act => lcd_stopwatch_act,
		cs => cs, 
		ss => ss, 
		mm => mm, 
		hh => hh 
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
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--initialization values
		fsm_stopwatch_start <= '1';
		key_minus_imp <= '0';
		key_plus_imp <= '0';
		key_action_imp <= '0';
		reset <= '0';
		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

 
		--stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0';
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns; 
 
		--resume
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		reset <= '1';
		WAIT FOR 10 ns;
		reset <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;
 
		--pause
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- stop lapping
		key_minus_imp <= '1';
		WAIT FOR 10 ns;
		key_minus_imp <= '0'; 
		WAIT FOR 40 ns;

		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;

		--reset
		key_plus_imp <= '1';
		WAIT FOR 10 ns;
		key_plus_imp <= '0';
		WAIT FOR 40 ns;
 
		--run
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
 
		-- Put test bench stimulus code here

		WAIT;
	END PROCESS;
END;