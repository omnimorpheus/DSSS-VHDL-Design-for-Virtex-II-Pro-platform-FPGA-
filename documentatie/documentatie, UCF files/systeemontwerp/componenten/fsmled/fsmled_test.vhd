LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY FSM_test IS
END FSM_test;

ARCHITECTURE structural OF FSM_test IS 

-- Unit Under Test: uut
	COMPONENT PED
	PORT (clk,SIG :IN  std_logic;
	  Ped :OUT std_logic);
	END COMPONENT;

  FOR uut: PED USE ENTITY work.PED(behavior);
 
	CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL clk,SIG,Pos_ed   :  std_logic;
 
	BEGIN
	uut : PED PORT MAP(
		clk   => clk,
		SIG   => SIG,
		Ped   => Pos_ed );
-- Test Bench: Clock-generator
	clock: PROCESS
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
    BEGIN     
      SIG <= '0';
	  WAIT FOR (0.3*period);
	  SIG <= '1';
	  WAIT FOR (0.6*period);
      SIG <= '0';
	  WAIT FOR (0.9*period);
	  SIG <= '1';
	  WAIT FOR (1.2*period);
	  SIG <= '0';
	  WAIT FOR (1.5*period);
	  SIG <= '1';
	  WAIT FOR (1.8*period);
      SIG <= '0';
	  WAIT FOR (2.1*period);
	  SIG <= '1';
      end_of_sim <= true;
      WAIT;
   END PROCESS tb_gen;
END structural;

