----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2022 11:54:10 AM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    Port ( transmitter_ena : in STD_LOGIC;
            csec_in:	  in std_logic_vector(6 downto 0);
            sec_in:	      in std_logic_vector(5 downto 0);
            min_in:	      in std_logic_vector(5 downto 0);
            hr_in:	      in std_logic_vector(4 downto 0);
            csec:	      out std_logic_vector(6 downto 0);
            sec:	      out std_logic_vector(5 downto 0);
            min:	      out std_logic_vector(5 downto 0);
            hr:	          out std_logic_vector(4 downto 0));
end transmitter;

architecture Behavioral of transmitter is

begin
    process(transmitter_ena, csec_in, sec_in, min_in, hr_in)
    
    variable csec_old :std_logic_vector(6 downto 0);
    variable sec_old :std_logic_vector(5 downto 0);
    variable min_old :std_logic_vector(5 downto 0);
    variable hr_old :std_logic_vector(4 downto 0);

    begin
    
    if transmitter_ena = '1' then                                                                                                   
        csec <= csec_in;
        csec_old := csec_in;
        sec <= sec_in;
        sec_old := sec_in;
        min <= min_in;
        min_old := min_in;
        hr <= hr_in;
        hr_old := hr_in;                                                                                    
    else
         csec <= csec_old;
        sec <= sec_old;
        min <= min_old;
        hr <= hr_old;                                                                                                    
     end if;

    
    end process;
end Behavioral;
