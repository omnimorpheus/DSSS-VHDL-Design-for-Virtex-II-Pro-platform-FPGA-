LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY comp_test IS
END comp_test;

ARCHITECTURE structural OF comp_test IS 

-- Unit Under Test: uut
	COMPONENT comp
	GENERIC ( W: natural)
	PORT (adres :IN  std_logic_vector(W DOWNTO 0);
      LED   :OUT std_logic;);     
	END COMPONENT;

  FOR uut: comp USE ENTITY work.comp(behavior); 
	CONSTANT period : time := 100 ns;
    SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL adres   :  std_logic_vector(7 DOWNTO 0);
	SIGNAL LED  :  std_logic;
 
BEGIN
	uut : comp 
	GENERIC MAP(
		W=>7	
	)
	PORT MAP(
		adres 	=> adres,
		LED   => LED
	);

-- Test Bench: TVI-generator
ttb_gen : PROCESS
    VARIABLE tv : std_logic_vector(7 DOWNTO 0) := X"00";
   BEGIN
   FOR i IN 0 TO 63
   LOOP
      adres <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;
   end_of_sim <= true;
     WAIT;
  END PROCESS tb_gen;
  END structural;



