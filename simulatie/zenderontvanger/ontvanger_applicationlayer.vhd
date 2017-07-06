-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 29/11/2016
-- revision   : version 1 - 29/11/2016 - jelle meeus
-- file       : applicationlayer.vhd
-----------------------------------------------------------------
-- design: 
-- applicationlayer
--
-- description:
-- this entity/architecture pair is an applicationlayer
-- datalatch, 7segdecoder
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ontvanger_applicationlayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	bit_sample: in std_logic;
	data_in: in std_logic_vector(10 downto 0);
	seven_segment: out std_logic_vector(6 downto 0));
end ontvanger_applicationlayer;

architecture behavior of ontvanger_applicationlayer is

component binair2sevenseg IS
PORT (bin :IN  std_logic_vector(3 downto 0);
	  seven_seg :OUT std_logic_vector(6 downto 0));
END component;

component data_latch is
port (clk,rst,clock_enable, bit_sample :in  std_logic;
	data_in : in std_logic_vector(10 downto 0);
	data_out :out std_logic_vector(3 downto 0));
end component;

-- signal data_latch to binair2sevenseg
signal data_out_latch: std_logic_vector(3 downto 0);

begin

binair2sevenseg_inst: binair2sevenseg
port map(
	bin => data_out_latch,
	seven_seg => seven_segment);
	
data_latch_inst: data_latch
port map(
	clk => clk,
	rst => rst,
	clock_enable => clock_enable,
	bit_sample => bit_sample,
	data_in => data_in,
	data_out => data_out_latch);
  
    
end behavior;

