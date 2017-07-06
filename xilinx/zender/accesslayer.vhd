-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 25/10/2016
-- revision   : version 1 - 25/10/2016 - jelle meeus
-- file       : accesslayer.vhd
-----------------------------------------------------------------
-- design: 
-- accesslayer
--
-- description:
-- this entity/architecture pair is an accesslayer
-- debouncer, positive edge detector, up/down counter and 7seg -- decoder 
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity accesslayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	p :in std_logic_vector(1 downto 0);
	sdo_posenc: in std_logic;
	pn_start: out std_logic;
	sdo_spread: out std_logic);
end accesslayer;

architecture behavior of accesslayer is

component pngenerator is
port (
	clk,rst,clock_enable :in  std_logic;
	pn_start, pn_ml1, pn_ml2, pn_gold :out std_logic);
end component;



-- pn
signal pn_ml1: std_logic; 
signal pn_ml2: std_logic;
signal pn_gold: std_logic;

--delay pn_ml1_d
signal pn_ml1_d: std_logic; 
signal pn_ml2_d: std_logic;
signal pn_gold_d: std_logic;

-- xor - mux
signal pn_ml1xor: std_logic; 
signal pn_ml2xor: std_logic;
signal pn_goldxor: std_logic;

begin


pngenerator_inst: pngenerator
port map(
	clk => clk,
	rst => rst, 
	pn_start => pn_start,
	pn_ml1 => pn_ml1,
	pn_ml2 => pn_ml2,
	pn_gold => pn_gold,
	clock_enable => clock_enable);

--delay
process(clk)
begin
    if(rising_edge(clk) and clock_enable = '1') then
		if rst = '0' then
			pn_ml1_d <= '0';
			pn_ml2_d <= '0';
			pn_gold_d <= '0';
		else			
			pn_ml1_d <= pn_ml1;
			pn_ml2_d <= pn_ml2;
			pn_gold_d <= pn_gold;
		end if;
	end if;
end process;    

	
process (pn_ml1_d, pn_ml2_d, pn_gold_d,sdo_posenc)
begin
		pn_ml1xor <= sdo_posenc xor pn_ml1_d;
		pn_ml2xor <= sdo_posenc xor pn_ml2_d;
		pn_goldxor <= sdo_posenc xor pn_gold_d;
end process;

process (pn_ml1xor, pn_ml2xor, pn_goldxor, p,sdo_posenc)
begin
	case p is
		when "00" => sdo_spread <= sdo_posenc;
		when "01" => sdo_spread <= pn_ml1xor;
		when "10" => sdo_spread <= pn_ml2xor;
		when "11" => sdo_spread <= pn_goldxor;
		when others => sdo_spread <= '0';
end case;
end process;
  
    
end behavior;

