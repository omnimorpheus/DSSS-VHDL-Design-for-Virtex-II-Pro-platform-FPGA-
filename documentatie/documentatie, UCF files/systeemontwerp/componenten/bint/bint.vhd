-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 11/03/2015
-- Revision   : version 1 - 18/03/2010 - Jelle Meeus
-- File       : modncounter.vhd
-----------------------------------------------------------------
-- Design: 
-- MODNCOUNTER
--
-- Description:
-- This entity/architecture pair is a MODULO N COUNTER
-- clk,reset and count enable as inputs, led_ext and tc
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ModNCounter IS
GENERIC (w: natural := 4);
PORT (clk,cen,rst_b :IN  std_logic;
      p_load :IN std_logic_vector(w downto 0);
	  tc :OUT std_logic;
	t_out:OUT std_logic_vector(w downto 0));
END ModNCounter;

ARCHITECTURE behavior OF ModNCounter IS
SIGNAL count: std_logic_vector(w downto 0);
BEGIN
t_out => count;
ModNCounter_gate: PROCESS (clk)
BEGIN
	IF rising_edge(clk) 
	THEN
		IF rst_b = '0'
			THEN count <= p_load;
		ELSIF cen = '1'
			THEN 
				IF (count = (2**w)-1) THEN count <= p_load;
				ELSE count <= count + 1;
				END IF;
		END IF;
	END IF;  
	IF (count = (OTHERS=>'1')) 
    THEN tc <= '1';
  ElSE tc <= '0';
  END IF;
END PROcenSS ModNCounter_gate;

END behavior;
