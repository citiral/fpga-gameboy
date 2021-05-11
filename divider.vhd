library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;


entity divider is
  generic(div_by : natural := 16);      -- must be dividable by 2 !
  port(clk_in  : in    std_logic;
       rst     : in    std_logic;
       clk_out : inout std_logic);
end entity divider;

architecture counter of divider is
  constant count_top : natural := div_by / 2 - 1;
  constant bits      : natural := integer(ceil(log2(real(count_top + 1))));
  signal cnt         : unsigned(bits - 1 downto 0);
begin
  process(clk_in, rst)
  begin
    if rst = '1' then
      clk_out <= '0';
      cnt     <= (others => '0');
    elsif rising_edge(clk_in) then
      if cnt = 0 then
        cnt     <= to_unsigned(count_top, bits);
        clk_out <= not clk_out;
      else
        cnt <= cnt - 1;
      end if;
    end if;
  end process;
end architecture counter;
