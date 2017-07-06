LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ShiftRegister_test IS
GENERIC (w: natural := 3);
END ShiftRegister_test;

ARCHITECTURE structural OF ShiftRegister_test IS 

-- Unit Under Test: uut
	COMPONENT ShiftRegister
	PORT (clk,SE,Ser_In,rst_b :IN  std_logic;
		  Par_out :OUT std_logic_vector((w-1) downto 0));
	END COMPONENT;

  FOR uut: ShiftRegister USE ENTITY work.ShiftRegister(behavior);
 
  CONSTANT period : time := 100 ns;
  SIGNAL   end_of_sim : boolean := false;

-- Interconnection (signals - ports)
	SIGNAL clk,SE,Ser_In,rst_b   :  std_logic;
	SIGNAL Par_out :  std_logic_vector((w-1) downto 0);
 
	BEGIN
	uut : ShiftRegister PORT MAP(
		clk   => clk,
		SE   => SE,
		rst_b  => rst_b,
		Ser_In => Ser_In,
		Par_out => Par_out);
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
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0));
   PROCEDURE testvector(CONSTANT stimvect : IN std_logic_vector(2 DOWNTO 0))IS
     BEGIN
       SE   <= stimvect(2);
       Ser_In  <= stimvect(1);
       rst_b  <= stimvect(0);
       WAIT FOR period;
     END testvector;
   BEGIN
      testvector("111");
	    WAIT FOR period*w;
	    testvector("000");
	    testvector("110");
	    testvector("011");
	    testvector("111");
	    testvector("101");
	    testvector("111");
	    testvector("101");
	    testvector("111");
      end_of_sim <= true;
      WAIT;
   END PROCESS tb_gen;
END structural;


