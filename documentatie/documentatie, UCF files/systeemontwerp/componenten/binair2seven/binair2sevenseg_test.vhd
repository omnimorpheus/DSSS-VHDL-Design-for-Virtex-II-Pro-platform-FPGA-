LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY binair2sevenseg_test IS
END binair2sevenseg_test;

ARCHITECTURE structural OF binair2sevenseg_test IS 

-- Unit Under Test: uut
	COMPONENT binair2sevenseg
	PORT (bin :IN  std_logic_vector(3 DOWNTO 0);
      seven_seg  :OUT std_logic_vector(6 DOWNTO 0));
      
	END COMPONENT;

  FOR uut: binair2sevenseg USE ENTITY work.binair2sevenseg(behavior);
 
	CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL bin   :  std_logic_vector(3 DOWNTO 0);
	SIGNAL seven_seg   :  std_logic_vector(6 DOWNTO 0);
	
 
BEGIN
	uut : binair2sevenseg PORT MAP(
		bin   => bin,
		seven_seg   => seven_seg);

-- Test Bench: TVI-generator
   tb_gen : PROCESS
   VARIABLE tv : std_logic_vector(3 DOWNTO 0) := "0000";
   BEGIN
   FOR i IN 0 TO 15
   LOOP
      bin <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;
   end_of_sim <= true;
   WAIT;
   END PROCESS tb_gen;
END structural;
