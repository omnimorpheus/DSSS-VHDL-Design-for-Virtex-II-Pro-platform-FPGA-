-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 22/11/2016
-- revision   : version 1 - 22/11/2016 - jelle meeus
-- file       : despread.vhd
-----------------------------------------------------------------
-- design: 
-- despread
--
-- description:
-- this entity is a despread 
-- with inputs: sdi_spread, pn_seq, rst, clk and clock_enable
-- output sdi_despread
-- 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity despread is
port (clk,rst, clock_enable, sdi_spread, pn_seq, chip_sample :in  std_logic;
	sdi_despread :out std_logic);
end despread;

architecture behavior of despread is

signal present_state,next_state: std_logic;

begin

sdi_despread <= present_state;

sync_ds: process (clk)
begin  
	if (rising_edge(clk) and clock_enable ='1') then 
		if (rst = '0') then 
			present_state <= '0';
		else
			present_state <= next_state;
		end if;	
	end if;
end process sync_ds;

comb_ds: process(present_state, pn_seq, sdi_spread, chip_sample)
begin
	if chip_sample = '1' then
 	  next_state <= pn_seq xor sdi_spread;
	else 
  	  next_state <= present_state;
	end if; 
end process comb_ds;

end behavior;

