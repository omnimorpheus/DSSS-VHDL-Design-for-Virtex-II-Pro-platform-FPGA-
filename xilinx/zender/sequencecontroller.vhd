-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 25/10/2016
-- revision   : version 1 - 5/12/2016 - jelle meeus
-- file       : sequencecontroller.vhd
-----------------------------------------------------------------
-- design: 
-- sequencecontroller
--
-- description:
-- controls load/shift of load_shiftregister with input signal\
-- 1x load (ld) followed by 10x shift (sh)
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sequencecontroller is
port (clk,rst,start, clock_enable :in  std_logic;
	 ld, sh:out std_logic);
end sequencecontroller;

architecture behavior of sequencecontroller is
signal present_state,next_state : std_logic_vector(3 downto 0);
signal load_shift: std_logic_vector(1 downto 0);

begin

ld <= load_shift(1);
sh <= load_shift(0);

sq_sync: process (clk)
begin
  if (rising_edge(clk) and clock_enable = '1' )
    then
		if rst='0' then
			present_state <= x"A"; 
		else
			present_state <= next_state;	 
		end if;
	end if;
end process sq_sync;

sq_comb: process (present_state,start)
begin
	if start='1' then
		if present_state < 10 then
			next_state <= present_state + 1;
			load_shift <= "01";
		else
			next_state <= (others => '0');
			load_shift <= "10";
		end if;
	else
		next_state <= present_state;
		load_shift <= "00";
	end if;
end process sq_comb;




end behavior;

