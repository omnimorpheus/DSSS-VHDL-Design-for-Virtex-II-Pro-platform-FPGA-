LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX_test IS
END MUX_test;

ARCHITECTURE structural OF MUX_test IS 

-- Unit Under Test: uut
	COMPONENT MUX
	PORT (a,b,sel :IN  std_logic;
	  o_mux :OUT std_logic);
	END COMPONENT;

  FOR uut: MUX USE ENTITY work.MUX(behavior);
 
	CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL a   :  std_logic;
	SIGNAL b :  std_logic;
	SIGNAL sel :  std_logic;
	SIGNAL o_mux   :  std_logic;	
 
BEGIN
	uut : MUX PORT MAP(
	a   => a,
	b   => b,
	sel   => sel,	
	o_mux   => o_mux);

-- Test Bench: TVI-generator
   tb_gen : PROCESS
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0));
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0))IS
     BEGIN
       a   <= stimvect(2);
       b   <= stimvect(1);
       sel  <= stimvect(0);
       WAIT FOR period;
     END testvector;
   VARIABLE i_v : std_logic_vector(2 DOWNTO 0) := "000";
   BEGIN
   FOR i IN 0 TO 7
	   LOOP
		  testvector(i_v);
		  i_v := i_v + 1;
		  WAIT FOR period;
   END LOOP;
   end_of_sim <= true;
   WAIT;
   END PROCESS tb_gen;
END structural;

