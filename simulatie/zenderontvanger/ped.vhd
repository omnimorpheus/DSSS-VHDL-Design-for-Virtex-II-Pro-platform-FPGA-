-----------------------------------------------------------------
-- Project    : Labo Digitale Synthese
-- Author     : Jelle Meeus - campus De Nayer
-- Begin Date : 30/09/2016
-- Revision   : version 1 - 30/09/2016 - Jelle Meeus
-- File       : ped.vhd
-----------------------------------------------------------------
-- Design: 
-- positive edge detector
--
-- Description:
-- This entity detects rising edge of an input signal and
-- outputs a pulse
-----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ped is
port (clk,sig,clock_enable,rst :in  std_logic;
	  ped :out std_logic);
end ped;

architecture behavior of ped is
    
type    ped_states is (w1,p,w0);
signal  pres_state, next_state: ped_states;

begin

syn_ped: process(clk)
begin
if rising_edge(clk) and clock_enable = '1' then
  if rst = '0' then
    pres_state <= w1;
  else
    pres_state <= next_state;
  end if;
end if;
end process syn_ped;

com_ped: process(pres_state, sig)
begin
case pres_state is
  
  when w1 =>
    ped <= '0';
    if sig = '1' then
      next_state <= p;
    else
      next_state <= w1;
    end if;
    
  when p =>
    ped <= '1';
    if sig = '1' then
      next_state <= w0;
    else
      next_state <= w1;
    end if;
    
  when w0 =>
    ped <= '0';
    if sig = '1' then
      next_state <= w0;
    else
      next_state <= w1;
    end if;
  
end case;
end process com_ped; 
    
end behavior;
