-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 30/10/2016
-- revision   : version 1 - 30/10/2016 - jelle meeus
-- file       : dataregister.vhd
-----------------------------------------------------------------
-- design: 
-- data register
--
-- description:
-- this entity is a dataregister that loads, left shifts an 11bit number
-- with reset value "preamble & data"
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataregister is
port (clk,sh,ld,rst, clock_enable :in  std_logic;
	data : in std_logic_vector(3 downto 0);
	ser_out :out std_logic);
end dataregister;

architecture behavior of dataregister is

signal present_state, next_state: std_logic_vector(10 downto 0);
constant preamble: std_logic_vector(6 downto 0) := "0111110";

begin
ser_out <= present_state(10);

sync_reg: process (clk)
begin  
	if (rising_edge(clk) and clock_enable ='1') then 
		if (rst = '0') then 
			present_state <= preamble & "0000";	 
		else
			present_state <= next_state;
		end if;
	
	end if;
end process sync_reg;

comb_reg: process(present_state, sh, ld, data)
begin
	if (ld XOR sh) = '0' then
		next_state <= present_state;
	elsif ld = '1' then 
		next_state <= preamble & data;
	elsif sh = '1' then	
		next_state <= present_state(9 downto 0) & '0';
	else
		next_state <= present_state;
	end if;
end process comb_reg;

end behavior;

