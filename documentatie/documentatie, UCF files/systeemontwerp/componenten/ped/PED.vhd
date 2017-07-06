LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY PED IS
PORT (clk,SIG :IN  std_logic;
	  PED :OUT std_logic);
END PED;

ARCHITECTURE behavior OF PED IS
SIGNAL count: std_logic;
SIGNAL ingang: std_logic;
BEGIN

ingang <= (NOT(count)) AND SIG;

FF1: PROCESS (clk)
BEGIN
	IF (rising_edge(clk)) THEN count <= SIG;
	END IF;
END PROCESS FF1;

FF2: PROCESS (clk)
BEGIN
	IF (rising_edge(clk)) THEN PED <= ingang;
	END IF;
END PROCESS FF2;

END behavior;
