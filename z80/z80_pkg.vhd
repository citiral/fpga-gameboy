library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package z80_pkg is
	type registers is array(0 to 7) of std_logic_vector(7 downto 0);
	
	constant REG_B: integer := 0;
	constant REG_C: integer := 1;
	constant REG_D: integer := 2;
	constant REG_E: integer := 3;
	constant REG_H: integer := 4;
	constant REG_L: integer := 5;
	constant REG_F: integer := 6;
	constant REG_A: integer := 7;
	
	/* List of all instructions */
	constant NOP:			std_logic_vector(7 downto 0) := x"00";
	
	constant LD_B_N:		std_logic_vector(7 downto 0) := "00000110";
	constant LD_C_N:		std_logic_vector(7 downto 0) := "00001110";
	constant LD_D_N:		std_logic_vector(7 downto 0) := "00010110";
	constant LD_E_N:		std_logic_vector(7 downto 0) := "00011110";
	constant LD_H_N:		std_logic_vector(7 downto 0) := "00100110";
	constant LD_L_N:		std_logic_vector(7 downto 0) := "00101110";
	constant LD_A_N:		std_logic_vector(7 downto 0) := "00111110";
	
	constant LD_B_B:  	std_logic_vector(7 downto 0) := "01000000";
	constant LD_B_C:  	std_logic_vector(7 downto 0) := "01000001";
	constant LD_B_D:  	std_logic_vector(7 downto 0) := "01000010";
	constant LD_B_E:  	std_logic_vector(7 downto 0) := "01000011";
	constant LD_B_H:  	std_logic_vector(7 downto 0) := "01000100";
	constant LD_B_L:  	std_logic_vector(7 downto 0) := "01000101";
	constant LD_B_A:  	std_logic_vector(7 downto 0) := "01000111";
	
	constant LD_C_B:  	std_logic_vector(7 downto 0) := "01001000";
	constant LD_C_C:  	std_logic_vector(7 downto 0) := "01001001";
	constant LD_C_D:  	std_logic_vector(7 downto 0) := "01001010";
	constant LD_C_E:  	std_logic_vector(7 downto 0) := "01001011";
	constant LD_C_H:  	std_logic_vector(7 downto 0) := "01001100";
	constant LD_C_L:  	std_logic_vector(7 downto 0) := "01001101";
	constant LD_C_A:  	std_logic_vector(7 downto 0) := "01001111";
	
	constant LD_D_B:  	std_logic_vector(7 downto 0) := "01010000";
	constant LD_D_C:  	std_logic_vector(7 downto 0) := "01010001";
	constant LD_D_D:  	std_logic_vector(7 downto 0) := "01010010";
	constant LD_D_E:  	std_logic_vector(7 downto 0) := "01010011";
	constant LD_D_H:  	std_logic_vector(7 downto 0) := "01010100";
	constant LD_D_L:  	std_logic_vector(7 downto 0) := "01010101";
	constant LD_D_A:  	std_logic_vector(7 downto 0) := "01010111";
	
	constant LD_E_B:  	std_logic_vector(7 downto 0) := "01011000";
	constant LD_E_C:  	std_logic_vector(7 downto 0) := "01011001";
	constant LD_E_D:  	std_logic_vector(7 downto 0) := "01011010";
	constant LD_E_E:  	std_logic_vector(7 downto 0) := "01011011";
	constant LD_E_H:  	std_logic_vector(7 downto 0) := "01011100";
	constant LD_E_L:  	std_logic_vector(7 downto 0) := "01011101";
	constant LD_E_A:  	std_logic_vector(7 downto 0) := "01011111";
	
	constant LD_H_B:  	std_logic_vector(7 downto 0) := "01100000";
	constant LD_H_C:  	std_logic_vector(7 downto 0) := "01100001";
	constant LD_H_D:  	std_logic_vector(7 downto 0) := "01100010";
	constant LD_H_E:  	std_logic_vector(7 downto 0) := "01100011";
	constant LD_H_H:  	std_logic_vector(7 downto 0) := "01100100";
	constant LD_H_L:  	std_logic_vector(7 downto 0) := "01100101";
	constant LD_H_A:  	std_logic_vector(7 downto 0) := "01100111";
	
	constant LD_L_B:  	std_logic_vector(7 downto 0) := "01101000";
	constant LD_L_C:  	std_logic_vector(7 downto 0) := "01101001";
	constant LD_L_D:  	std_logic_vector(7 downto 0) := "01101010";
	constant LD_L_E:  	std_logic_vector(7 downto 0) := "01101011";
	constant LD_L_H:  	std_logic_vector(7 downto 0) := "01101100";
	constant LD_L_L:  	std_logic_vector(7 downto 0) := "01101101";
	constant LD_L_A:  	std_logic_vector(7 downto 0) := "01101111";
	
	constant LD_A_B:  	std_logic_vector(7 downto 0) := "01111000";
	constant LD_A_C:  	std_logic_vector(7 downto 0) := "01111001";
	constant LD_A_D:  	std_logic_vector(7 downto 0) := "01111010";
	constant LD_A_E:  	std_logic_vector(7 downto 0) := "01111011";
	constant LD_A_H:  	std_logic_vector(7 downto 0) := "01111100";
	constant LD_A_L:  	std_logic_vector(7 downto 0) := "01111101";
	constant LD_A_A:  	std_logic_vector(7 downto 0) := "01111111";
	
	constant LD_B_HL:	std_logic_vector(7 downto 0) := "01000110";
	constant LD_C_HL:	std_logic_vector(7 downto 0) := "01001110";
	constant LD_D_HL:	std_logic_vector(7 downto 0) := "01010110";
	constant LD_E_HL:	std_logic_vector(7 downto 0) := "01011110";
	constant LD_H_HL:	std_logic_vector(7 downto 0) := "01100110";
	constant LD_L_HL:	std_logic_vector(7 downto 0) := "01101110";
	constant LD_A_HL:	std_logic_vector(7 downto 0) := "01111110";
	
	constant LD_HL_B:	std_logic_vector(7 downto 0) := "01110000";
	constant LD_HL_C:	std_logic_vector(7 downto 0) := "01110001";
	constant LD_HL_D:	std_logic_vector(7 downto 0) := "01110010";
	constant LD_HL_E:	std_logic_vector(7 downto 0) := "01110011";
	constant LD_HL_H:	std_logic_vector(7 downto 0) := "01110100";
	constant LD_HL_L:	std_logic_vector(7 downto 0) := "01110101";
	constant LD_HL_A:	std_logic_vector(7 downto 0) := "01110111";
	
	constant LD_A16_SP:	std_logic_vector(7 downto 0) := x"08";
	
	constant JP_NN:		std_logic_vector(7 downto 0) := x"C3";
	constant JR_NZ:		std_logic_vector(7 downto 0) := x"20";

	constant ADD_N:		std_logic_vector(7 downto 0) := x"C6";
	constant ADD_A_B:		std_logic_vector(7 downto 0) := "10000000";
	constant ADD_A_C:		std_logic_vector(7 downto 0) := "10000001";
	constant ADD_A_D:		std_logic_vector(7 downto 0) := "10000010";
	constant ADD_A_E:		std_logic_vector(7 downto 0) := "10000011";
	constant ADD_A_H:		std_logic_vector(7 downto 0) := "10000100";
	constant ADD_A_L:		std_logic_vector(7 downto 0) := "10000101";
	constant ADD_A_A:		std_logic_vector(7 downto 0) := "10000111";
	
	constant SUB_A_B:		std_logic_vector(7 downto 0) := "10010000";
	constant SUB_A_C:		std_logic_vector(7 downto 0) := "10010001";
	constant SUB_A_D:		std_logic_vector(7 downto 0) := "10010010";
	constant SUB_A_E:		std_logic_vector(7 downto 0) := "10010011";
	constant SUB_A_H:		std_logic_vector(7 downto 0) := "10010100";
	constant SUB_A_L:		std_logic_vector(7 downto 0) := "10010101";
	constant SUB_A_A:		std_logic_vector(7 downto 0) := "10010111";
	
	constant XOR_A_B:		std_logic_vector(7 downto 0) := "10101000";
	constant XOR_A_C:		std_logic_vector(7 downto 0) := "10101001";
	constant XOR_A_D:		std_logic_vector(7 downto 0) := "10101010";
	constant XOR_A_E:		std_logic_vector(7 downto 0) := "10101011";
	constant XOR_A_H:		std_logic_vector(7 downto 0) := "10101100";
	constant XOR_A_L:		std_logic_vector(7 downto 0) := "10101101";
	constant XOR_A_A:		std_logic_vector(7 downto 0) := "10101111";
	
	constant CP_A_B:		std_logic_vector(7 downto 0) := "10111000";
	constant CP_A_C:		std_logic_vector(7 downto 0) := "10111001";
	constant CP_A_D:		std_logic_vector(7 downto 0) := "10111010";
	constant CP_A_E:		std_logic_vector(7 downto 0) := "10111011";
	constant CP_A_H:		std_logic_vector(7 downto 0) := "10111100";
	constant CP_A_L:		std_logic_vector(7 downto 0) := "10111101";
	constant CP_A_A:		std_logic_vector(7 downto 0) := "10111111";
	
	constant OR_A_B:		std_logic_vector(7 downto 0) := "10110000";
	constant OR_A_C:		std_logic_vector(7 downto 0) := "10110001";
	constant OR_A_D:		std_logic_vector(7 downto 0) := "10110010";
	constant OR_A_E:		std_logic_vector(7 downto 0) := "10110011";
	constant OR_A_H:		std_logic_vector(7 downto 0) := "10110100";
	constant OR_A_L:		std_logic_vector(7 downto 0) := "10110101";
	constant OR_A_A:		std_logic_vector(7 downto 0) := "10110111";
	
	constant DEC_B:		std_logic_vector(7 downto 0) := "00000101";
	constant DEC_C:		std_logic_vector(7 downto 0) := "00001101";
	constant DEC_D:		std_logic_vector(7 downto 0) := "00010101";
	constant DEC_E:		std_logic_vector(7 downto 0) := "00011101";
	constant DEC_H:		std_logic_vector(7 downto 0) := "00100101";
	constant DEC_L:		std_logic_vector(7 downto 0) := "00101101";
	constant DEC_A:		std_logic_vector(7 downto 0) := "00111101";
	
	constant INC_B:		std_logic_vector(7 downto 0) := "00000100";
	constant INC_C:		std_logic_vector(7 downto 0) := "00001100";
	constant INC_D:		std_logic_vector(7 downto 0) := "00010100";
	constant INC_E:		std_logic_vector(7 downto 0) := "00011100";
	constant INC_H:		std_logic_vector(7 downto 0) := "00100100";
	constant INC_L:		std_logic_vector(7 downto 0) := "00101100";
	constant INC_A:		std_logic_vector(7 downto 0) := "00111100";
	
	constant RRCA:			std_logic_vector(7 downto 0) := x"0F";
	constant RRA:			std_logic_vector(7 downto 0) := x"1F";
	constant RLCA:			std_logic_vector(7 downto 0) := x"07";
	constant RLA:			std_logic_vector(7 downto 0) := x"17";
	
	constant LD_RR_NN:	std_logic_vector(7 downto 0) := "00--0001";
	
	constant LDI_HL_A:	std_logic_vector(7 downto 0) := "001-0010";

	constant ADD_HL_BC:	std_logic_vector(7 downto 0) := x"09";
	constant ADD_HL_DE:	std_logic_vector(7 downto 0) := x"19";
	constant ADD_HL_HL:	std_logic_vector(7 downto 0) := x"29";
	constant ADD_HL_SP:	std_logic_vector(7 downto 0) := x"39";
	
	constant INC_BC:		std_logic_vector(7 downto 0) := x"03";
	constant INC_DE:		std_logic_vector(7 downto 0) := x"13";
	constant INC_HL:		std_logic_vector(7 downto 0) := x"23";
	constant INC_SP:		std_logic_vector(7 downto 0) := x"33";

end package;
