--Jelle Meeus E2
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY systeemontwerp_test IS
END systeemontwerp_test;

ARCHITECTURE structural OF systeemontwerp_test IS 

-- Unit Under Test: uut
	COMPONENT systeemontwerp
	PORT (S0,S1,S2:IN  std_logic;
	clk:IN std_logic;
	--P DPI switches x x x x
	P :IN std_logic_vector(3 DOWNTO 0);
	--LED_bar x x x x x x x x met 0000001 de onderste led
	LED_bar: OUT std_logic_vector(6 DOWNTO 0);
	--segment: 1 2 3 4 MS->LS
	seven_segment1: OUT std_logic_vector(6 DOWNTO 0);
	seven_segment2: OUT std_logic_vector(6 DOWNTO 0);
	seven_segment3: OUT std_logic_vector(6 DOWNTO 0);
	seven_segment4: OUT std_logic_vector(6 DOWNTO 0));     
	END COMPONENT;

  FOR uut: systeemontwerp USE ENTITY work.systeemontwerp(behavior); 
	CONSTANT period : time := 100 ns;
	CONSTANT delay  : time :=  10 ns;
    SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)]
	SIGNAL clk : std_logic;
	SIGNAL S0   :  std_logic;
	SIGNAL S1   :  std_logic;
	SIGNAL S2   :  std_logic;
	SIGNAL P   :  std_logic_vector(3 DOWNTO 0);
	SIGNAL LED_bar   :  std_logic_vector(6 DOWNTO 0);
	SIGNAL seven_segment1  :  std_logic_vector(6 DOWNTO 0);
	SIGNAL seven_segment2   :  std_logic_vector(6 DOWNTO 0);
	SIGNAL seven_segment3   :  std_logic_vector(6 DOWNTO 0);
	SIGNAL seven_segment4   :  std_logic_vector(6 DOWNTO 0);
 
BEGIN
	uut : systeemontwerp PORT MAP(
		clk => clk,
		S0 => S0,
		S1 => S1,
		S2 => S2,
		P   => P,
		LED_bar => LED_bar,
		seven_segment1 => seven_segment1,
		seven_segment2 => seven_segment2,
		seven_segment3 => seven_segment3,
		seven_segment4 => seven_segment4	
	);

-- Test Bench: clock-generator
   clock : PROCESS
   BEGIN 
       clk <= '0';
       WAIT FOR period/2;
     LOOP
       clk <= '0';
       WAIT FOR period/2;
       clk <= '1';
       WAIT FOR period/2;
       EXIT WHEN end_of_sim;
     END LOOP;
     WAIT;
   END PROCESS clock;

-- Test Bench: TVI-generator
   tb_gen : PROCESS
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0));
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0))IS
     BEGIN
		P<=X"A";
       S2 <= stimvect(2); --S2 enter, S0 reset, S1 up
       S1  <= stimvect(1);
	   S0  <= stimvect(0);
       WAIT FOR period;
     END testvector;
   BEGIN
      testvector("001");
      WAIT FOR delay;
      testvector("011");
	  
	  testvector("000");
	  testvector("011");
	  testvector("101"); --enter
	  testvector("011");
	  testvector("011");
	  testvector("001");
	  testvector("011");
	testvector("011");
	  testvector("001");
testvector("011");
	  testvector("001");
testvector("011");
	  testvector("001");
	  testvector("011");
	  testvector("011");
	  testvector("101"); --enter
	  testvector("011");
	  testvector("011");
testvector("011");
	  testvector("001");
testvector("011");
	  testvector("001");
testvector("011");
	  testvector("001");
	 testvector("011");
	  testvector("011");
	  testvector("101"); --enter
	  testvector("011");
	  testvector("011");
	  testvector("001");
	  testvector("011");
	  testvector("101"); --enter        
      WAIT FOR (5*period);
      end_of_sim <= true;
      WAIT;
   END PROCESS tb_gen;
END structural;