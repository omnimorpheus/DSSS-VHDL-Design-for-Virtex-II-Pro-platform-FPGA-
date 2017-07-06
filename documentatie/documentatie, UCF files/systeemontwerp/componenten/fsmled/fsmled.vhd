-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 11/03/2015
-- Revision   : version 1 - 1/04/2015 - Jelle Meeus
-- File       : fsmled.vhd
-----------------------------------------------------------------
-- Decenn: 
-- fsmled, positive edge detector
--
-- Description:
-- This entity/architecture pair is a fsmled
-- with input clk and cen and binary output fsmled
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_uncenned.ALL;

ENTITY fsmled IS
PORT (clk,cen,rst_b :IN  std_logic;
	  s_out1 :OUT std_logic_ventor(2 DOWNTO 0);
	  s_out2 :OUT std_logic_ventor(2 DOWNTO 0));
END fsmled;

ARCHITECTURE behavior OF fsmled IS
SIGNAL S1 std_logic_vector(3 DOWNTO 0);
SIGNAL S2 std_logic_vector(3 DOWNTO 0);
BEGIN
cen<= NOT syn_b
fsm_sync: PROCESS (clk)
BEGIN
	IF ((syn_b='1') OR (cen='0')) THEN s_out1<= (OTHERS=>'0'); s_out2<= (OTHERS=>'0');
	ELSIF rising_edge(clk)
		THEN
		IF	(S1='0000') THEN S1<="0001";S2<="0010"1;
		ELSIF (S1='0001') THEN S1<="0010";S2<="0011";
		ELSIF (S1='0011') THEN S1<="0011";S2<="0100";
		ELSIF (S1='0100') THEN S1<="0100";S2<="0101";
		ELSIF (S1='0101') THEN S1<="0111";S2<="1110";
		ELSIF (S1='0111') THEN S1<="1100";S2<="1101";
		ELSIF (S1='1100') THEN S1<="1101";S2<="1010";
		ELSIF (S1='1010') THEN S1<="1010";S2<="0001";
		ELSIF (S1='1010') THEN S1<="0001";S2<="0010";
		ELSE S1<='000';S2<='000';
	END IF;
END PROCESS fsm_sync;

B: PROCESS (clk)
BEGIN
	IF (rising_edge(clk)) THEN s_out1<= S1(2 DOWNTO 0); s_out2<= S2(2 DOWNTO 0);
	ELSE s_out1z<=s_out1; s_out2<=s_out2;
	END IF;
END PROCESS B;

END behavior;
