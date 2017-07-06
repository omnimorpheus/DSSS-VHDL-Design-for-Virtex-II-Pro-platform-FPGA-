-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 13/12/2016
-- revision   : version 1 - 13/12/2016 - jelle meeus
-- file       : spreadpsectrumrx.vhd
-----------------------------------------------------------------
-- design: 
-- ontvanger
--
-- description:
-- this entity/architecture pair is an spreadspectrumrx
-- 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity spreadspectrumrx is
port (
	clk_100mhz:in std_logic;
	rst:in std_logic;
	p :in std_logic_vector(1 downto 0);
	rx_data: in std_logic;
	seven_segment: out std_logic_vector(6 downto 0));
end spreadspectrumrx;

architecture behavior of spreadspectrumrx is

component ontvanger is
port (
	clk:in std_logic;
	clock_enable: in std_logic;
	rst:in std_logic;
	p :in std_logic_vector(1 downto 0);
	sdi_spread: in std_logic;
	seven_segment: out std_logic_vector(6 downto 0));
end component;

component counter_ce is
generic (w : natural := 4); --default 4 bit counter_ce
port (clk,ucen,dcen,rst,clock_enable :in  std_logic;
	data_out:out std_logic_vector(w-1 downto 0);
	tc:out std_logic);
end component;

--signalen
signal ce: std_logic;

--invert
signal inv_sevenseg: std_logic_vector(6 downto 0);

begin

seven_segment <= NOT(inv_sevenseg);

counter_ce_inst: counter_ce
generic map (w => 1) --10 bit counter_ce
port map(
	clk => clk_100mhz,
	ucen => '1',
	dcen => '0',
	rst => rst,
	clock_enable => '1',
	data_out => OPEN,
	tc => ce);

ontvanger_inst: ontvanger
port map(
	clk => clk_100mhz,
	clock_enable => ce,
	rst => rst,	
	p => p,
	sdi_spread => rx_data,
	seven_segment => inv_sevenseg);

end behavior;


