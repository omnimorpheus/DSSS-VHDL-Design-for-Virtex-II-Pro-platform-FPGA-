-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 30/09/2016
-- revision   : version 1 - 30/09/2016 - jelle meeus
-- file       : debouncer.vhd
-----------------------------------------------------------------
-- design: 
-- debouncer
--
-- description:
-- this entity is a debouncer
-- debounces an input signal over 4 clock cycles
-----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity debouncer is
   port (
	clk, rst, input_deb, clock_enable: in std_logic;
	deb_out: out std_logic
	);
end debouncer;

architecture behav of debouncer is
    
signal pres_shift, next_shift: std_logic_vector(3 downto 0);
signal ld_sh: std_logic;  

begin
    
deb_out <= pres_shift(0);
ld_sh <= input_deb xor pres_shift(0);

syn_debounce: process(clk)
begin    
if rising_edge(clk) and clock_enable ='1' then
    if rst = '0' then
          pres_shift <= (others => '0');
    else
          pres_shift <= next_shift;
    end if;
end if;

end process syn_debounce;

com_debounce: process(pres_shift, ld_sh,input_deb)
begin 
if(ld_sh = '1') then
   next_shift <= input_deb & pres_shift(3 downto 1);
else
   next_shift <= (others => pres_shift(0));
end if;
end process com_debounce; 
    
end behav;
    