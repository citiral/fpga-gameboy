library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.z80_pkg.all;
use work.z80_alu_pkg.all;

entity z80 is
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		/*pc_in: in   std_logic_vector(15 downto 0);
		pc_out: out std_logic_vector(15 downto 0);
		sp_in: in   std_logic_vector(15 downto 0);
		sp_out: out std_logic_vector(15 downto 0);		
		reg_in: in registers;
		reg_out: out registers;*/

		mem_address: out std_logic_vector(15 downto 0);
		mem_in:      in  std_logic_vector(7 downto 0);
		mem_out:     out std_logic_vector(7 downto 0);
		mem_wren:    out std_logic;

		debug: out std_logic_vector(35 downto 0)
		);
end z80;


architecture logic of z80 is

	/* CPU State machine */
	type cpu_state_values is (instr_fetch, instr_fetch1, instr_decode1, instr_decode2, param0_fetch, param0_fetch1, param0_decode1, param0_decode2, param1_fetch, param1_fetch1, param1_decode1, param1_decode2, halt, wait_state);
	signal cpu_state : cpu_state_values;
	signal wait_count : signed(3 downto 0);

	/* Buffer for arithmatic operations */
	signal alu_in8_a: std_logic_vector(7 downto 0);
	signal alu_in8_b: std_logic_vector(7 downto 0);
	signal alu_out8_o: std_logic_vector(7 downto 0);
	signal alu_out8_f: std_logic_vector(3 downto 0);
	signal alu_in16_a: std_logic_vector(15 downto 0);
	signal alu_in16_b: std_logic_vector(15 downto 0);
	signal alu_out16_o: std_logic_vector(15 downto 0);
	signal alu_opp: alu_opp;

begin
	
	alu: entity work.z80_alu port map(
		in_8_a => alu_in8_a,
		in_8_b => alu_in8_b,
		out_8_o => alu_out8_o,
		out_8_f => alu_out8_f,
		
		in_16_a => alu_in16_a,
		in_16_b => alu_in16_b,
		out_16_o => alu_out16_o,

		opp => alu_opp
	);

process(clk, rst)
	
	/* Buffers to store current instruction */
	variable opcode_0: std_logic_vector(7 downto 0);
	variable opcode_1: std_logic_vector(7 downto 0);
	variable opcode_2: std_logic_vector(7 downto 0);
	
	variable pc: std_logic_vector(15 downto 0);
	variable sp: std_logic_vector(15 downto 0);
	variable reg: registers;

	variable regsel_0: std_logic_vector(7 downto 0);
	
