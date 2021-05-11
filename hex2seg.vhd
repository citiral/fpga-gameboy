-- 7-seg display driver
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex2seg is
	port(
		num      : in  std_logic_vector(3 downto 0);
		dp       : in  std_logic;
		disp_seg : out std_logic_vector(7 downto 0)
	);
end entity;

architecture basic_disp of hex2seg is
	type seg_descr_type is array (0 to 15) of std_logic_vector(7 downto 0);
	constant seg_descr : seg_descr_type := (x"3f", x"06", x"5b", x"4f",
		                                    x"66", x"6d", x"7d", x"07",
		                                    x"7f", x"6f", x"77", x"7c",
		                                    x"39", x"5e", x"79", x"71");
begin
	disp_seg <= (not dp) & seg_descr(to_integer(unsigned(num)))(6 downto 0);
end architecture basic_disp;
