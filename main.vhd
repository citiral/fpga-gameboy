library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.z80_pkg.all;

entity main is
	port(
		BTN       : in  std_logic_vector(1 downto 0);
		NRES      : in  std_logic;
		LED       : out std_logic_vector(3 downto 0);
		SEG       : out std_logic_vector(7 downto 0);
		DISP      : out std_logic_vector(3 downto 0);
		CLK_10MHz : in  std_logic;
		WS2812B   : out std_logic
	);
end main;

architecture logic of main is
	signal pc_in          : std_logic_vector(15 downto 0);
	signal pc_out         : std_logic_vector(15 downto 0);
	signal sp_in          : std_logic_vector(15 downto 0);
	signal sp_out         : std_logic_vector(15 downto 0);
	
	signal reg_in: registers;
	signal reg_out: registers;
	/*signal a_in          : std_logic_vector(7 downto 0);
	signal a_out         : std_logic_vector(7 downto 0);
	signal f_in          : std_logic_vector(7 downto 0);
	signal f_out         : std_logic_vector(7 downto 0);
	signal b_in          : std_logic_vector(7 downto 0);
	signal b_out         : std_logic_vector(7 downto 0);
	signal c_in          : std_logic_vector(7 downto 0);
	signal c_out         : std_logic_vector(7 downto 0);
	signal d_in          : std_logic_vector(7 downto 0);
	signal d_out         : std_logic_vector(7 downto 0);
	signal e_in          : std_logic_vector(7 downto 0);
	signal e_out         : std_logic_vector(7 downto 0);
	signal h_in          : std_logic_vector(7 downto 0);
	signal h_out         : std_logic_vector(7 downto 0);
	signal l_in          : std_logic_vector(7 downto 0);
	signal l_out         : std_logic_vector(7 downto 0);*/

	signal btn_debounced: std_logic_vector(1 downto 0);

	signal rst         : std_logic;
	signal clk_1kHz    : std_logic;
	
	signal mem_address: std_logic_vector(15 downto 0);
	signal mem_in:  std_logic_vector(7 downto 0);
	signal mem_out: std_logic_vector(7 downto 0);
	signal mem_wren: std_logic;
	
	signal debug: std_logic_vector(19 downto 0);
begin

	div1kHz : entity work.divider generic map(10000) port map(CLK_10MHz, '0', clk_1kHz);

	debouncer_0: entity work.pb_debouncer port map(CLK_10MHz, BTN(0), btn_debounced(0));
	debouncer_1: entity work.pb_debouncer port map(CLK_10MHz, BTN(1), btn_debounced(1));

	/*ereg_pc: entity work.z80_register_16 port map(CLK_10MHz, pc_out, pc_in);
	ereg_sp: entity work.z80_register_16 port map(CLK_10MHz, sp_out, sp_in);
	ereg_b: entity work.z80_register_8 port map(CLK_10MHz, reg_out(0), reg_in(0));
	ereg_c: entity work.z80_register_8 port map(CLK_10MHz, reg_out(1), reg_in(1));
	ereg_d: entity work.z80_register_8 port map(CLK_10MHz, reg_out(2), reg_in(2));
	ereg_e: entity work.z80_register_8 port map(CLK_10MHz, reg_out(3), reg_in(3));
	ereg_h: entity work.z80_register_8 port map(CLK_10MHz, reg_out(4), reg_in(4));
	ereg_l: entity work.z80_register_8 port map(CLK_10MHz, reg_out(5), reg_in(5));
	ereg_f: entity work.z80_register_8 port map(CLK_10MHz, reg_out(6), reg_in(6));
	ereg_a: entity work.z80_register_8 port map(CLK_10MHz, reg_out(7), reg_in(7));*/
	
	cpu: entity work.z80 port map(
		clk => CLK_10MHz,
		rst => not btn_debounced(0),

		/*pc_in  => pc_in,
		pc_out => pc_out,
		sp_in  => sp_in,
		sp_out => sp_out,

		reg_in => reg_in,
		reg_out => reg_out,*/

		mem_address => mem_address,
		mem_in      => mem_in,
		mem_out     => mem_out,
		mem_wren    => mem_wren,

		debug => debug
	);

	memory: entity work.z80_memory_controller port map(
		clk => CLK_10MHz,
		z80_address  => mem_address,
		z80_data_in  => mem_out,
		z80_wren     => mem_wren,
		z80_data_out => mem_in
	);

	LED <= not debug(19 downto 16);

	display: entity work.multi_display port map(
		num        => debug(15 downto 0),
		dots       => x"F",
		clk        => clk_1kHz,
		hex        => SEG,
		seg_enable => DISP
	);

	/*clk50Mhz : entity PLL_50 port map(CLK_10MHz, clk_50MHz);
	leddrv : entity work.WS2812B port map(
			R           => (others => '0'),
			G           => (others => '0'),
			B           => (others => '0'),
			CLOCK       => clk_50MHz,
			DATA_OUT    => WS2812B,
			FORCE_RESET => '0');*/
end;
