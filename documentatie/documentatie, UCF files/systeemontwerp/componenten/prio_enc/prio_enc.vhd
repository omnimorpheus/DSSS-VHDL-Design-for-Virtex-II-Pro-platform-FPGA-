-----------------------------------------------------------------
-- Project    : Labo Digitale ELektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 11/03/2015
-- Revision   : version 1 - 18/03/2010 - Jelle Meeus
-- File       : prio_enc.vhd
-----------------------------------------------------------------
-- Design: 
-- PRIORITY ENCODER
--
-- Description:
-- This entity/architecture pair is a PRIORITY ENCODER
-- with 8 binary inputs (adres) and 3 binary outputs (LED).
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY prio_enc IS
PORT (adres :IN  std_logic_vector(7 DOWNTO 0);
      LED   :OUT std_logic_vector(2 DOWNTO 0));
END prio_enc;

ARCHITECTURE behavior OF prio_enc IS
BEGIN

prio_enc_gate: PROCESS (adres)
BEGIN
    IF (adres(7)='1') THEN
		led <= "111";
    ELSIF (adres(6)='1') THEN
		led <= "110";
    ELSIF (adres(5)='1') THEN
		led <= "101";
	ELSIF (adres(4)='1') THEN
		led <= "100";
	ELSIF (adres(3)='1') THEN
		led <= "011";
	ELSIF (adres(2)='1') THEN
		led <= "010";
	ELSIF (adres(1)='1') THEN
		led <= "001";
	ELSIF (adres(0)='1') THEN
		led <= "000";
	ELSE led<="000";
	end IF;
  END PROCESS prio_enc_gate;
END behavior;
