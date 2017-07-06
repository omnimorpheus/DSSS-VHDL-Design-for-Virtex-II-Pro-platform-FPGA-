-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 25/03/2015
-- Revision   : version 1 - 1/04/2015 - Jelle Meeus
-- File       : bin2led.vhd
-----------------------------------------------------------------
-- Design: 
-- bin2led
--
-- Description:
-- This entity/architecture pair is a bin2led converter
-- with input bin and output bin_led
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY bin2led IS
PORT (bin :IN  std_logic_vector(2 downto 0);
	  bin_led :OUT std_logic_vector(6 downto 0));
END bin2led;

ARCHITECTURE behavior OF bin2led IS
BEGIN
PROCESS(bin)  
BEGIN
CASE bin IS
	WHEN "001" => bin_led <= "0000001";
	WHEN "010" => bin_led <= "0000010";
	WHEN "011" => bin_led <= "0000100";
	WHEN "100" => bin_led <= "0001000";
	WHEN "101" => bin_led <= "0010000";
	WHEN "110" => bin_led <= "0100000";
	WHEN "111" => bin_led <= "1000000";
	WHEN OTHERS => bin_led <= "0000000";
END CASE;
END PROCESS;
END behavior;

