
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY prio_enc_test IS
END prio_enc_test;

ARCHITECTURE structural OF prio_enc_test IS 

-- Unit Under Test: uut
	COMPONENT prio_enc
	PORT (adres :IN  std_logic_vector(7 DOWNTO 0);
      LED   :OUT std_logic_vector(2 DOWNTO 0));     
	END COMPONENT;

  FOR uut: prio_enc USE ENTITY work.prio_enc(behavior); 
    
	CONSTANT period : time := 100 ns;
    SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL adres   :  std_logic_vector(7 DOWNTO 0);
	SIGNAL LED  :  std_logic_vector(2 DOWNTO 0);
 
BEGIN
	uut : prio_enc PORT MAP(
		adres 	=> adres,
		LED   => LED
	);

-- Test Bench: TVI-generator
  tb_gen: PROCESS 
  VARIABLE tv : std_logic_vector(7 DOWNTO 0) := X"00";
   BEGIN
   FOR i IN 0 TO 255
   LOOP
      adres <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;   
   end_of_sim <= true;
   WAIT;
   END PROCESS tb_gen;
END structural;



