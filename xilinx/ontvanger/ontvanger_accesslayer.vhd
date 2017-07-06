-----------------------------------------------------------------
-- project    : spread spectrum rx
-- author     : jelle meeus - campus de nayer
-- begin date : 28/11/2016
-- revision   : version 1 - 12/12/2016 - jelle meeus
-- file       : ontvanger_accesslayer.vhd
-----------------------------------------------------------------
-- design: 
-- ontvanger_accesslayer
--
-- description:
-- this entity/architecture pair is an ontvanger_accesslayer
-- dpll, matched_filter, pngeneratornco, despread, correlator
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ontvanger_accesslayer is
port (
	clk:in std_logic;
	rst:in std_logic;
	clock_enable:in std_logic;
	p :in std_logic_vector(1 downto 0);
	sdi_spread: in std_logic;
	bit_sample: out std_logic;
	data_bit: out std_logic);
end ontvanger_accesslayer;

architecture behavior of ontvanger_accesslayer is


component dpll is
port (clk,rst,sdi_spread, clock_enable :in  std_logic;
	 ed_out :out std_logic;
	chip_sample :out std_logic_vector(2 downto 0));
end component;

component matched_filter is
port (clk,chip_sample,rst, clock_enable, sdi_spread :in  std_logic;
	p : in std_logic_vector(1 downto 0); --dip switches
	seq_det :out std_logic);
end component;

component pngeneratornco is
port (clk,rst,clock_enable, chip_sample, seq_det :in  std_logic;
	 full_seq_puls, pn_ml1, pn_ml2, pn_gold :out std_logic);
end component;

component despread is
port (clk,rst, clock_enable, sdi_spread, pn_seq, chip_sample :in  std_logic;
	sdi_despread :out std_logic);
end component;

component correlator is
port (clk,chip_sample,rst, bit_sample, clock_enable, sdi_despread :in  std_logic;
	data_bit :out std_logic);
end component;

--dpll 
--in
--out
signal dpll_ed_out : std_logic;
signal dpll_chip_sample : std_logic_vector(2 downto 0); -- (2) 2*delay, (1) 1d, (0) 0d

--matched filter
--out
signal seq_det_out : std_logic;

--delay matched_filter - PNgen mux1
signal dpll_ed_out_d : std_logic;

--pngeneratornco
--in
signal seq_det_mux : std_logic;
--out
signal full_seq_out : std_logic;
signal pn_ml1_out, pn_ml2_out, pn_gold_out : std_logic;

--despread
--in
signal pn_seq : std_logic;
signal pn_seq_d : std_logic;
--out
signal sdi_despread_out : std_logic;

--correlator
-- in
signal sdi_despread_mux : std_logic;
-- out

begin

--timing, pn_seq 1x delay
pn_seq_d_sync: process(clk, pn_seq)
begin
	if rising_edge(clk) and clock_enable ='1' then
		if rst = '0' then
			pn_seq_d <= '0';
		else
			pn_seq_d <= pn_seq;
		end if;
	else
		pn_seq_d <= pn_seq_d;
	end if;	
end process pn_seq_d_sync;

bit_sample <= full_seq_out;  --global out

dpll_inst: dpll
port map(
	clk => clk,
	rst => rst,
	sdi_spread => sdi_spread,
	clock_enable => clock_enable,
	ed_out => dpll_ed_out,
	chip_sample => dpll_chip_sample);
	
matched_filter_inst: matched_filter
port map(
	clk => clk,
	rst => rst,
	sdi_spread => sdi_spread,
	clock_enable => clock_enable,
	p => p,
	seq_det => seq_det_out,
	chip_sample => dpll_chip_sample(0));
	
pngeneratornco_inst: pngeneratornco
port map(
	clk => clk,
	rst => rst,
	clock_enable => clock_enable,
	seq_det => seq_det_mux,
	chip_sample => dpll_chip_sample(1),
	full_seq_puls => full_seq_out,
	pn_ml1 => pn_ml1_out,
	pn_ml2 => pn_ml2_out,
	pn_gold => pn_gold_out);
	
despread_inst: despread
port map(
	clk => clk,
	rst => rst,
	sdi_spread => sdi_spread,
	clock_enable => clock_enable,
	pn_seq => pn_seq_d,
	sdi_despread => sdi_despread_out,
	chip_sample => dpll_chip_sample(2));
	
correlator_inst: correlator
port map(
	clk => clk,
	rst => rst,
	sdi_despread => sdi_despread_mux,
	clock_enable => clock_enable,
	bit_sample => full_seq_out,
	data_bit => data_bit,
	chip_sample => dpll_chip_sample(2));

--delay dpll_ed_out
dpll_ed_out_delay: process (clk)
begin
	if rising_edge(clk) and clock_enable ='1' then	
		if rst='0' then
			dpll_ed_out_d <= '0';
		else	
			dpll_ed_out_d <= dpll_ed_out;
		end if;
	else
		dpll_ed_out_d <= dpll_ed_out_d;
	end if;
end process dpll_ed_out_delay;	
	
--mux1: matched_filter, pngeneratornco 
mux1 : process (p, dpll_ed_out_d, seq_det_out)
begin
	case p is
		when "00" => seq_det_mux <= dpll_ed_out_d;
		when "01" => seq_det_mux <= seq_det_out;
		when "10" => seq_det_mux <= seq_det_out;
		when "11" => seq_det_mux <= seq_det_out;
		when others => seq_det_mux <= '0';
	end case;		
end process mux1;

--mux2: pngeneratornco, despread
mux2 : process (p, pn_ml1_out, pn_ml2_out, pn_gold_out )
begin
	case p is
		when "00" => pn_seq <= '0';
		when "01" => pn_seq <= pn_ml1_out;
		when "10" => pn_seq <= pn_ml2_out;
		when "11" => pn_seq <= pn_gold_out;
		when others => pn_seq <= '0';
	end case;		
end process mux2;

--mux3: despread, correlator 
mux3 : process (p, sdi_spread, sdi_despread_out )
begin
	case p is
		when "00" => sdi_despread_mux <= sdi_spread;
		when "01" => sdi_despread_mux <= sdi_despread_out;
		when "10" => sdi_despread_mux <= sdi_despread_out;
		when "11" => sdi_despread_mux <= sdi_despread_out;
		when others => sdi_despread_mux <= '1'; 
	end case;		
end process mux3;
  
    
end behavior;

