--Jelle Meeus E2
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY adres_dec_test IS
END adres_dec_test;

ARCHITECTURE structural OF adres_dec_test IS 

-- Unit Under Test: uut
	COMPONENT adres_dec
	PORT (adres : IN  std_logic_vector(15 DOWNTO 0);
      CE1_b   : OUT std_logic;
      CE2_b   : OUT std_logic);     
	END COMPONENT;

  FOR uut: adres_dec USE ENTITY work.adres_dec(behavior); 
	CONSTANT period : time := 100 ns;
    SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL adres   :  std_logic_vector(15 DOWNTO 0);
	SIGNAL CE1_b  :  std_logic;
	SIGNAL CE2_b   : std_logic;
 
BEGIN
	uut : adres_dec PORT MAP(
		adres 	=> adres,
		CE1_b   => CE1_b,
		CE2_b 	=>	CE2_b
	);

-- Test Bench: TVI-generator
  tb_gen : PROCESS
    VARIABLE tv : std_logic_vector(15 DOWNTO 0) := X"0000";
   BEGIN
   FOR i IN 0 TO 16*4096
   LOOP
      adres <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;
   end_of_sim <= true;
     WAIT;
  END PROCESS tb_gen;
END structural;



