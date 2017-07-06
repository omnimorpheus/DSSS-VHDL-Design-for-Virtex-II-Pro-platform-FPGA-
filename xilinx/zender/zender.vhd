-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 25/10/2016
-- revision   : version 1 - 25/10/2016 - jelle meeus
-- file       : zender.vhd
-----------------------------------------------------------------
-- design: 
-- zender
--
-- description:
-- this entity/architecture pair is an zender
-- sequencecontroller, shiftregister
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity zender is
port (
	clk:in std_logic;
	clock_enable: in std_logic;
	rst:in std_logic;
	p: in std_logic_vector(1 downto 0);
	s0,s1:in  std_logic; 
	channel_a, channel_b : in std_logic;
	sevenseg: out std_logic_vector(6 downto 0);
	txbaseband: out std_logic);
end zender;

architecture behavior of zender is

component applicationlayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	channel_a, channel_b: in std_logic;
	s0,s1:in  std_logic;
	data: out std_logic_vector(3 downto 0);
	seven_segment: out std_logic_vector(6 downto 0));
end component;


component datalinklayer is
port (
	clk:in std_logic;
	clock_enable: in std_logic;
	rst:in std_logic;
	bindata: in std_logic_vector(3 downto 0);
	pn_start:in  std_logic;
	sdo_posenc: out std_logic);
end component;


component accesslayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	p :in std_logic_vector(1 downto 0);
	sdo_posenc: in std_logic;
	pn_start: out std_logic;
	sdo_spread: out std_logic);
end component;



--signalen
signal bindata: std_logic_vector(3 downto 0); --4 bit code
signal pn_start: std_logic; 
signal sdo_posenc: std_logic;

begin
  
applicationlayer_inst: applicationlayer
port map(
	clk => clk,
	rst => rst,	 
	s0 => s0,
	s1 => s1,
	data => bindata,	
	channel_a => channel_a,
	channel_b => channel_b,
	seven_segment => sevenseg,	
	clock_enable => clock_enable);

datalinklayer_inst: datalinklayer
port map(
	clk => clk,
	rst => rst,
	
	bindata => bindata, 
	pn_start => pn_start,
	sdo_posenc => sdo_posenc,
	
	clock_enable => clock_enable);
	
accesslayer_inst: accesslayer
port map(
	clk => clk,
	rst => rst,
	
	p => p, 
	sdo_posenc => sdo_posenc,
	pn_start => pn_start,
	sdo_spread => txbaseband,	
	
	clock_enable => clock_enable);


end behavior;

