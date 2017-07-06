-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 29/11/2016
-- revision   : version 1 - 29/11/2016 - jelle meeus
-- file       : ontvanger_dataregister.vhd
-----------------------------------------------------------------
-- design: 
-- data register
--
-- description:
-- this entity is a dataregister that left shifts an 11 bit number 
-- and loads a databit
-- with reset value 0*11
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ontvanger_dataregister is
port (clk,rst,clock_enable :in  std_logic;
	data : in std_logic;
	bit_sample : in std_logic;
	par_out :out std_logic_vector(10 downto 0));
end ontvanger_dataregister;

architecture behavior of ontvanger_dataregister is

signal present_state, next_state: std_logic_vector(10 downto 0);

begin
par_out <= present_state;

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

comb_reg: process(present_state, data, bit_sample)
begin
	if bit_sample = '1' then next_state <= present_state(9 downto 0) & data;
	else next_state <= present_state;
	end if;
end process comb_reg;

end behavior;

