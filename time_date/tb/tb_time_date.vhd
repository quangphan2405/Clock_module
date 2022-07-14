
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_time_date is
--  Port ( );
end tb_time_date;

architecture Behavioral of tb_time_date is
    component time_date
        port(
    de_set: in std_logic;
    de_dow : in std_logic_vector(2 downto 0);
    de_day : in std_logic_vector(5 downto 0);
    de_month : in std_logic_vector(4 downto 0);
    de_year : in std_logic_vector(7 downto 0);
    de_hour: in std_logic_vector(5 downto 0);
    de_min: in std_logic_vector(6 downto 0);
    clk: in std_logic;
    rst: in std_logic;
    hour: out std_logic_vector(6 downto 0);
    minute: out std_logic_vector(6 downto 0);
    second: out std_logic_vector(6 downto 0);
    dow: out std_logic_vector(2 downto 0);
    year: out std_logic_vector(6 downto 0);
    month: out std_logic_vector(6 downto 0);
    day: out std_logic_vector(6 downto 0);
    lcd_dcf: out std_logic);
    end component;
    
    signal de_set: std_logic;
    signal de_dow: std_logic_vector(2 downto 0);
    signal de_day : std_logic_vector(5 downto 0);
    signal de_month : std_logic_vector(4 downto 0);
    signal de_year : std_logic_vector(7 downto 0);
    signal de_hour: std_logic_vector(5 downto 0);
    signal de_min: std_logic_vector(6 downto 0);
    signal clk, rst: std_logic:='0';
    signal hour: std_logic_vector(6 downto 0);
    signal minute: std_logic_vector(6 downto 0);
    signal second: std_logic_vector(6 downto 0);
    signal dow: std_logic_vector(2 downto 0);
    signal year: std_logic_vector(6 downto 0);
    signal month: std_logic_vector(6 downto 0);
    signal day: std_logic_vector(6 downto 0);
    signal lcd_dcf: std_logic;
    
begin
    uut:time_date port map ( de_set=>de_set,
    de_dow=>de_dow,
    de_day=>de_day,
    de_month=>de_month,
    de_year=>de_year,
    de_hour=>de_hour,
    de_min=>de_min,
    clk=>clk,
    rst=>rst,
    hour=>hour,
    minute=>minute,
    second=>second,
    dow=>dow,
    year=>year,
    month=>month,
    day=>day,
    lcd_dcf=>lcd_dcf);
    
    process
    begin 
        wait for 5 ns;
        clk<=not clk;
    end process;
    
    process
    begin
        wait for 45 ns;
        rst<='1';
        wait for 10 ns;
        rst<='0';
        wait for 2000 ns;
        de_set<='1';
        de_min<="0100110"; --7
        de_hour<="001000";--6
        de_day<="011001";--6
        de_month<="00111";--5
        de_year<="00000001";--8
        de_dow<="001";--3
        wait for 15 ns;
        de_set<='0';
         
        wait;
    end process;

end Behavioral;
