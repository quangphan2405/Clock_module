-- Testbench created online at:
-- https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Numeric_Std.ALL;

ENTITY counter_controller_tb IS
END;

ARCHITECTURE bench OF counter_controller_tb IS

	COMPONENT counter_controller
		PORT (
			clk : IN STD_LOGIC;
			fsm_stopwatch_start : IN STD_LOGIC;
			sw_reset : IN STD_LOGIC;
			key_action_imp : IN STD_LOGIC;
			counter_ena : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL clk : STD_LOGIC;
	SIGNAL fsm_stopwatch_start : STD_LOGIC;
	SIGNAL sw_reset : STD_LOGIC;
	SIGNAL key_action_imp : STD_LOGIC;
	SIGNAL counter_ena : STD_LOGIC;
BEGIN
	uut : counter_controller
	PORT MAP(
		clk => clk, 
		fsm_stopwatch_start => fsm_stopwatch_start, 
		sw_reset => sw_reset, 
		key_action_imp => key_action_imp, 
		counter_ena => counter_ena 
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
		key_action_imp <= '0';

		WAIT FOR 20 ns;
 
		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--stop counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
 
		-- reset 
		sw_reset <= '1';
		WAIT FOR 10 ns;
		sw_reset <= '0';
		WAIT FOR 40 ns;

		--start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		--stop counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- start counting
		key_action_imp <= '1';
		WAIT FOR 10 ns;
		key_action_imp <= '0';
		WAIT FOR 40 ns;
 
		-- Put test bench stimulus code here

		WAIT;
	END PROCESS;
END;