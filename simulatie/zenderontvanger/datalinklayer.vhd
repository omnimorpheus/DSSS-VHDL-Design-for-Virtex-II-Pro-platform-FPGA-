-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 25/10/2016
-- revision   : version 1 - 25/10/2016 - jelle meeus
-- file       : datalinklayer.vhd
-----------------------------------------------------------------
-- design: 
-- datalinklayer
--
-- description:
-- this entity/architecture pair is an datalinklayer
-- sequencecontroller, shiftregister
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datalinklayer is
port (
	clk:in std_logic;
	clock_enable: in std_logic;
	rst:in std_logic;
	bindata: in std_logic_vector(3 downto 0);
	pn_start:in  std_logic;
	sdo_posenc: out std_logic);
end datalinklayer;

architecture behavior of datalinklayer is

component sequencecontroller is
port (
  clk,rst,start, clock_enable :in  std_logic;
	ld, sh:out std_logic);
end component;

component dataregister is
port (
  clk,sh,ld,rst, clock_enable :in  std_logic;
	data : in std_logic_vector(3 downto 0);
	ser_out :out std_logic);
end component;

-- signalen
-- debouncerup - ped
signal load: std_logic; --load
signal shift: std_logic; --shift

begin
  
sequencecontroller_inst: sequencecontroller
port map(
	clk => clk,
	rst => rst, 
	start => pn_start,
	ld => load,
	sh => shift,
	clock_enable => clock_enable);

dataregister_inst: dataregister
port map(
	clk => clk,
	sh => shift,
	ld => load,
	rst => rst,
	data => bindata,
	ser_out => sdo_posenc,
	clock_enable => clock_enable);

end behavior;

