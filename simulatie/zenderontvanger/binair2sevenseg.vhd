-----------------------------------------------------------------
-- Project    : spread spectrum tx
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 30/09/2016
-- Revision   : version 1 - 30/09/2016 - Jelle Meeus
-- File       : binair2sevenseg.vhd
-----------------------------------------------------------------
-- Design: 
-- binair2sevenseg
--
-- Description:
-- This entity/architecture pair is a binair2sevenseg decoder
-- with input bin
-- and output seven_seg
-----------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY binair2sevenseg IS
PORT (bin :IN  std_logic_vector(3 downto 0);
	  seven_seg :OUT std_logic_vector(6 downto 0));
END binair2sevenseg;

ARCHITECTURE behavior OF binair2sevenseg IS
BEGIN
PROCESS(bin)  
BEGIN
CASE bin IS
	WHEN "0000" => seven_seg <= "1111110";
	WHEN "0001" => seven_seg <= "0110000";
	WHEN "0010" => seven_seg <= "1101101";
	WHEN "0011" => seven_seg <= "1111001";
	WHEN "0100" => seven_seg <= "0110011";
	WHEN "0101" => seven_seg <= "1011011";
	WHEN "0110" => seven_seg <= "1011111";
	WHEN "0111" => seven_seg <= "1110000";
	WHEN "1000" => seven_seg <= "1111111";
	WHEN "1001" => seven_seg <= "1111011";
	WHEN "1010" => seven_seg <= "1110111";
	WHEN "1011" => seven_seg <= "0011111";
	WHEN "1100" => seven_seg <= "1001110";
	WHEN "1101" => seven_seg <= "0111101";
	WHEN "1110" => seven_seg <= "1001111";
	WHEN "1111" => seven_seg <= "1000111";
	WHEN OTHERS => seven_seg <= "0000000";
END CASE;
END PROCESS;
END behavior;

