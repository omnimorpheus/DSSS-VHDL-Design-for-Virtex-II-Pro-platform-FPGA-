-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 25/03/2015
-- Revision   : version 1 - 25/03/2015 - Jelle Meeus
-- File       : MUX.vhd
-----------------------------------------------------------------
-- Design: 
-- SHIFT REGISTER
--
-- Description:
-- This entity/architecture pair is a MUX
-- with a,b,sel as inputs and outputs o_mux
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY MUX IS
PORT (a,b,sel :IN  std_logic;
	  o_mux :OUT std_logic);
END MUX;

ARCHITECTURE behavior OF MUX IS
BEGIN
PROCESS(a,b,sel)
  BEGIN
  IF sel = '0' THEN o_mux <= a;
  ELSIF sel = '1' THEN o_mux <= b;
  ELSE o_mux <= '0';
  END IF;
END PROCESS;
END behavior;
