library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package z80_alu_pkg is
	type alu_opp is (add8, add16, xor8);
	constant ALU_FLAG_Z : integer := 3;
	constant ALU_FLAG_S : integer := 2;
	constant ALU_FLAG_H : integer := 1;
	constant ALU_FLAG_C : integer := 0;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.z80_alu_pkg.all;

entity z80_alu is
	port(
		in_8_a:  in  std_logic_vector(7 downto 0);
		in_8_b:  in  std_logic_vector(7 downto 0);
		out_8_o: out std_logic_vector(7 downto 0);
		out_8_f: out std_logic_vector(3 downto 0);
		
		in_16_a:  in  std_logic_vector(15 downto 0);
		in_16_b:  in  std_logic_vector(15 downto 0);
		out_16_o: out std_logic_vector(15 downto 0);

		opp: in alu_opp
		);
end z80_alu;


architecture logic of z80_alu is
	signal add_8_i: std_logic_vector(8 downto 0);
	signal add_8_f: std_logic_vector(3 downto 0);
	
	signal xor_8_i: std_logic_vector(7 downto 0);
	signal xor_8_z: std_logic;
	
	signal add_16_i: std_logic_vector(15 downto 0);
begin


	/* ADD 8 BIT INTEGERS */
	add_8_i <= ('0' & in_8_a) + ('0' & in_8_b);
	with add_8_i(7 downto 0) select add_8_f(ALU_FLAG_Z) <=
		'1' when x"00",
		'0' when others;
	add_8_f(ALU_FLAG_S) <= '0';
	add_8_f(ALU_FLAG_H) <= add_8_i(8);
	add_8_f(ALU_FLAG_C) <= add_8_i(8);


	/* XOR 8 BIT INTEGERS */
	xor_8_i <= in_8_a xor in_8_b;
	with xor_8_i(7 downto 0) select xor_8_z <=
		'1' when x"00",
		'0' when others;


	/* ADD 8 BIT INTEGERS */
	add_16_i <= in_16_a + in_16_b;


	/* Multiplex output */
	with opp select out_8_o <=
		add_8_i(7 downto 0) when add8,
		xor_8_i(7 downto 0) when xor8,
		x"00" when others;
		
	with opp select out_16_o <=
		add_16_i when add16,
		x"0000" when others;
		
	with opp select out_8_f <=
		add_8_f when add8,
		(ALU_FLAG_Z => xor_8_z, others => '0') when xor8,
		x"0" when others;
	
	
end logic;
