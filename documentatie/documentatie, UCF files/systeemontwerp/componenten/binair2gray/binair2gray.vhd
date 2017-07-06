-----------------------------------------------------------------
-- Project    : Labo Digitale ELektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 4/03/2015
-- Revision   : version 1 - 11/03/2010 - Jelle Meeus
-- File       : binair2gray.vhd
-----------------------------------------------------------------
-- Design: 
-- BINARY TO GREY 
--
-- Description:
-- This entity/architecture pair is a BINARY TO GREY converter
-- with binary inputs (binair) and gray code output (gray).
-----------------------------------------------------------------

--Jelle Meeus E2
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY binair2gray IS
PORT (binair :IN  std_logic_vector(2 DOWNTO 0);
      gray   :OUT std_logic_vector(2 DOWNTO 0));
END binair2gray;

ARCHITECTURE behavior OF binair2gray IS
BEGIN
pb: PROCESS (binair)
BEGIN
  CASE binair IS
    WHEN "000" => gray <= "000";
    WHEN "001" => gray <= "001";
    WHEN "010" => gray <= "011";
    WHEN "011" => gray <= "010";
    WHEN "100" => gray <= "110";
    WHEN "101" => gray <= "111";
    WHEN "110" => gray <= "101";
    WHEN "111" => gray <= "100";
    WHEN OTHERS => gray <= "000";
  END CASE;
END PROCESS pb;
END behavior;
