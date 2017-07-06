--Jelle Meeus E2
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY demux IS
PORT (EN,S :IN  std_logic;
      Y0,Y1    :OUT std_logic);
END demux;

ARCHITECTURE behavior OF demux IS
BEGIN

demux_gate: PROCESS (EN,S)
BEGIN
  IF (S = '0')
	THEN
	Y0 <= EN;
	Y1 <= '0';
  ELSIF (S = '1')
    THEN
	Y1 <= EN;
	Y0 <= '0';
  ELSE
	Y1 <= '0';
	Y0 <= '0';
  END IF;
END PROCESS demux_gate;

END behavior;
