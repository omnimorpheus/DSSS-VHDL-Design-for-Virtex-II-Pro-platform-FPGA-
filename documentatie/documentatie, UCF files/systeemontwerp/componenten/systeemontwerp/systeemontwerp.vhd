-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 4/03/2015
-- Revision   : version 1 - 11/03/2010 - Jelle Meeus
-- File       : systeemontwerp.vhd
-----------------------------------------------------------------
-- Design: 
-- SYSTEEMONTWERP 
--
-- Description:
-- This entity/architecture pair is a KEYCODE/LOCK WITH LEDBAR
-- /DPI SWITCHES
--
-- INPUTS: 3x buttons; S0 reset, S1 up, S2 enter; 3x DPI switches p
--
--OUTPUTS: LED_bar , 4x seven_seg(x)
-----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY systeemontwerp IS
PORT (
	clk:IN std_logic;
	S0,S1,S2:IN  std_logic;
	--P DPI switches x x x x
	P :IN std_logic_vector(3 DOWNTO 0);
	--LED_bar x x x x x x x x met 0000001 de onderste led
	LED_bar: OUT std_logic_vector(6 DOWNTO 0);
	--segment: 1 2 3 4 MS->LS
	seven_segment1: OUT std_logic_vector(6 DOWNTO 0);
	seven_segment2: OUT std_logic_vector(6 DOWNTO 0);
	seven_segment3: OUT std_logic_vector(6 DOWNTO 0);
	seven_segment4: OUT std_logic_vector(6 DOWNTO 0));
END systeemontwerp;

ARCHITECTURE behavior OF systeemontwerp IS

-----------------------------------------------------------------
-- 
-- ALLE SIGNALEN
--
-----------------------------------------------------------------

