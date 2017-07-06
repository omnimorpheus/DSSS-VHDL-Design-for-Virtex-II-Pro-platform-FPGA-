
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY counter_test IS
END counter_test;

ARCHITECTURE structural OF counter_test IS 

-- Unit Under Test: uut
	COMPONENT counter
	PORT(clk      : IN std_logic;
		   rst_b    : IN std_logic;  
       en       : IN std_logic;
       p_data: IN std_logic_vector(3 DOWNTO 0);       
		   bincount : OUT std_logic_vector(3 DOWNTO 0));
	END COMPONENT;

  FOR uut : counter USE ENTITY work.counter(behavior);
 
	CONSTANT period : time := 100 ns;
  CONSTANT delay  : time :=  10 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL clk      : std_logic;
	SIGNAL rst_b    : std_logic;
  SIGNAL en       : std_logic;
	SIGNAL bincount : std_logic_vector(3 DOWNTO 0);
 
BEGIN
	uut: counter PORT MAP(
		clk      => clk,
		rst_b    => rst_b,
    en       => en,
		bincount => bincount);
		
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
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0));
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(1 DOWNTO 0))IS
     BEGIN
       rst_b <= stimvect(1);
       en  <= stimvect(0);
       WAIT FOR period;
     END testvector;
   BEGIN
--                r 
--                se
--                tn
      testvector("00");
      WAIT FOR delay;
      testvector("10");
      testvector("11");
      testvector("11");
      testvector("11");
      testvector("11");
      testvector("10");
      testvector("11");      
      WAIT FOR (5*period);
      end_of_sim <= true;
      WAIT;
   END PROCESS tb_gen;
END structural;