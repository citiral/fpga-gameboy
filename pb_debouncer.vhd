LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY pb_debouncer IS
  GENERIC(
    counter_size  :  INTEGER := 17); 
  PORT(
    clk     : IN  STD_LOGIC;
    button  : IN  STD_LOGIC;
    debounced_o  : OUT STD_LOGIC);
END pb_debouncer;

ARCHITECTURE logic OF pb_debouncer IS
  SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL counter_set : STD_LOGIC;
  SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0');
BEGIN

  counter_set <= flipflops(0) xor flipflops(1);
  
  PROCESS(clk)
  BEGIN
    IF(clk'EVENT and clk = '1') THEN
      flipflops(0) <= button;
      flipflops(1) <= flipflops(0);
      IF(counter_set = '1') THEN
        counter_out <= (OTHERS => '0');
      ELSIF(counter_out(counter_size) = '0') THEN
        counter_out <= counter_out + 1;
      ELSE
        debounced_o <= flipflops(1);
      END IF;    
    END IF;
  END PROCESS;
END logic;