-- [1][1] S1 en S2 extern PED
	SIGNAL PED1: std_logic; --OUT
	SIGNAL SIG1: std_logic; --IN
		--[1[1] intern 	
		SIGNAL countb1: std_logic;
		SIGNAL ingang1: std_logic;
		
-- [1][2] S1 en S2 extern PED
	SIGNAL PED2: std_logic; --OUT
	SIGNAL SIG2: std_logic; --IN
		--[1][2] intern 	
		SIGNAL countb2: std_logic;
		SIGNAL ingang2: std_logic;
-- [2] OR1 signaal
	SIGNAL OR1: std_logic; --OUT

-- [3] 4MOD TELLER
	SIGNAL rst_b1: std_logic; --IN
	SIGNAL cen1: std_logic; --IN
	SIGNAL t_out1: std_logic_vector(3 DOWNTO 0); -- OUT
	--[3] intern
		SIGNAL count1: std_logic_vector(3 DOWNTO 0);
		
-- [4] Schuifregister
	--CONSTANT w: natural:=12
	SIGNAL SE: std_logic; --IN
	SIGNAL rst_b2: std_logic; --IN
	SIGNAL ser_in: std_logic_vector(3 DOWNTO 0); --IN
	SIGNAL par_out: std_logic_vector(11 DOWNTO 0); --OUT
	--[4] intern
		SIGNAL MEM: std_logic_vector(15 downto 0);
		
-- [5] Comparator
	SIGNAL A: std_logic_vector(3 DOWNTO 0); --IN
	SIGNAL B: std_logic_vector(11 DOWNTO 0); --IN
	SIGNAL EQ: std_logic; --OUT
		--[5] intern
		SIGNAL AI: std_logic_vector(7 DOWNTO 0);

-- [6] 24MOD TELLER
	SIGNAL rst_b3: std_logic; --IN
	SIGNAL cen2: std_logic; --IN
	SIGNAL tc2: std_logic; -- OUT
	--[6] intern
		SIGNAL count2: std_logic_vector(3 DOWNTO 0);	
		
-- [7] Finitestate machine FSM
	SIGNAL cen3: std_logic; --IN
	SIGNAL rst_b4: std_logic; --IN
	SIGNAL s_out1: std_logic_vector(2 DOWNTO 0); --OUT
	SIGNAL s_out2: std_logic_vector(2 DOWNTO 0); --OUT
		--[7] intern
		SIGNAL FS1: std_logic_vector(3 DOWNTO 0); 
		SIGNAL FS2: std_logic_vector(3 DOWNTO 0);
		
-- [8][1] bin2led 1
	SIGNAL bin11 : std_logic_vector(2 downto 0); --IN
	SIGNAL bin_led1 : std_logic_vector(6 downto 0); --OUT

-- [8][2] bin2led 2
	SIGNAL bin12 : std_logic_vector(2 downto 0); --IN
	SIGNAL bin_led2 : std_logic_vector(6 downto 0); --OUT

-- [9] OR2 signaal
	SIGNAL OR2: std_logic_vector(6 downto 0); --OUT
	
-- [10] OR2 to led_bar

-- [11][1] bin2segment 1
	SIGNAL bin1: std_logic_vector(3 downto 0); --IN
	SIGNAL seven_seg1: std_logic_vector(6 downto 0); --OUT

-- [11][2] bin2segment 2
	SIGNAL bin2: std_logic_vector(3 downto 0); --IN
	SIGNAL seven_seg2: std_logic_vector(6 downto 0); --OUT

-- [11][3] bin2segment 3
	SIGNAL bin3: std_logic_vector(3 downto 0); --IN
	SIGNAL seven_seg3: std_logic_vector(6 downto 0); --OUT
	
-- [11][4] bin2segment 4
	SIGNAL bin4: std_logic_vector(3 downto 0); --IN
	SIGNAL seven_seg4: std_logic_vector(6 downto 0); --OUT
	
-- [12] seven_segx to OUTPUT 7segment display
	
	
-------------------------

BEGIN
-----------------------------------------------------------------
-- 
-- [1][1] S2 doorheen PED1
--		
-----------------------------------------------------------------
	SIG1<=S2;	
	ingang1 <= (NOT(countb1)) AND SIG1;
	FF11: PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN countb1 <= SIG1;
		END IF;
	END PROCESS FF11;

	FF21: PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN PED1 <= ingang1;
		END IF;
	END PROCESS FF21;
	
-----------------------------------------------------------------
-- 
-- [1][2] S1 doorheen PED2
--		
-----------------------------------------------------------------
	SIG2 <= S1;
	
	ingang2 <= (NOT(countb2)) AND SIG2;
	FF12: PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN countb2 <= SIG2;
		END IF;
	END PROCESS FF12;

	FF22: PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN PED2 <= ingang2;
		END IF;
	END PROCESS FF22;

-----------------------------------------------------------------
-- 
-- [2] OR-poort S0 en PED1
--		
-----------------------------------------------------------------
OR1 <= (S0 OR PED1);
-----------------------------------------------------------------
-- 
-- [3] 4MOD TELLER
--		
-----------------------------------------------------------------
rst_b1 <= OR1;
cen1 <= PED2;

t_out1 <= count1;
count_sync1 : PROCESS (clk)
  BEGIN
	IF rising_edge(clk)
	THEN
		IF (rst_b1='0')
		THEN count1 <= (OTHERS => '0');
		ELSIF (cen1 = '1')
		THEN count1 <= count1 + '1';
		ELSE
		count1<=count1;
		END IF;
	END IF;
END PROCESS count_sync1;
-----------------------------------------------------------------
-- 
-- [4] Schuifregister
--		
-----------------------------------------------------------------
rst_b2<=S0;
ser_in<=t_out1;
SE<=PED1;

Par_out <= MEM(15 DOWNTO 4);
SE_REG: PROCESS (clk)
BEGIN
  IF (rst_b2 = '0') THEN MEM <= (OTHERS => '0');
	ELSIF (rising_edge(clk)) 
	 THEN 
	   IF (SE = '1') 
	     THEN 
			MEM(15 DOWNTO 4) <= MEM (11 DOWNTO 0);
			MEM(3 DOWNTO 0) <= ser_in;
	   END IF;
	END IF;
END PROCESS SE_REG;

-----------------------------------------------------------------
-- 
-- [5] Comparator
--		
-----------------------------------------------------------------
AI <= X"9E"; --code is p9E
cmp_comb : PROCESS (A,B)
BEGIN
	IF ( (A&AI) =B ) THEN EQ<='1';
	ELSE EQ<='0';     
	END IF;
END PROCESS cmp_comb;

-----------------------------------------------------------------
-- 
-- [6] 24MOD TELLER
--		
-----------------------------------------------------------------
cen2 <= EQ;
rst_b3 <= EQ; --wnr EQ=0, resetten. 

count_sync2 : PROCESS (clk)
  BEGIN
	IF rising_edge(clk)
	THEN
		IF (rst_b3='0')
		THEN count2 <= (OTHERS => '0');
		ELSIF (cen2 = '1')
		THEN count2 <= count2 + '1';
		ELSE
		count2<=count2;
		END IF;
	END IF;
END PROCESS count_sync2;
count_comb2 : PROCESS (count2)
BEGIN
	IF (count2=((2**24)-1)) THEN tc2<='1';
	ELSE tc2<='0';     
	END IF;
END PROCESS count_comb2;

-----------------------------------------------------------------
-- 
-- [7] finite state machine
--		
-----------------------------------------------------------------
fsm_sync: PROCESS (clk)
BEGIN
	IF (rst_b4='0') THEN FS1<= (OTHERS=>'0'); FS2<= (OTHERS=>'0');
	ELSIF rising_edge(clk)
		THEN
			IF (cen3='1') THEN
				IF	(FS1="0000") THEN FS1<="0001";FS2<="0010";
				ELSIF (FS1="000") THEN FS1<="0010";FS2<="0011";
				ELSIF (FS1="0011") THEN FS1<="0011";FS2<="0100";
				ELSIF (FS1="0100") THEN FS1<="0100";FS2<="0101";
				ELSIF (FS1="0101") THEN FS1<="0111";FS2<="1110";
				ELSIF (FS1="0111") THEN FS1<="1100";FS2<="1101";
				ELSIF (FS1="1100") THEN FS1<="1101";FS2<="1010";
				ELSIF (FS1="1010") THEN FS1<="1010";FS2<="0001";
				ELSIF (FS1="1010") THEN FS1<="0001";FS2<="0010";
				ELSE FS1<="0000";FS2<="0000";
				END IF;
			ELSE FS1<=FS1;FS2<=FS2;
			END IF;
			s_out1<= FS1(2 DOWNTO 0); s_out2<= FS2(2 DOWNTO 0);
	ELSE s_out1<=s_out1; s_out2<=s_out2;
	END IF;
END PROCESS fsm_sync;

-----------------------------------------------------------------
-- 
-- [8][1] bin2led 1
--		
-----------------------------------------------------------------
bin11<=s_out1;

PROCESS(bin1)
BEGIN
CASE bin11 IS
	WHEN "001" => bin_led1 <= "0000001";
	WHEN "010" => bin_led1 <= "0000010";
	WHEN "011" => bin_led1 <= "0000100";
	WHEN "100" => bin_led1 <= "0001000";
	WHEN "101" => bin_led1 <= "0010000";
	WHEN "110" => bin_led1 <= "0100000";
	WHEN "111" => bin_led1 <= "1000000";
	WHEN OTHERS => bin_led1 <= "0000000";
END CASE;
END PROCESS;


-----------------------------------------------------------------
-- 
-- [8][2] bin2led 2
--		
-----------------------------------------------------------------
bin12<=s_out2;

PROCESS(bin12)  
BEGIN
CASE bin12 IS
	WHEN "001" => bin_led2 <= "0000001";
	WHEN "010" => bin_led2 <= "0000010";
	WHEN "011" => bin_led2 <= "0000100";
	WHEN "100" => bin_led2 <= "0001000";
	WHEN "101" => bin_led2 <= "0010000";
	WHEN "110" => bin_led2 <= "0100000";
	WHEN "111" => bin_led2 <= "1000000";
	WHEN OTHERS => bin_led2 <= "0000000";
END CASE;
END PROCESS;

-----------------------------------------------------------------
-- 
-- [9] OR-poort bin_led1 and bin_led2
--		
-----------------------------------------------------------------
OR2 <= (bin_led1 OR bin_led2);
-----------------------------------------------------------------
-- 
-- [10] OR2 to OUTPUT signal led_bar
--		
-----------------------------------------------------------------
LED_bar <= OR2;

-----------------------------------------------------------------
-- 
-- [11][1] bin2segment 1
--		
-----------------------------------------------------------------
bin1<= par_out(11 DOWNTO 8);

PROCESS(bin1)  
BEGIN
CASE bin1 IS
	WHEN "0000" => seven_seg1 <= "1111110";
	WHEN "0001" => seven_seg1 <= "0110000";
	WHEN "0010" => seven_seg1 <= "1101101";
	WHEN "0011" => seven_seg1 <= "1111001";
	WHEN "0100" => seven_seg1 <= "0110011";
	WHEN "0101" => seven_seg1 <= "1011011";
	WHEN "0110" => seven_seg1 <= "1011111";
	WHEN "0111" => seven_seg1 <= "1110000";
	WHEN "1000" => seven_seg1 <= "1111111";
	WHEN "1001" => seven_seg1 <= "1111011";
	WHEN "1010" => seven_seg1 <= "1110111";
	WHEN "1011" => seven_seg1 <= "0011111";
	WHEN "1100" => seven_seg1 <= "1001110";
	WHEN "1101" => seven_seg1 <= "0111101";
	WHEN "1110" => seven_seg1 <= "1001111";
	WHEN "1111" => seven_seg1 <= "1000111";
	WHEN OTHERS => seven_seg1 <= "0000000";
END CASE;
END PROCESS;

-----------------------------------------------------------------
-- 
-- [11][2] bin2segment 2
--		
-----------------------------------------------------------------
bin2<= par_out(7 DOWNTO 4);

PROCESS(bin2)  
BEGIN
CASE bin2 IS
	WHEN "0000" => seven_seg2 <= "1111110";
	WHEN "0001" => seven_seg2 <= "0110000";
	WHEN "0010" => seven_seg2 <= "1101101";
	WHEN "0011" => seven_seg2 <= "1111001";
	WHEN "0100" => seven_seg2 <= "0110011";
	WHEN "0101" => seven_seg2 <= "1011011";
	WHEN "0110" => seven_seg2 <= "1011111";
	WHEN "0111" => seven_seg2 <= "1110000";
	WHEN "1000" => seven_seg2 <= "1111111";
	WHEN "1001" => seven_seg2 <= "1111011";
	WHEN "1010" => seven_seg2 <= "1110111";
	WHEN "1011" => seven_seg2 <= "0011111";
	WHEN "1100" => seven_seg2 <= "1001110";
	WHEN "1101" => seven_seg2 <= "0111101";
	WHEN "1110" => seven_seg2 <= "1001111";
	WHEN "1111" => seven_seg2 <= "1000111";
	WHEN OTHERS => seven_seg2 <= "0000000";
END CASE;
END PROCESS;

-----------------------------------------------------------------
-- 
-- [11][3] bin2segment 3
--		
-----------------------------------------------------------------
bin3<= par_out(3 DOWNTO 0);

PROCESS(bin3)  
BEGIN
CASE bin3 IS
	WHEN "0000" => seven_seg3 <= "1111110";
	WHEN "0001" => seven_seg3 <= "0110000";
	WHEN "0010" => seven_seg3 <= "1101101";
	WHEN "0011" => seven_seg3 <= "1111001";
	WHEN "0100" => seven_seg3 <= "0110011";
	WHEN "0101" => seven_seg3 <= "1011011";
	WHEN "0110" => seven_seg3 <= "1011111";
	WHEN "0111" => seven_seg3 <= "1110000";
	WHEN "1000" => seven_seg3 <= "1111111";
	WHEN "1001" => seven_seg3 <= "1111011";
	WHEN "1010" => seven_seg3 <= "1110111";
	WHEN "1011" => seven_seg3 <= "0011111";
	WHEN "1100" => seven_seg3 <= "1001110";
	WHEN "1101" => seven_seg3 <= "0111101";
	WHEN "1110" => seven_seg3 <= "1001111";
	WHEN "1111" => seven_seg3 <= "1000111";
	WHEN OTHERS => seven_seg3 <= "0000000";
END CASE;
END PROCESS;

-----------------------------------------------------------------
-- 
-- [11][4] bin2segment 4
--		
-----------------------------------------------------------------
bin4<=t_out1;

PROCESS(bin4)  
BEGIN
CASE bin4 IS
	WHEN "0000" => seven_seg4 <= "1111110";
	WHEN "0001" => seven_seg4 <= "0110000";
	WHEN "0010" => seven_seg4 <= "1101101";
	WHEN "0011" => seven_seg4 <= "1111001";
	WHEN "0100" => seven_seg4 <= "0110011";
	WHEN "0101" => seven_seg4 <= "1011011";
	WHEN "0110" => seven_seg4 <= "1011111";
	WHEN "0111" => seven_seg4 <= "1110000";
	WHEN "1000" => seven_seg4 <= "1111111";
	WHEN "1001" => seven_seg4 <= "1111011";
	WHEN "1010" => seven_seg4 <= "1110111";
	WHEN "1011" => seven_seg4 <= "0011111";
	WHEN "1100" => seven_seg4 <= "1001110";
	WHEN "1101" => seven_seg4 <= "0111101";
	WHEN "1110" => seven_seg4 <= "1001111";
	WHEN "1111" => seven_seg4 <= "1000111";
	WHEN OTHERS => seven_seg4 <= "0000000";
END CASE;
END PROCESS;

-----------------------------------------------------------------
-- 
-- [12] seven_segx to OUTPUT 7segment display
--		
-----------------------------------------------------------------
seven_segment1 <= seven_seg1;
seven_segment2 <= seven_seg2;
seven_segment3 <= seven_seg3;
seven_segment4 <= seven_seg4;

-------------------------------------
END behavior;