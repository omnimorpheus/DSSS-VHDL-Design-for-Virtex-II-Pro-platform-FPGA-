--Jelle Meeus E2
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY binair2gray_test IS
END binair2gray_test;

ARCHITECTURE structural OF binair2gray_test IS 

-- Unit Under Test: uut
	COMPONENT binair2gray
	PORT (binair :IN  std_logic_vector(2 DOWNTO 0);
		  gray   :OUT std_logic_vector(2 DOWNTO 0));      
	END COMPONENT;

  FOR uut: binair2gray USE ENTITY work.binair2gray(behavior); 
	CONSTANT period : time := 100 ns;
    SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL binair   :  std_logic_vector(2 DOWNTO 0);
	SIGNAL gray   :  std_logic_vector(2 DOWNTO 0);
 
BEGIN
	uut : binair2gray PORT MAP(
		binair => binair,
		gray   => gray
	);

-- Test Bench: TVI-generator
   tb_gen : PROCESS
   VARIABLE tv : std_logic_vector(2 DOWNTO 0) := "000";
   BEGIN
   FOR i IN 0 TO 7
   LOOP
      binair <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;
   end_of_sim <= true;
   WAIT;
   END PROCESS tb_gen;
END structural;

