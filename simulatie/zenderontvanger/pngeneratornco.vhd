-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 30/10/2016
-- revision   : version 1 - 1/11/2016 - jelle meeus
-- file       : pngeneratornco.vhd
-----------------------------------------------------------------
-- design: 
-- shift register
--
-- description:
-- this entity/architecture pair is a PN generator
-- with inputs: clk, rst, clock_enable, chip_sample, seq_det
-- and outputs: pn_ml1, pn_ml2, pn_gold, full_seq
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pngeneratornco is
port (clk,rst,clock_enable, chip_sample, seq_det :in  std_logic;
	 full_seq_puls, pn_ml1, pn_ml2, pn_gold :out std_logic);
end pngeneratornco;

architecture behavior of pngeneratornco is
signal present_state_pn1: std_logic_vector((4) downto 0);
signal next_state_pn1: std_logic_vector((4) downto 0);
constant intern1: std_logic_vector(4 downto 0) := "00010";

signal present_state_pn2: std_logic_vector((4) downto 0);
signal next_state_pn2: std_logic_vector((4) downto 0);
constant intern2: std_logic_vector(4 downto 0) := "00111";

signal full_seq: std_logic;

component ped is
port (
	clk,sig,clock_enable,rst :in  std_logic;
	 ped :out std_logic);
end component;

begin
pn_ml1 <= present_state_pn1(0);
pn_ml2 <= present_state_pn2(0);
pn_gold <= (present_state_pn1(0) xor present_state_pn2(0));

ped_inst: ped
port map(
  clk => clk,
  sig => full_seq,
  ped => full_seq_puls,
  rst => rst,
  clock_enable => clock_enable);

se_sync1: process (clk)
begin
  if (rising_edge(clk) and clock_enable ='1' ) 
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

se_comb1: process (present_state_pn1, present_state_pn2, chip_sample, seq_det)
begin
  if seq_det = '0' then 
	   if chip_sample = '1' then
	    next_state_pn1 <= (present_state_pn1(3) xor present_state_pn1(0)) & present_state_pn1(4 downto 1);
	    next_state_pn2 <= (present_state_pn2(4) xor present_state_pn2(3) xor present_state_pn2(1) xor present_state_pn2(0)) & present_state_pn2(4 downto 1);
	   else
	    next_state_pn1 <= present_state_pn1;
	    next_state_pn2 <= present_state_pn2;
	  end if;
	else
	   next_state_pn1 <= intern1;
	   next_state_pn2 <= intern2;
	end if;	 	
	if ( present_state_pn1 = intern1) then
	 full_seq <= '1';
	else full_seq <= '0';
	end if; 	  
end process se_comb1;

end behavior;

