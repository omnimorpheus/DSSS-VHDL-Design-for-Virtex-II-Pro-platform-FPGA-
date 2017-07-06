-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 25/10/2016
-- revision   : version 1 - 25/10/2016 - Jelle Meeus
-- file       : applicationlayer.vhd
-----------------------------------------------------------------
-- design: 
-- applicationlayer
--
-- description:
-- this entity/architecture pair is a applicationlayer
-- debouncer, positive edge detector, up/down counter and 7seg -- decoder 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity applicationlayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	channel_a, channel_b : in std_logic;
	s0,s1:in  std_logic;
	data: out std_logic_vector(3 downto 0);
	seven_segment: out std_logic_vector(6 downto 0));
end applicationlayer;

architecture behavior of applicationlayer is

component debouncer is
port (
	clk, rst, input_deb, clock_enable: in std_logic;
	deb_out: out std_logic
	);
end component;

component ped is
port (
	clk,sig,clock_enable,rst :in  std_logic;
	 ped :out std_logic);
end component;

component counter is
generic (w : natural := 4); --default 4 bit counter
port (clk,ucen,dcen,rst,clkwise,cclkwise,clock_enable :in  std_logic;
	data_out:out std_logic_vector(w-1 downto 0));
end component;

component binair2sevenseg is
port (
	bin :in  std_logic_vector(3 downto 0);
	seven_seg :out std_logic_vector(6 downto 0));
end component;

component rotary_enc is port
   (
     clk,rst,clock_enable : in    std_logic;
     a_channel,b_channel   : in    std_logic;
     clkwise : out   std_logic;
     cclkwise : out   std_logic);
end component; 


--signalen

-- rotary_enc - counter
signal clkwise_out, cclkwise_out : std_logic;

-- debouncerup - ped
signal deb0: std_logic; --up
signal deb1: std_logic; --down

-- ped - counter
signal ped0: std_logic; --up
signal ped1: std_logic; --down

-- counter - 7seg
signal bindata: std_logic_vector(3 downto 0); --out

begin

rotary_enc_inst : rotary_enc
port map(
     clk => clk,
	 rst => rst,
	 clock_enable => clock_enable,
     a_channel => channel_a, 
	 b_channel => channel_b,
     clkwise => clkwise_out,
     cclkwise => cclkwise_out);

debouncer_inst1: debouncer
port map(
	clk => clk,
	input_deb => s0, --global input
	deb_out => deb0,
	rst => rst,
	clock_enable => clock_enable);

debouncer_inst2: debouncer
port map(
	clk => clk,
	input_deb => s1, --global input
	deb_out => deb1,
	rst => rst,
	clock_enable => clock_enable);
	
ped_inst1: ped
port map(
  clk => clk,
  sig => deb0,
  ped => ped0,
  rst => rst,
  clock_enable => clock_enable);
  
ped_inst2: ped
port map(
  clk => clk,
  sig => deb1,
  ped => ped1,
  rst => rst,
  clock_enable => clock_enable);  
  
data <= bindata; --global output  
counter_inst: counter
generic map (w => 4) --4 bit counter
port map(
	clk => clk,
	ucen => ped0,
	dcen => ped1,
	rst => rst,
	clkwise => clkwise_out,
	cclkwise => cclkwise_out,
	clock_enable => clock_enable,
	data_out => bindata);
  
binair2sevenseg_inst: binair2sevenseg
port map(
  bin => bindata,
  seven_seg => seven_segment); --global output
  
end behavior;

