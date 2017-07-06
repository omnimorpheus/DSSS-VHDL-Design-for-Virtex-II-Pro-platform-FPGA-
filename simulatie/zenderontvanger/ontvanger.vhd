-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 29/11/2016
-- revision   : version 1 - 29/11/2016 - jelle meeus
-- file       : ontvanger.vhd
-----------------------------------------------------------------
-- design: 
-- ontvanger
--
-- description:
-- this entity/architecture pair is an ontvanger
-- 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ontvanger is
port (
	clk:in std_logic;
	clock_enable: in std_logic;
	rst:in std_logic;
	p :in std_logic_vector(1 downto 0);
	sdi_spread: in std_logic;
	seven_segment: out std_logic_vector(6 downto 0));
end ontvanger;

architecture behavior of ontvanger is

component ontvanger_accesslayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	p :in std_logic_vector(1 downto 0);
	sdi_spread: in std_logic;
	bit_sample: out std_logic;
	data_bit: out std_logic);
end component;

component ontvanger_datalinklayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	data_bit: in std_logic;
	bit_sample_in: in std_logic;
	bit_sample_out: out std_logic;
	data :out std_logic_vector(10 downto 0));
end component;

component ontvanger_applicationlayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	bit_sample: in std_logic;
	data_in: in std_logic_vector(10 downto 0);
	seven_segment: out std_logic_vector(6 downto 0));
end component;




--signalen
signal bit_sample_a2d: std_logic;
signal bit_sample_d2a: std_logic;
signal data_bit_a2d: std_logic;
signal data: std_logic_vector(10 downto 0);

--signal invert

begin

  
ontvanger_accesslayer_inst: ontvanger_accesslayer
port map(
	clk => clk,
	rst => rst,	 
	clock_enable => clock_enable,
	p => p,
	sdi_spread => sdi_spread,	
	bit_sample => bit_sample_a2d,
	data_bit => data_bit_a2d);

ontvanger_datalinklayer_inst: ontvanger_datalinklayer
port map(
	clk => clk,
	rst => rst,	
	clock_enable => clock_enable,
	data_bit => data_bit_a2d, 
	bit_sample_in => bit_sample_a2d,
	bit_sample_out => bit_sample_d2a,
	data => data);
	
ontvanger_applicationlayer_inst: ontvanger_applicationlayer
port map(
	clk => clk,
	rst => rst,
	clock_enable => clock_enable,	
	bit_sample => bit_sample_d2a, 
	data_in => data,
	seven_segment => seven_segment);

end behavior;

