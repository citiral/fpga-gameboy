-- multiplex display (4 seg)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library work;
--use work.all;

entity multi_display is
	port(
		num        : in  std_logic_vector(15 downto 0);
		dots       : in  std_logic_vector(3 downto 0);
		clk        : in  std_logic;
		hex        : out std_logic_vector(7 downto 0);
		seg_enable : out std_logic_vector(3 downto 0)
	);
end multi_display;

architecture logic of multi_display is
	signal decode  : std_logic_vector(3 downto 0);
	signal dot     : std_logic;
	signal enabled : unsigned(1 downto 0) := "00";
begin
	driver : entity work.hex2seg port map(decode, dot, hex);
    
    -- enabled segment
    with enabled select
        seg_enable <= "0001"    when "00",
                      "0010"    when "01",
                      "0100"    when "10",
                      "1000"    when others;
    -- digit to decode
    with enabled select
        decode <= num(3 downto 0)      when "00",
                  num(7 downto 4)      when "01",
                  num(11 downto 8)     when "10",
                  num(15 downto 12)    when others;
                  
    with enabled select
        dot <= dots(0) when "00",
               dots(1) when "01",
               dots(2) when "10",
               dots(3) when others;
                  
    process (clk)
    begin
        if rising_edge(clk) then
            enabled <= enabled + 1;
        end if;
    end process;
    
end logic;

