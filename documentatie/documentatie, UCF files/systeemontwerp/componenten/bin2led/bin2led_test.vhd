LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY bin2led_test IS
END bin2led_test;

ARCHITECTURE structural OF bin2led_test IS 

-- Unit Under Test: uut
	COMPONENT bin2led
	PORT (bin :IN  std_logic_vector(2 DOWNTO 0);
      bin_led  :OUT std_logic_vector(6 DOWNTO 0));
      
	END COMPONENT;

  FOR uut: bin2led USE ENTITY work.bin2led(behavior);
 
	CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL bin   :  std_logic_vector(2 DOWNTO 0);
	SIGNAL bin_led   :  std_logic_vector(6 DOWNTO 0);
	
 
BEGIN
	uut : bin2led PORT MAP(
		bin   => bin,
		bin_led   => bin_led);

-- Test Bench: TVI-generator
   tb_gen : PROCESS
   VARIABLE tv : std_logic_vector(2 DOWNTO 0) := "000";
   BEGIN
   FOR i IN 0 TO (2**3)-1
   LOOP
      bin <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;
   end_of_sim <= true;
   WAIT;
   END PROCESS tb_gen;
END structural;
