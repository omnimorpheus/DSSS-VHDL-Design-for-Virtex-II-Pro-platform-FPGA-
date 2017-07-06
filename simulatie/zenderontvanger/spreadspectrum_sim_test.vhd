
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity spreadspectrum_sim_test is
end spreadspectrum_sim_test;

architecture structural of spreadspectrum_sim_test is 

-- unit under test: uut

component spreadspectrum_sim is
port (
	clk_100mhz:in std_logic;
	rst:in std_logic;
	s0,s1:in std_logic;
	p :in std_logic_vector(1 downto 0);
	seven_segment_in: out std_logic_vector(6 downto 0);
	seven_segment_out: out std_logic_vector(6 downto 0));
end component;

  for uut : spreadspectrum_sim use entity work.spreadspectrum_sim(behavior);
 
	constant period : time := 100 ns;
	constant delay  : time :=  10 ns;
	signal   end_of_sim : boolean := false;

-- interconnection (signals - ports)
	signal clk   : std_logic;
	signal rst : std_logic;
	signal p: std_logic_vector(1 downto 0);
	signal s0, s1: std_logic;
	signal seven_segment_in, seven_segment_out: std_logic_vector(6 downto 0);
 
begin
	uut: spreadspectrum_sim port map(
		clk_100mhz     => clk,
		rst => rst,
		p => p,
		s0 => s0,
		s1 => s1,
		seven_segment_in => seven_segment_in,
		seven_segment_out => seven_segment_out);
		
-- test bench: clock-generator
   clock : process
   begin 
       clk <= '0';
       wait for period/32;
     loop
       clk <= '0';
       wait for period/32;
       clk <= '1';
       wait for period/32;
       exit when end_of_sim;
     end loop;
     wait;
   end process clock;
   
-- test bench: tvi-generator
   tb_gen : process
   procedure testvector(constant stimvect : in std_logic_vector(4 downto 0));
   procedure testvector(constant stimvect : in std_logic_vector(4 downto 0))is
     begin
	rst  <= stimvect(0);
    s0 <= stimvect(1);
	s1 <= stimvect(2);
	p <= stimvect(4 downto 3); -- ml1 01 ml2 10 gold 11
       wait for period;
     end testvector;
   begin
      testvector("01000"); --reset
	  wait for 5*period;
	  
	 --Up/down counter op x zetten (1010)
	for J in 1 to 6 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("01011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("01001");
		end loop;		 
	end loop;
	--
	
	--run	 ml1
	for J in 1 to 32 loop
		for I in 1 to 32 loop
			testvector("01001");
		end loop;
	end loop;	 	
	
	
	------- ml2
	  testvector("10000"); --reset
	  wait for 5*period;
	  
	 --Up/down counter op x zetten (1010)
	for J in 1 to 6 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("10011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("10001");
		end loop;		 
	end loop;
	--
	
	--run	 ml2
	for J in 1 to 32 loop
		for I in 1 to 32 loop
			testvector("10001");
		end loop;
	end loop;	
	------------ml2
	
	------- gold
	  testvector("11000"); --reset
	  wait for 5*period;
	  
	 --Up/down counter op x zetten (1010)
	for J in 1 to 6 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("11011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("11001");
		end loop;		 
	end loop;
	--
	
	--run	 gold
	for J in 1 to 32 loop
		for I in 1 to 32 loop
			testvector("11001");
		end loop;
	end loop;	
	------------gold
	
		------- none
	  testvector("00000"); --reset
	  wait for 5*period;
	  
	 --Up/down counter op x zetten (1010)
	for J in 1 to 6 loop   --x optellen    
		for I in 1 to 6*2 loop --1x UP indrukken
		testvector("00011");
		end loop;
		for I in 1 to 6*2 loop --1x UP loslaten
		testvector("00001");
		end loop;		 
	end loop;
	--
	
	--run	 none
	for J in 1 to 32 loop
		for I in 1 to 32 loop
			testvector("00001");
		end loop;
	end loop;	
	------------none
	
	
	
	  
      wait for (100*period);
      end_of_sim <= true;
      wait;
   end process tb_gen;
end structural;