----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 06/22/2022 11:54:10 AM
-- Design Name:
-- Module Name: lap - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
Library IEEE;
Use IEEE.STD_LOGIC_1164.All;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

Entity lap Is
	Port (
		clk : In STD_LOGIC;
		fsm_stopwatch_start : In STD_LOGIC;
		key_plus_imp : In STD_LOGIC;
		sw_reset : In STD_LOGIC;
		counter_ena : In STD_LOGIC;
		key_minus_imp : In STD_LOGIC;
		transmitter_ena : Out STD_LOGIC
	);
End lap;

Architecture Behavioral Of lap Is

	Signal Pre_transmitter_ena : STD_LOGIC := '1';
Begin
	Process (clk)
	Begin
		If (clk = '1' And clk'event) Then
			If sw_reset = '1' Then
				Pre_transmitter_ena <= '1';
			Else
				If fsm_stopwatch_start = '1' Then
					If key_plus_imp = '1' Then
						Pre_transmitter_ena <= '1';
					Else
						If counter_ena = '1' Then
							If Pre_transmitter_ena = '0' Then
								If key_minus_imp = '1' Then
									Pre_transmitter_ena <= '1';
								End If;
							Else
								If key_minus_imp = '1' Then
									Pre_transmitter_ena <= '0';
								End If;
							End If;
						End If;
					End If;
				End If;
			End If;
		End If;

	End Process;
 
	transmitter_ena <= Pre_transmitter_ena;

End Behavioral;
