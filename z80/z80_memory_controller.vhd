library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.z80_pkg.all;


entity z80_memory_controller is
	port(
		clk: in std_logic;
		z80_address: in std_logic_vector(15 downto 0);
		z80_data_in: in std_logic_vector(7 downto 0);
		z80_wren: in std_logic;
		z80_data_out: out std_logic_vector(7 downto 0));
end z80_memory_controller;

architecture logic of z80_memory_controller is

	signal wram_address	: std_logic_vector(12 downto 0);
	signal wram_data		: std_logic_vector(7 downto 0);
	signal wram_wren		: std_logic;
	signal wram_q			: std_logic_vector(7 downto 0);
	
	signal rom_address	: std_logic_vector(13 downto 0);
	signal rom_q			: std_logic_vector(7 downto 0);

begin
	wram: entity ram_1port port map(
		address => wram_address,
		clock   => clk,
		data    => wram_data,
		wren    => wram_wren,
		q       => wram_q
	);
	
	crom: entity cartridge_rom port map(
		address => rom_address,
		clock   => clk,
		q       => rom_q
	);

	/* Global output map */
	with to_integer(unsigned(z80_address)) select z80_data_out <=
		rom_q	when 16#0000# to 16#3FFF#,
		wram_q	when 16#C000# to 16#DFFF#,
		x"FF" 	when others;

	/* Configure ROM */
	with to_integer(unsigned(z80_address)) select rom_address <=
		z80_address(13 downto 0) when 16#0000# to 16#3FFF#,
		"00000000000000"                   when others;
	
	/* Configure RAM */
	with to_integer(unsigned(z80_address)) select wram_address <=
		z80_address(12 downto 0) when 16#C000# to 16#DFFF#,
		"0000000000000"            when others;
	with to_integer(unsigned(z80_address)) select wram_wren <=
		z80_wren when 16#C000# to 16#DFFF#,
		'0'      when others;
	wram_data <= z80_data_in;
	

end logic;

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
