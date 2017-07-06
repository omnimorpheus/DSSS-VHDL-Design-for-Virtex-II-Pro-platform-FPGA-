-----------------------------------------------------------------
-- Project    : Labo Digitale Elektronica
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 25/03/2015
-- Revision   : version 1 - 1/04/2015 - Jelle Meeus
-- File       : rgs.vhd
-----------------------------------------------------------------
-- Design: 
-- REGISTER
--
-- Description:
-- This entity/architecture pair is a REGISTER
-- with clk, reg_in and reg_out as output
-- reg_out bestaat uit de eerste 12MS bits intern geheugen'
-- de laatste 4 zijn de P bits vd DPI switches
-----------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY rgs IS
PORT (clk :IN  std_logic;
	reg_in :IN std_logic_vector(3 DOWNTO 0);
	reg_out :OUT std_logic_vector(15 DOWNTO 0));
END rgs;

ARCHITECTURE behavior OF rgs IS
SIGNAL intern: std_logic_vector(11 DOWNTO 0);
SIGNAL mem: std_logic_vector(15 DOWNTO 0);
BEGIN
--intern geheugen definieren
intern <= X"p9E";
PROCESS (clk)
BEGIN
	IF (rising_edge(clk)) 
	 THEN 
		 reg_out(15 DOWNTO 4) <= intern ; reg_out(3 DOWNTO 0) <= reg_in;
	 END IF;
END PROCESS SE_REG;
END behavior;

