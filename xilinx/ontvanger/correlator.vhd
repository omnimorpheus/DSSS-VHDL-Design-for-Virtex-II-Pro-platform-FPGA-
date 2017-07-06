-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 22/11/2016
-- revision   : version 1 - 22/11/2016 - jelle meeus
-- file       : correlator.vhd
-----------------------------------------------------------------
-- design: 
-- correlator
--
-- description:
-- this entity is a correlator that uses a ud counter to detect 
-- if series of input data is mostly 0 or 1
--
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity correlator is
port (clk,chip_sample,rst, bit_sample, clock_enable, sdi_despread :in  std_logic;
	data_bit :out std_logic);
end correlator;

architecture behavior of correlator is

signal present_state1, next_state1: std_logic_vector(5 downto 0); --6bit correlator
signal present_state2, next_state2: std_logic; --1bit delay register
signal data: std_logic; --interconnection counter - register

signal data_delay: std_logic;

begin
data_bit <= data_delay;

corc_sync: process (clk)
begin
	if rising_edge(clk) and clock_enable ='1'
	then
		if rst = '0' then
			present_state1 <= (others => '0');
			present_state1(5) <= '1';
		else	
			present_state1 <= next_state1;
		end if;	
	end if;  
end process corc_sync;

corc_comb: process(present_state1, chip_sample, bit_sample,sdi_despread)
begin
    if bit_sample ='1' then
		next_state1 <= (others => '0');
		next_state1(5) <= '1';
	else
		if chip_sample = '1' then	
			if sdi_despread = '1' then	
				next_state1 <= present_state1 + 1;
			else	
				next_state1 <= present_state1 - 1;
			end if;
		else
			next_state1 <= present_state1;
		end if;
	end if;	
	data <= present_state1(5);
end process corc_comb;

corr_sync: process (clk)
begin
	if rising_edge(clk) and clock_enable ='1'
	then
		if rst = '0' then
			present_state2 <= '0';
		else	
			present_state2 <= next_state2;
		end if;	
	else
		present_state2 <= present_state2;
	end if;  
end process corr_sync;

corr_comb: process(present_state2, bit_sample, data)
begin
	if bit_sample = '1' then	
		next_state2 <= data;
	else	
		next_state2 <= present_state2;		
	end if;
end process corr_comb;

delay_sync: process(clk, present_state2)
begin
	if rising_edge(clk) and clock_enable ='1' then
		if rst = '0' then
			data_delay <= '0';
		else
			data_delay <= present_state2;
		end if;
	else
		data_delay <= data_delay;
	end if;	
end process delay_sync;





end behavior;
