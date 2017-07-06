-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 30/10/2016
-- revision   : version 1 - 1/11/2016 - jelle meeus
-- file       : pngenerator.vhd
-----------------------------------------------------------------
-- design: 
-- shift register
--
-- description:
-- this entity/architecture pair is a PN generator
-- with clk, ser_in, rst, se and outputs par_out
-- ce1_b ce2_b)
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pngenerator is
port (clk,rst,clock_enable :in  std_logic;
	 pn_start, pn_ml1, pn_ml2, pn_gold :out std_logic);
end pngenerator;

architecture behavior of pngenerator is
signal present_state_pn1: std_logic_vector((4) downto 0);
signal next_state_pn1: std_logic_vector((4) downto 0);
constant intern1: std_logic_vector(4 downto 0) := "00010";

signal present_state_pn2: std_logic_vector((4) downto 0);
signal next_state_pn2: std_logic_vector((4) downto 0);
constant intern2: std_logic_vector(4 downto 0) := "00111";
begin

se_sync1: process (clk)
begin
  if (rising_edge(clk)  and clock_enable ='1' ) 
	 then 	   
		if (rst = '0') then 
			present_state_pn1 <= intern1;
			present_state_pn2 <= intern2;
		else
			present_state_pn1 <= next_state_pn1;
			present_state_pn2 <= next_state_pn2;   
	 end if;
	end if;
end process se_sync1;

se_comb1: process (present_state_pn1, present_state_pn2)
begin
	next_state_pn1 <= (present_state_pn1(3) xor present_state_pn1(0)) & present_state_pn1(4 downto 1);
	next_state_pn2 <= (present_state_pn2(4) xor present_state_pn2(3) xor present_state_pn2(1) xor present_state_pn2(0)) & present_state_pn2(4 downto 1);

	if ( present_state_pn1 = intern1) then pn_start <= '1';
	else pn_start <= '0';
	end if;
		
	pn_ml1 <= present_state_pn1(0);
	pn_ml2 <= present_state_pn2(0);
	pn_gold <= (present_state_pn1(0) xor present_state_pn2(0));
		
end process se_comb1;



end behavior;

