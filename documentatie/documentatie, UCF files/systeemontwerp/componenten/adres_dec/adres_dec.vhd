-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 4/03/2015
-- Revision   : version 1 - 11/03/2010 - Jelle Meeus
-- File       : adres_dec.vhd
-----------------------------------------------------------------
-- Design: 
-- ADRES DECODER
--
-- Description:
-- This entity/architecture pair is an ADRES_DECODER
-- with adres line inputs(adres) and low output memory block (
-- CE1_b CE2_b)
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY adres_dec IS
PORT (adres :IN  std_logic_vector(15 DOWNTO 0);
      CE1_b   :OUT std_logic;
      CE2_b   :OUT std_logic);
END adres_dec;

ARCHITECTURE behavior OF adres_dec IS
BEGIN

adres_dec_gate: PROCESS (adres)
BEGIN
	--VARIABLE MS: std_logic_vector(7 DOWNTO 0) := adres(15 DOWNTO 8);
	--adres range B800-C800 (+4K of $1000) en 0400-0C00 (+2K of $0800)
	
  
  --adres  range B800-C800 
 IF (	X"B8" <= adres(15 DOWNTO 8) AND adres(15 DOWNTO 8) < X"C8"	)
 THEN
	 CE1_b <= '1';
	 CE2_b <= '0';
	--adres  range 0400-0C00 
  ELSIF( X"04"  <= adres(15 DOWNTO 8)  AND adres(15 DOWNTO 8) < X"0C" )
  THEN
	 CE1_b <= '0';
	 CE2_b <= '1';
  ELSE
	 CE1_b <= '1';
	 CE2_b <= '1';
END IF;
END PROCESS adres_dec_gate;

END behavior;
