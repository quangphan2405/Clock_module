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
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    Port (  clk           : in std_logic;
            sw_ena       : in std_logic;
            sw_reset :       in std_logic;
            transmitter_ena : in std_logic :='1';
            csec_in:	  in std_logic_vector(6 downto 0):="0000000";
            sec_in:	      in std_logic_vector(6 downto 0):="0000000";
            min_in:	      in std_logic_vector(6 downto 0):="0000000";
            hr_in:	      in std_logic_vector(6 downto 0):="0000000";
            csec:	      out std_logic_vector(6 downto 0):="0000000";
            sec:	      out std_logic_vector(6 downto 0):="0000000";
            min:	      out std_logic_vector(6 downto 0):="0000000";
            hr:	          out std_logic_vector(6 downto 0):="0000000");
end transmitter;

architecture Behavioral of transmitter is

    signal csec_old: std_logic_vector(6 downto 0) :="0000000";
    signal sec_old: std_logic_vector(6 downto 0):="0000000";
    signal min_old: std_logic_vector(6 downto 0):="0000000";
    signal hr_old: std_logic_vector(6 downto 0):="0000000";

begin


    process(clk,sw_ena, sw_reset, transmitter_ena, csec_in, sec_in, min_in, hr_in, csec_old, sec_old, min_old, hr_old)
    
    begin
    
    if (clk='1' and clk'event) then
         if sw_ena = '1' then 
                if sw_reset = '1' then
                	  csec_old <= csec_old - csec_old;
	                  sec_old <= sec_old - sec_old;
                      min_old <= min_old -  min_old;
                      hr_old <=  hr_old -  hr_old;
                      csec <= csec_old - csec_old;
	                  sec <= sec_old - sec_old;
                      min <= min_old -  min_old;
                      hr <=  hr_old -  hr_old;
                else
    
                     if transmitter_ena = '1' then                                                                                                   
                                csec <= csec_in;
                                csec_old <= csec_in;
                                sec <= sec_in;
                                sec_old <= sec_in;
                                min <= min_in;
                                min_old <= min_in;
                                hr <= hr_in;
                                hr_old <= hr_in;                                                                                    
                      else
                            csec <= csec_old;
                            sec <= sec_old;
                            min <= min_old;
                            hr <= hr_old;                                                                                                    
                      end if;
                 end if;
        end if;
      
    end if;


    end process;
end Behavioral;
