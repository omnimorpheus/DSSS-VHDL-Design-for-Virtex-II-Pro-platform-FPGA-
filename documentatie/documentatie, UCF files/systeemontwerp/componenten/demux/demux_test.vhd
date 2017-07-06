--Jelle Meeus E2
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY demux_test IS
END demux_test;

ARCHITECTURE structural OF demux_test IS 

-- Unit Under Test: uut
	COMPONENT demux
	PORT( EN : IN std_logic;
		    S : IN std_logic;        
      		Y0 : OUT std_logic;
      		Y1 : OUT std_logic);
	END COMPONENT;

  FOR uut: demux USE ENTITY work.demux(behavior);
 
	CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL EN   :  std_logic;
	SIGNAL S   :  std_logic;
	SIGNAL Y0   :  std_logic;
	SIGNAL Y1   :  std_logic;
 
BEGIN
	uut : demux PORT MAP(
		EN   => EN,
		S    => S,
		Y0   => Y0,
		Y1   => Y1
	);

-- Test Bench: TVI-generator
   tb_gen : PROCESS
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0));
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS
     BEGIN
       EN   <=  stimvect(1);
       S    <=  stimvect(0);
       WAIT FOR period;
     END testvector;
   BEGIN     
--                ii
--                21  
      testvector("00");
      testvector("01");
      testvector("10");
      testvector("11");
      end_of_sim <= true;
      WAIT;
   END PROCESS tb_gen;
END structural;
