-----------------------------------------------------------------
-- project    : labo digitale synthese
-- author     : jelle meeus - campus de nayer
-- begin date : 8/11/2016
-- revision   : version 1 - 8/11/2016 - jelle meeus
-- file       : dpll.vhd
-----------------------------------------------------------------
-- design: 
-- dpll
--
-- description:
-- synchronises clk of tx and rx
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dpll is
port (clk,rst,sdi_spread, clock_enable :in  std_logic;
	 ed_out :out std_logic;
	chip_sample :out std_logic_vector(2 downto 0));
end dpll;

architecture behavior of dpll is

--transitie edge detector
signal ed_extb: std_logic;
type fsm_states is (w0,w1,p0,p1);
signal present_state_ed : fsm_states;
signal next_state_ed : fsm_states;

--transitie segment decoder
signal  present_state_transsegdec, next_state_transsegdec: std_logic_vector(3 downto 0); 
signal  tsdd_out: std_logic_vector(4 downto 0);                               

--semaphore
signal present_state_sema: std_logic;
signal next_state_sema: std_logic;
signal sema_out: std_logic_vector(4 downto 0); 

--nco
signal  present_state_nco, next_state_nco: std_logic_vector(4 downto 0);
signal	nco_preload	: std_logic_vector(4 downto 0);								       
signal  nco_chip_sample: std_logic;	

--nco delay
signal nco_chip_sample_d: std_logic_vector(1 downto 0);									                        


begin

--transitie edge detector
--IN: std_spread OUT: ed_extb
ed_out <= ed_extb;
ed_sync: process(clk)
begin
if rising_edge(clk) and clock_enable = '1' then
  if rst = '0' then
    present_state_ed <= w1;
  else
    present_state_ed <= next_state_ed;
  end if;
end if;
end process ed_sync;

ed_comb: process(present_state_ed, sdi_spread)
begin
case present_state_ed is  
  when w1 =>
    ed_extb <= '0';
    if sdi_spread = '1' then
      next_state_ed <= p1;
    else
      next_state_ed <= w1;
    end if;
    
  when p1 =>
    ed_extb <= '1';
    if sdi_spread = '1' then
      next_state_ed <= w0;
    else
      next_state_ed <= p0;
    end if;
    
  when w0 =>
    ed_extb <= '0';
    if sdi_spread = '1' then
      next_state_ed <= w0;
    else
      next_state_ed <= p0;
    end if;
    
  when p0 =>
    ed_extb <= '1';
    if sdi_spread = '1' then
      next_state_ed <= p1;
    else
      next_state_ed <= w1;
    end if;
    
end case;
end process ed_comb;

--trans seg decoder
--IN: ed_extb OUT: tsdd_out
transegdec_sync : process(clk)
begin
if rising_edge(clk) and clock_enable = '1' then
	if rst = '0' then
		present_state_transsegdec <= "0000";
	else
		present_state_transsegdec <= next_state_transsegdec;
	end if;
end if;
end process transegdec_sync;

transegdec_comb : process(present_state_transsegdec, ed_extb)
begin
	if present_state_transsegdec <= "0100" then
		tsdd_out <= "10000";
	elsif present_state_transsegdec <= "0110" then
		tsdd_out <= "01000";
	elsif present_state_transsegdec <= "1000" then
		tsdd_out <= "00100";
	elsif present_state_transsegdec <= "1010" then
		tsdd_out <= "00010";
	else
		tsdd_out <= "00001";
	end if;
  
	if ed_extb = '1' or present_state_transsegdec = "1111" then
		next_state_transsegdec <= "0000";
	else
		next_state_transsegdec <= present_state_transsegdec+1;
	end if;
end process transegdec_comb;

--seg semaphore A..E
-- IN: nco_chip_sample, ed_extb, tsdd_out
-- OUT: sema_out

sema_sync: process (clk)
begin
	if rising_edge(clk) and clock_enable ='1'
	then
		if rst = '0' then
			present_state_sema <= '0';
		else	
			present_state_sema <= next_state_sema;
		end if;	
	end if;  
end process sema_sync;

sema_comb: process(present_state_sema, ed_extb, nco_chip_sample, tsdd_out)
begin
	if ed_extb = '1' then
	  next_state_sema <= '1';
	elsif nco_chip_sample = '1' then
	  next_state_sema <= '0';	
	else
	   next_state_sema <= present_state_sema;
	end if;
	
	if present_state_sema = '1' then
	   sema_out <= tsdd_out;
	else
	   sema_out <=  "00100";
	end if;
end process sema_comb;

--NCO 
-- IN: sema_out
-- OUT: nco_chip_sample
nco_sync: process(clk)
begin
if rising_edge(clk) and clock_enable = '1' then
	if rst = '0' then
		present_state_nco <= "01111";  -- 15 = default
	else
		present_state_nco <= next_state_nco;
	end if;
end if;
end process nco_sync;

nco_comb: process(present_state_nco, sema_out, nco_preload)
begin
	if sema_out = "10000" then
		nco_preload <= "10010";   -- +3
	elsif sema_out = "01000" then
		nco_preload <= "10000";   -- +1
	elsif sema_out = "00100" then
		nco_preload <= "01111";   -- +0
	elsif sema_out = "00010" then
		nco_preload <= "01110";   -- -1
	else
		nco_preload <= "01100";   -- -3
	end if;

	if present_state_nco = "00000" then
		next_state_nco <= nco_preload;
		nco_chip_sample <= '1';
	else
		next_state_nco <= present_state_nco - 1;
		nco_chip_sample <= '0';
	end if;
end process nco_comb;

--chip sample delay
-- IN: nco_chip_sample
-- OUT: chip_sample
chip_sample <= nco_chip_sample_d & nco_chip_sample;

d_sync: process (clk)
begin
if rising_edge(clk) and clock_enable = '1' then
	if rst = '0' then
		nco_chip_sample_d <= "00";
	else
		nco_chip_sample_d(0) <= nco_chip_sample;
		nco_chip_sample_d(1) <= nco_chip_sample_d(0);
	end if;
end if;
end process d_sync;
    

end behavior;

