-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 13/12/2016
-- revision   : version 1 - 14/12/2016 - jelle meeus
-- file       : spreadspectrumtx.vhd
-----------------------------------------------------------------
-- design: 
-- spreadspectrumtx
--
-- description:
-- this entity/architecture pair is an spreadspectrumtx
-- 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity spreadspectrumtx is
port (
	clk_100mhz:in std_logic;
	rst:in std_logic;
	p :in std_logic_vector(1 downto 0);
	s0,s1:in  std_logic;
	channel_a, channel_b : in std_logic;
	tx_data: out std_logic;
	seven_segment: out std_logic_vector(6 downto 0));
end spreadspectrumtx;

architecture behavior of spreadspectrumtx is


component zender is
port (
	clk:in std_logic;
	clock_enable: in std_logic;
	rst:in std_logic;
	p: in std_logic_vector(1 downto 0);
	s0,s1:in  std_logic;
	channel_a, channel_b : in std_logic;
	sevenseg: out std_logic_vector(6 downto 0);
	txbaseband: out std_logic);
end component;

component counter_ce is
generic (w : natural := 4); --default 4 bit counter_ce
port (clk,ucen,dcen,rst,clock_enable :in  std_logic;
	tc:out std_logic);
end component;

--signalen
signal ce: std_logic;
--invert
signal inv_sevenseg: std_logic_vector(6 downto 0);
signal inv_dipswitch: std_logic_vector(1 downto 0);

begin

seven_segment <= NOT(inv_sevenseg);
inv_dipswitch <= NOT(p);
  
counter_ce_inst: counter_ce
generic map (w => 14) --14 bit counter_ce
port map(
	clk => clk_100mhz,
	ucen => '1',
	dcen => '0',
	rst => rst,
	clock_enable => '1',
	tc => ce);
  
 zender_inst: zender
port map(
	clk => clk_100mhz,
	clock_enable => ce,
	rst => rst,	 
	p => inv_dipswitch,
	s0 => s0,
	s1 => s1,
	channel_a => channel_a,
	channel_b => channel_b,
	sevenseg => inv_sevenseg,
	txbaseband => tx_data); 

end behavior;


