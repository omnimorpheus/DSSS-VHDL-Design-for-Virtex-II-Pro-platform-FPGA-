LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY rgs_test IS
GENERIC (w: natural := 3);
END rgs_test;

ARCHITECTURE structural OF rgs_test IS 

-- Unit Under Test: uut
	COMPONENT rgs
	PORT (clk:IN  std_logic;
			reg_in: IN std_logic_vector(3 DOWNTO 0);
		  reg_out :OUT std_logic_vector(15 downto 0));
	END COMPONENT;

  FOR uut: rgs USE ENTITY work.rgs(behavior);
 
  CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL clk:  std_logic;
	SIGNAL reg_in :  std_logic_vector(3 downto 0);
	SIGNAL reg_out :  std_logic_vector(15 downto 0);
 
	BEGIN
	uut : rgs PORT MAP(
		clk   => clk,
		reg_in => reg_in,
		reg_out => reg_out);
		
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
   VARIABLE tv : std_logic_vector(3 DOWNTO 0) := "000";
   BEGIN
   FOR i IN 0 TO 2**3-1
   LOOP
      par_in <= tv;
      tv := tv + 1;
      WAIT FOR period;
   END LOOP;
      WAIT;
   END PROCESS tb_gen;
END structural;


