-----------------------------------------------------------------
-- project    : spreadspectrum dss
-- author     : jelle meeus - campus de nayer
-- begin date : 13/12/2016
-- revision   : version 1 - 13/12/2016 - jelle meeus
-- file       : spreadspectrum_sim.vhd
-----------------------------------------------------------------
-- design: 
-- ontvanger
--
-- description:
-- this entity/architecture pair is a spreadspectrum_sim file
-- it connects tx in rx in one top file
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity spreadspectrum_sim is
port (
	clk_100mhz:in std_logic;
	rst:in std_logic;
	s0,s1: in std_logic;
	p :in std_logic_vector(1 downto 0);
	seven_segment_in: out std_logic_vector(6 downto 0);
	seven_segment_out: out std_logic_vector(6 downto 0));
end spreadspectrum_sim;

architecture behavior of spreadspectrum_sim is

component spreadspectrumtx is
port (
	clk_100mhz:in std_logic;
	rst:in std_logic;
	p :in std_logic_vector(1 downto 0);
	s0,s1:in  std_logic;
	tx_data: out std_logic;
	seven_segment: out std_logic_vector(6 downto 0));
end component;

component spreadspectrumrx is
port (
	clk_100mhz:in std_logic;
	rst:in std_logic;
	p :in std_logic_vector(1 downto 0);
	rx_data: in std_logic;
	seven_segment: out std_logic_vector(6 downto 0));
end component;

signal data: std_logic;

begin

spreadspectrumtx_inst: spreadspectrumtx
port map(
	clk_100mhz => clk_100mhz,
	rst => rst,
	s0 => s0,
	s1 => s1,
	p 	=> p,
	tx_data => data,
	seven_segment => seven_segment_in);

spreadspectrumrx_inst: spreadspectrumrx
port map(
	clk_100mhz => clk_100mhz,
	rst => rst,
	p 	=> p,
	rx_data => data,
	seven_segment => seven_segment_out);

end behavior;


