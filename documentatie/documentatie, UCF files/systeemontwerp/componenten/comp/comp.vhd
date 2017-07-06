-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 11/03/2015
-- Revision   : version 1 - 18/03/2010 - Jelle Meeus
-- File       : comp.vhd
-----------------------------------------------------------------
-- Design: 
-- COMPARATOR
--
-- Description:
-- This entity/architecture pair is a COMPARATOR
-- with 2 binary inputs (A,B) and 2 binary outputs (LED) with
-- LED(0) as EQ and LED(1) as GT
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY comp IS
	GENERIC ( W : natural := 7 );
PORT (	A :IN  std_logic_vector( W DOWNTO 0);
		B :IN  std_logic_vector( W DOWNTO 0);	
		GT :OUT std_logic;	
		EQ  :OUT std_logic);
END comp;

ARCHITECTURE behavior OF comp IS
BEGIN
	GT <=	(A > B);
	EQ <=	(A = B);
END behavior;
