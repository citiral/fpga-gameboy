library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity z80_register_selector is
	port(
		sel   :  in     std_logic_vector(2 downto 0);

		a_in  :  in std_logic_vector(7 downto 0);
		a_out : out std_logic_vector(7 downto 0);	
		b_in  :  in std_logic_vector(7 downto 0);
		b_out : out std_logic_vector(7 downto 0);
		c_in  :  in std_logic_vector(7 downto 0);
		c_out : out std_logic_vector(7 downto 0);
		d_in  :  in std_logic_vector(7 downto 0);
		d_out : out std_logic_vector(7 downto 0);
		e_in  :  in std_logic_vector(7 downto 0);
		e_out : out std_logic_vector(7 downto 0);
		--f_in  :  in std_logic_vector(7 downto 0);
		--f_out : out std_logic_vector(7 downto 0);
		h_in  :  in std_logic_vector(7 downto 0);
		h_out : out std_logic_vector(7 downto 0);
		l_in  :  in std_logic_vector(7 downto 0);
		l_out : out std_logic_vector(7 downto 0);
		
		I		:	in     std_logic_vector(7 downto 0);
		O		:	out    std_logic_vector(7 downto 0));
end z80_register_selector;

/*
architecture logic of z80_register_selector is begin

	with sel select O <=
		b_out when "000",
		c_out when "001",
		d_out when "010",
		e_out when "011",
		h_out when "100",
		l_out when "101",
	--	f_out when "110",
		a_out when "111";

	with sel select b_out <=
		I     when "000",
		b_out when others;

	with sel select c_out <=
		I     when "001",
		c_out when others;

	with sel select d_out <=
		I     when "010",
		d_out when others;

	with sel select e_out <=
		I     when "011",
		e_out when others;

	with sel select h_out <=
		I     when "100",
		h_out when others;

	with sel select l_out <=
		I     when "101",
		l_out when others;

	--with sel select f_out <=
	--	I     when "110",
	--	f_out when others;

	with sel select a_out <=
		I     when "111",
		a_out when others;
end logic;
*/
