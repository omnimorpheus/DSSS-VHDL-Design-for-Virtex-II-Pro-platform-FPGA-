-----------------------------------------------------------------
-- project    : spread spectrum dss
-- author     : jelle meeus - campus de nayer
-- begin date : 14/12/16
-- revision   : version 1 - 14/12/2016 - jelle meeus
-- file       : counter.vhd
-----------------------------------------------------------------
-- design: 
-- udcount
--
-- description:
-- w (generic) bit up counter with, reset value 0000, clock_enable, ucen/dcen
-- and outputs a terminal count (tc) and its w bit data_out
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter_ce is
generic (w : natural := 4); --default 4 bit counter_ce
port (clk,ucen,dcen,rst,clock_enable :in  std_logic;
	tc:out std_logic);
end counter_ce;

architecture behavior of counter_ce is

signal present_state, next_state: std_logic_vector(w-1 downto 0);
constant rst_state : std_logic_vector(w-1 downto 0) := (others=>'1'); 

begin
ud_sync: process (clk)
begin
	if rising_edge(clk) and clock_enable ='1'
	then
		if rst = '0' then
			present_state <= (others => '1');
		else	
			present_state <= next_state;
		end if;	
	end if;  	
	
end process ud_sync;

ud_comb: process(present_state, ucen, dcen)
begin
	if (ucen xor dcen) = '0' then
		next_state <= present_state;
	elsif ucen = '1' then	
		next_state <= present_state + 1;	
	elsif dcen = '1' then
		next_state <= present_state - 1;	
	else
		next_state <= present_state;
	end if;
	
	if present_state = rst_state then
		tc <= '1';
	else
		tc <= '0';
	end if;
end process ud_comb;
end behavior;
