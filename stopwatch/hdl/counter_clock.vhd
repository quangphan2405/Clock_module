----------------------------------------------------
-- VHDL code for n-bit counter (ESD figure 2.6)
-- by Weijun Zhang, 04/2001
--
-- this is the behavior description of n-bit counter
-- another way can be used is FSM model. 
----------------------------------------------------
	
library ieee ;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

----------------------------------------------------

entity counter is

generic(n: natural :=2);
port(	clk:	  in std_logic;
	reset:	      in std_logic;
	count_ena:	  in std_logic;
	csec:	      out std_logic_vector(6 downto 0);
	sec:	      out std_logic_vector(5 downto 0);
	min:	      out std_logic_vector(5 downto 0);
	hr:	          out std_logic_vector(4 downto 0)
);
end counter;

----------------------------------------------------

architecture behv of counter is		 	  
	
    signal Pre_csec: std_logic_vector(6 downto 0):="0000000";
    signal Pre_sec: std_logic_vector(5 downto 0):="000000";
    signal Pre_min: std_logic_vector(5 downto 0):="000000";
    signal Pre_hr: std_logic_vector(4 downto 0):="00000";
begin

    -- behavior describe the counter

    process(clk, count_ena, reset)
    begin
	if reset = '1' then
 	    Pre_csec <= Pre_csec - Pre_csec;
 	    Pre_sec <= Pre_sec - Pre_sec;
 	    Pre_min <= Pre_min - Pre_min;
 	    Pre_hr <= Pre_hr - Pre_hr;
	elsif (clk='1' and clk'event) then
	    if count_ena = '1' then
            Pre_csec <= Pre_csec + 1;
            if Pre_csec = "1100011" then
               Pre_csec <= "0000000";
               Pre_sec <= Pre_sec + 1;
               if Pre_sec = "111011" then
                  Pre_sec <= "000000";
                  Pre_min <= Pre_min + 1;
                  if Pre_min = "111011"  then
                      Pre_min <= "000000";
                      Pre_hr <= Pre_hr + 1;
                      if Pre_hr = "10111" then --why not 24
                          Pre_csec <= Pre_csec - Pre_csec;
                          Pre_sec <= Pre_sec - Pre_sec;
                          Pre_min <= Pre_min - Pre_min;
                           Pre_hr <= Pre_hr - Pre_hr;
                      end if;
                   end if;
               end if;
            end if;
	    end if;
	end if;
    end process;	
	
    -- concurrent assignment statement
    csec <= Pre_csec;
    sec <= Pre_sec;
    min <= Pre_min;
    hr <= Pre_hr;

end behv;

-----------------------------------------------------