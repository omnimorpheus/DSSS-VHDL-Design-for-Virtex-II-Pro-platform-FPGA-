-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 25/03/2015
-- Revision   : version 1 - 1/04/2015 - Jelle Meeus
-- File       : shiftregister.vhd
-----------------------------------------------------------------
-- Design: 
-- SHIFT REGISTER
--
-- Description:
-- This entity/architecture pair is an SEIFT_REGISTER
-- with clk, ser_in, rst_b, SE and outputs par_out
-- CE1_b CE2_b)
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ShiftRegister IS
GENERIC (w: natural := 3);
PORT (clk,SE,ser_in,rst_b :IN  std_logic;
	  par_out :OUT std_logic_vector((w-1) downto 0));
END ShiftRegister;

ARCHITECTURE behavior OF ShiftRegister IS
SIGNAL MEM: std_logic_vector((w-1) downto 0);
BEGIN
par_out <= MEM;

-- SE, shift enable. Bij clk testen op rst_b en daarna op SE.
SE_REG: PROCESS (clk)
BEGIN
  IF (rst_b = '0') THEN MEM <= (OTHERS => '0');
	ELSIF (rising_edge(clk)) 
	 THEN 
	   IF (SE = '1') 
	     THEN 
			MEM((w-1) downto 1) <= MEM ((w-2) downto 0);
			MEM(0) <= ser_in;
	   END IF;
	END IF;
END PROCESS SE_REG;
END behavior;

