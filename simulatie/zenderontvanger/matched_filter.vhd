-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 30/10/2016
-- revision   : version 1 - 12/12/2016 - jelle meeus
-- file       : matched_filter.vhd
-----------------------------------------------------------------
-- design: 
-- matched filter
--
-- description:
-- this entity is a matched_filter that serial loads sdi_spread, left shifts an 31bit number
-- with reset value "0..0"
-- output seq_det is comparison of register with pn code of tx and its inverted value
-- 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity matched_filter is
port (clk,chip_sample,rst, clock_enable, sdi_spread :in  std_logic;
	p : in std_logic_vector(1 downto 0); 
	seq_det :out std_logic);
end matched_filter;

architecture behavior of matched_filter is

signal present_state, next_state: std_logic_vector(30 downto 0);

constant ml1: std_logic_vector(30 downto 0) := "0100001010111011000111110011010";
constant ml2: std_logic_vector(30 downto 0) := "1110000110101001000101111101100";

constant pn_gold: std_logic_vector(30 downto 0) := ml1 xor ml2;

begin

sync_reg: process (clk)
begin  
	if (rising_edge(clk) and clock_enable ='1') then 
		if (rst = '0') then 
			present_state <= (others => '0');
		else
			present_state <= next_state;
		end if;	
	end if;
end process sync_reg;

comb_reg: process(present_state, chip_sample, sdi_spread)
begin
  if chip_sample = '1' then
    next_state <= present_state(29 downto 0) & sdi_spread ;
  else
    next_state <= present_state;
  end if;
end process comb_reg;

comb_comp: process(present_state, p)
begin  
	case p is		  	    
	 when "01" =>
	   if (present_state = ml1 or present_state = not(ml1) )then
	     seq_det <= '1';
	   else
	     seq_det <= '0';
	   end if;
	   
	  when "10" =>
	   if (present_state = ml2 or present_state = not(ml2) )then
	     seq_det <= '1';
	   else
	     seq_det <='0';
	   end if;  
	   
	  when "11" =>
		if (present_state = (pn_gold) or present_state = not(pn_gold))then
	     seq_det <= '1';
	   else
	     seq_det <= '0';
	   end if;	   
	   
	  when others =>
		seq_det <= '0';
	end case; 
end process comb_comp;

end behavior;