begin
	if rising_edge(clk) then
		/* Reset the chip to its default state */
		if (rst = '1') then
			pc := x"0100";
			sp := x"0000";
			reg(REG_A) := x"00";
			reg(REG_B) := x"00";
			reg(REG_C) := x"00";
			reg(REG_D) := x"00";
			reg(REG_E) := x"00";
			reg(REG_H) := x"00";
			reg(REG_L) := x"00";
			reg(REG_F) := x"00";

			mem_address <= x"0000";
			mem_out <= x"00";
			mem_wren <= '0';
			
			debug <= x"000000000";

			cpu_state <= instr_fetch;

			opcode_0 := x"00";
			opcode_1 := x"00";
			opcode_2 := x"00";
		else
			debug(15 downto 8) <= reg(REG_A);
			debug(7 downto 0) <= reg(REG_F);
			
			regsel_0 := reg(to_integer(unsigned(mem_in(2 downto 0))));

			/* Main CPU state machine */
			case cpu_state is
			
				/* STEP 1: Fetch the next instruction from memory */
				/*when instr_fetch =>
					mem_address <= pc;
					mem_wren <= '0';
					wait until clk'event and clk = '1';
					cpu_state <= instr_decode1;*/
				when instr_fetch =>
					mem_address <= pc;
					mem_wren <= '0';
					cpu_state <= instr_fetch1;
				when instr_fetch1 =>
					cpu_state <= instr_decode1;


				/* STEP 2: Decode and execute the instruction */

				when instr_decode1 =>
					opcode_0 := mem_in;
					case? mem_in is

						when ADD_HL_BC =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_H) & reg(REG_L);
							alu_in16_b <= reg(REG_B) & reg(REG_C);
							cpu_state <= instr_decode2;

						when ADD_HL_DE =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_H) & reg(REG_L);
							alu_in16_b <= reg(REG_D) & reg(REG_E);
							cpu_state <= instr_decode2;
							
						when ADD_HL_HL =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_H) & reg(REG_L);
							alu_in16_b <= reg(REG_H) & reg(REG_L);
							cpu_state <= instr_decode2;
							
						when ADD_HL_SP =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_H) & reg(REG_L);
							alu_in16_b <= sp;
							cpu_state <= instr_decode2;

						when INC_BC =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_B) & reg(REG_C);
							alu_in16_b <= x"0001";
							cpu_state <= instr_decode2;

						when INC_DE =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_D) & reg(REG_E);
							alu_in16_b <= x"0001";
							cpu_state <= instr_decode2;

						when INC_HL =>
							alu_opp <= add16;
							alu_in16_a <= reg(REG_H) & reg(REG_L);
							alu_in16_b <= x"0001";
							cpu_state <= instr_decode2;

						when INC_SP =>
							alu_opp <= add16;
							alu_in16_a <= sp;
							alu_in16_b <= x"0001";
							cpu_state <= instr_decode2;
					
						when ADD_A_B | ADD_A_C | ADD_A_D | ADD_A_E | ADD_A_H | ADD_A_L | ADD_A_A =>
							alu_opp <= add8;
							alu_in8_a <= reg(REG_A);
							alu_in8_b <= regsel_0;
							cpu_state <= instr_decode2;

						when SUB_A_B | SUB_A_C | SUB_A_D | SUB_A_E | SUB_A_H | SUB_A_L | SUB_A_A | 
							  CP_A_B | CP_A_C | CP_A_D | CP_A_E | CP_A_H | CP_A_L | CP_A_A =>
							alu_opp <= sub8;
							alu_in8_a <= reg(REG_A);
							alu_in8_b <= regsel_0;
							cpu_state <= instr_decode2;

						when DEC_B | DEC_C | DEC_D | DEC_E | DEC_H | DEC_L | DEC_A =>
							alu_opp <= add8;
							alu_in8_a <= regsel_0;
							alu_in8_b <= x"FF";
							cpu_state <= instr_decode2;

						when INC_B | INC_C | INC_D | INC_E | INC_H | INC_L | INC_A =>
							alu_opp <= add8;
							alu_in8_a <= regsel_0;
							alu_in8_b <= x"01";
							cpu_state <= instr_decode2;

						when XOR_A_B | XOR_A_C | XOR_A_D | XOR_A_E | XOR_A_H | XOR_A_L | XOR_A_A =>
							alu_opp <= xor8;
							alu_in8_a <= reg(REG_A);
							alu_in8_b <= regsel_0;
							cpu_state <= instr_decode2;

						when OR_A_B | OR_A_C | OR_A_D | OR_A_E | OR_A_H | OR_A_L | OR_A_A =>
							alu_opp <= or8;
							alu_in8_a <= reg(REG_A);
							alu_in8_b <= regsel_0;
							cpu_state <= instr_decode2;
						
						when LDI_HL_A =>
							mem_address <= reg(REG_H) & reg(REG_L);
							mem_out <= reg(REG_A);
							mem_wren <= '1';
							
							alu_opp <= add16;
							alu_in16_a <= reg(REG_H) & reg(REG_L);
							if opcode_0(4) = '0' then
								alu_in16_b <= x"0001";
							else
								alu_in16_b <= x"FFFF";
							end if;

							cpu_state <= instr_decode2;
						
						when others =>
							cpu_state <= instr_decode2;
					end case?;

				when instr_decode2 =>
					pc := std_logic_vector(unsigned(pc) + 1);
					case? opcode_0 is

						when NOP =>
							cpu_state <= instr_fetch;

						when LD_B_N | LD_C_N | LD_D_N | LD_E_N | LD_H_N | LD_L_N | LD_A_N | JP_NN | JR_NZ | ADD_N | LD_RR_NN | LD_A16_SP =>
							mem_address <= pc;
							mem_wren <= '0';
							cpu_state <= param0_fetch;

						when ADD_HL_BC | ADD_HL_DE | ADD_HL_HL | ADD_HL_SP =>
							reg(REG_H) := alu_out16_o(15 downto 8);
							reg(REG_L) := alu_out16_o(7 downto 0);
							reg(REG_F)(7 downto 4) := alu_out8_f;
							wait_count <= x"4";
							cpu_state <= wait_state;
						
						when INC_BC =>
							reg(REG_B) := alu_out16_o(15 downto 8);
							reg(REG_C) := alu_out16_o(7 downto 0);
							wait_count <= x"4";
							cpu_state <= wait_state;
						
						when INC_DE =>
							reg(REG_D) := alu_out16_o(15 downto 8);
							reg(REG_E) := alu_out16_o(7 downto 0);
							wait_count <= x"4";
							cpu_state <= wait_state;
						
						when INC_HL =>
							reg(REG_H) := alu_out16_o(15 downto 8);
							reg(REG_L) := alu_out16_o(7 downto 0);
							wait_count <= x"4";
							cpu_state <= wait_state;
						
						when INC_SP =>
							sp := alu_out16_o;
							wait_count <= x"4";
							cpu_state <= wait_state;
						
						when ADD_A_B | ADD_A_C | ADD_A_D | ADD_A_E | ADD_A_H | ADD_A_L | ADD_A_A |
							  SUB_A_B | SUB_A_C | SUB_A_D | SUB_A_E | SUB_A_H | SUB_A_L | SUB_A_A | 
							  XOR_A_B | XOR_A_C | XOR_A_D | XOR_A_E | XOR_A_H | XOR_A_L | XOR_A_A | 
							  INC_B | INC_C | INC_D | INC_E | INC_H | INC_L | INC_A | 
							  OR_A_B | OR_A_C | OR_A_D | OR_A_E | OR_A_H | OR_A_L | OR_A_A =>
							reg(REG_A) := alu_out8_o;
							reg(REG_F)(7 downto 4) := alu_out8_f;
							cpu_state <= instr_fetch;

						when CP_A_B | CP_A_C | CP_A_D | CP_A_E | CP_A_H | CP_A_L | CP_A_A =>
							reg(REG_F)(7 downto 4) := alu_out8_f;
							cpu_state <= instr_fetch;

						when DEC_B | DEC_C | DEC_D | DEC_E | DEC_H | DEC_L | DEC_A =>
							reg(REG_A) := alu_out8_o;
							reg(REG_F)(7) := alu_out8_f(3);
							reg(REG_F)(6) := '1';
							reg(REG_F)(5 downto 4) := alu_out8_f(1 downto 0);
							cpu_state <= instr_fetch;

						when LD_A_A | LD_A_B | LD_A_C | LD_A_D | LD_A_E | LD_A_H | LD_A_L |
							  LD_B_A | LD_B_B | LD_B_C | LD_B_D | LD_B_E | LD_B_H | LD_B_L | 
							  LD_C_A | LD_c_B | LD_C_C | LD_C_D | LD_C_E | LD_C_H | LD_C_L | 
							  LD_D_A | LD_D_B | LD_D_C | LD_D_D | LD_D_E | LD_D_H | LD_D_L | 
							  LD_E_A | LD_E_B | LD_E_C | LD_E_D | LD_E_E | LD_E_H | LD_E_L | 
							  LD_H_A | LD_H_B | LD_H_C | LD_H_D | LD_H_E | LD_H_H | LD_H_L | 
							  LD_L_A | LD_L_B | LD_L_C | LD_L_D | LD_L_E | LD_L_H | LD_L_L =>
							reg(to_integer(unsigned(opcode_0(5 downto 3)))) := regsel_0;
							cpu_state <= instr_fetch;
						
						when LD_B_HL | LD_C_HL | LD_D_HL | LD_E_HL | LD_H_HL | LD_L_HL | LD_A_HL =>
							mem_address <= reg(REG_H) & reg(REG_L);
							mem_wren <= '0';
							cpu_state <= param0_fetch;
						
						when LD_HL_B | LD_HL_C | LD_HL_D | LD_HL_E | LD_HL_H | LD_HL_L | LD_HL_A =>
							mem_address <= reg(REG_H) & reg(REG_L);
							mem_out <= regsel_0;
							mem_wren <= '1';
							cpu_state <= wait_state;
							wait_count <= x"4";
						
						when LDI_HL_A =>
							reg(REG_H) := alu_out16_o(15 downto 8);
							reg(REG_L) := alu_out16_o(7 downto 0);
							cpu_state <= wait_state;
							wait_count <= x"4";
						
						when RRA =>
							reg(REG_A)(6 downto 0) := reg(REG_A)(7 downto 1);
							reg(REG_A)(7) := reg(REG_F)(4);
							cpu_state <= instr_fetch;

						when RLA =>
							reg(REG_A)(7 downto 1) := reg(REG_A)(6 downto 0);
							reg(REG_A)(0) := reg(REG_F)(4);
							cpu_state <= instr_fetch;

						when RRCA =>
							reg(REG_F)(4) := reg(REG_A)(0);
							reg(REG_A)(6 downto 0) := reg(REG_A)(7 downto 1);
							reg(REG_A)(7) := reg(REG_F)(4);
							cpu_state <= instr_fetch;

						when RLCA =>
							reg(REG_F)(4) := reg(REG_A)(7);
							reg(REG_A)(7 downto 1) := reg(REG_A)(6 downto 0);
							reg(REG_A)(0) := reg(REG_F)(4);
							cpu_state <= instr_fetch;
						

						when others =>
							cpu_state <= halt;
					end case?;
					

				/* STEP 3: Fetch the second opcode of the instruction */
				when param0_fetch =>
					cpu_state <= param0_fetch1;
				when param0_fetch1 =>
					cpu_state <= param0_decode1;


				/* STEP 4: Decode and execute the second opcode */
				when param0_decode1 =>
					opcode_1 := mem_in;
					case? opcode_0 is

						when ADD_N =>
							alu_opp <= add8;
							alu_in8_a <= reg(REG_A);
							alu_in8_b <= opcode_1;
							cpu_state <= param0_decode2;

						when others =>
							cpu_state <= param0_decode2;
					end case?;

				when param0_decode2 =>
					pc := std_logic_vector(unsigned(pc) + 1);
					case? opcode_0 is

						when JP_NN | LD_RR_NN | LD_A16_SP  =>
							mem_address <= pc;
							mem_wren <= '0';
							cpu_state <= param1_fetch;

						when JR_NZ =>
							if reg(REG_F)(7) = '0' then
								pc := pc + opcode_1;
								wait_count <= x"4";
								cpu_state <= wait_state;
							else
								cpu_state <= instr_fetch;
							end if;

						when LD_B_N | LD_C_N | LD_D_N | LD_E_N | LD_H_N | LD_L_N | LD_A_N |
							  LD_B_HL | LD_C_HL | LD_D_HL | LD_E_HL | LD_H_HL | LD_L_HL | LD_A_HL =>
							reg(to_integer(unsigned(opcode_0(5 downto 3)))) := mem_in;
							cpu_state <= instr_fetch;
						
						when ADD_N =>
							reg(REG_A) := alu_out8_o;
							reg(REG_F)(7 downto 4) := alu_out8_f;
							cpu_state <= instr_fetch;

						when others =>
							cpu_state <= halt;
					end case?;
				
				
				/* STEP 5: Fetch the second opcode of the instruction */
				when param1_fetch =>
					cpu_state <= param1_fetch1;
				when param1_fetch1 =>
					cpu_state <= param1_decode1;


				/* STEP 6: Decode and execute the third opcode */
				when param1_decode1 =>
					pc := std_logic_vector(unsigned(pc) + 1);
					opcode_1 := mem_in;

					case? opcode_0 is
					
						when LD_A16_SP =>
							mem_address <= opcode_1 & opcode_2;
							mem_out <= sp(7 downto 0);
							mem_wren <= '1';
							cpu_state <= param1_decode2;
					
						when others =>
							cpu_state <= param1_decode2;
					end case?;

				when param1_decode2 =>

					case? opcode_0 is

						when JP_NN =>
							pc(7 downto 0) := opcode_1;
							pc(15 downto 8) := opcode_1;
							wait_count <= x"4";
							cpu_state <= wait_state;

						when LD_RR_NN =>
							case opcode_0(5 downto 4) is
								when "00" =>
									reg(REG_B) := opcode_1;
									reg(REG_C) := opcode_1;
								when "01" =>
									reg(REG_D) := opcode_1;
									reg(REG_E) := opcode_1;
								when "10" =>
									reg(REG_H) := opcode_1;
									reg(REG_L) := opcode_1;
								when others =>
									sp := opcode_1 & opcode_1;
							end case;
							cpu_state <= instr_fetch;

						when LD_A16_SP =>
							mem_address <= (opcode_1 & opcode_2) + 1;
							mem_out <= sp(15 downto 8);
							mem_wren <= '1';
							wait_count <= x"8";
							cpu_state <= wait_state;

						when others =>
							cpu_state <= halt;
					end case?;


				/* STEP X: Arbitrary wait states to simulate exact cycles */
				when wait_state =>
					case wait_count is
						when x"1" =>
							cpu_state <= instr_fetch;
						when others =>
							wait_count <= wait_count - 1;
							cpu_state <= wait_state;
					end case;


				/* ERROR, cpu got in unknown state */	
				when others =>
					debug(35 downto 32) <= x"F";
					debug(31 downto 16) <= pc;
					debug(15 downto 8) <= opcode_0;
					debug(7 downto 0) <= opcode_1;
					cpu_state <= halt;
			end case;
		end if;
	end if;
end process;

end logic;
