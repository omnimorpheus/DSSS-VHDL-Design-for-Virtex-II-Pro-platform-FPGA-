-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 28/11/2016
-- revision   : version 1 - 28/11/2016 - jelle meeus
-- file       : datalinklayer.vhd
-----------------------------------------------------------------
-- design: 
-- datalinklayer
--
-- description:
-- this entity/architecture pair is an datalinklayer
-- dataregister
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ontvanger_datalinklayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	data_bit: in std_logic;
	bit_sample_in: in std_logic;
	bit_sample_out: out std_logic;
	data :out std_logic_vector(10 downto 0));
end ontvanger_datalinklayer;

architecture behavior of ontvanger_datalinklayer is

component ontvanger_dataregister is
port (clk,rst,clock_enable :in  std_logic;
	data : in std_logic;
	bit_sample : in std_logic;
	par_out :out std_logic_vector(10 downto 0));
end component;

begin

bit_sample_out <= bit_sample_in;

dataregister_inst: ontvanger_dataregister
port map(
	clk => clk,
	rst => rst,
	clock_enable => clock_enable,
	data => data_bit,
	bit_sample => bit_sample_in,
	par_out => data);  
    
end behavior;

