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
-- w (generic) bit up counter with, reset value 0000, clock_enable, count_up/count_down
-- and outputs a terminal count (tc) and its w bit data_out
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter is
generic (w : natural := 4); --default 4 bit counter
port (clk,ucen,dcen,clkwise,cclkwise,rst,clock_enable :in  std_logic;
	data_out:out std_logic_vector(w-1 downto 0));
end counter;

architecture behavior of counter is

signal present_state, next_state: std_logic_vector(w-1 downto 0);
constant rst_state : std_logic_vector(w-1 downto 0) := (others=>'1'); 

signal count_up: std_logic;
signal count_down: std_logic;

begin
data_out <= present_state;

count_up <= ucen OR clkwise;
count_down <= dcen OR cclkwise;

ud_sync: process (clk)
begin
	if rising_edge(clk) and clock_enable ='1'
	then
		if rst = '0' then
			present_state <= (others => '0');
		else	
			present_state <= next_state;
		end if;	
	end if;  	
	
end process ud_sync;

ud_comb: process(present_state, count_up, count_down)
begin
	if (count_up xor count_down) = '0' then
		next_state <= present_state;
	elsif count_up = '1' then	
		next_state <= present_state + 1;	
	elsif count_down = '1' then
		next_state <= present_state - 1;	
	else
		next_state <= present_state;
	end if;
end process ud_comb;
end behavior;
