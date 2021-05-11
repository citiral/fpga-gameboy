library ieee;
use ieee.std_logic_1164.all;

entity z80_register_8 is
	port(
		clk	:	in     std_logic;
		I		:	in     std_logic_vector(7 downto 0);
		O		:	out    std_logic_vector(7 downto 0));
end z80_register_8;

library ieee;
use ieee.std_logic_1164.all;

entity z80_register_16 is
	port(
		clk	:	in     std_logic;
		I		:	in     std_logic_vector(15 downto 0);
		O		:	out    std_logic_vector(15 downto 0));
end z80_register_16;


architecture logic of z80_register_8 is begin
	process(clk) begin
		if falling_edge(clk) then
			O <= I;
		end if;
	end process;
end logic;


architecture logic of z80_register_16 is begin
	process(clk) begin
		if falling_edge(clk) then
			O <= I;
		end if;
	end process;
end logic;
