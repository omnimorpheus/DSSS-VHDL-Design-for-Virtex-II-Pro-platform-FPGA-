-----------------------------------------------------------------
-- project    : spread spectrum tx
-- author     : jelle meeus - campus de nayer
-- begin date : 29/11/2016
-- revision   : version 1 - 29/11/2016 - jelle meeus
-- file       : data_latch.vhd
-----------------------------------------------------------------
-- design: 
-- shift register
--
-- description:
-- this entity/architecture pair is a datalatch
-- with inputs: clk, clock_enable, rst, bit_sample, 10 bit data_in
-- and outputs: data_out
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity data_latch is
port (clk,rst,clock_enable, bit_sample :in  std_logic;
	data_in : in std_logic_vector(10 downto 0);
	data_out :out std_logic_vector(3 downto 0));
end data_latch;

architecture behavior of data_latch is
signal present_state1: std_logic_vector(6 downto 0);
signal next_state1: std_logic_vector(6 downto 0);
constant preamble: std_logic_vector(6 downto 0) := "0111110";

signal present_state2: std_logic_vector(3 downto 0);
signal next_state2: std_logic_vector(3 downto 0);

signal le: std_logic;

signal data_in_d_present_state : std_logic_vector(3 downto 0);
signal data_in_d_next_state : std_logic_vector(3 downto 0);

begin

data_out <= present_state2;

pre_sync: process (clk)
begin
  if (rising_edge(clk) and clock_enable ='1' ) 
	 then 	   
		if (rst = '0') then 
			present_state1 <= (others => '0');
		else
			present_state1 <= next_state1;  
	 end if;
	end if;
end process pre_sync;

pre_comb: process (present_state1, data_in, bit_sample)
begin
	if bit_sample = '1' then 
		next_state1 <= data_in(10 downto 4);
	else
		next_state1 <= present_state1;
	end if;
	
	if present_state1 = preamble then
		le <= '1';
	else
		le <= '0';	
	end if;	
end process pre_comb;

data_in_delay_sync: process (clk)
begin
  if (rising_edge(clk) and clock_enable ='1' ) 
	 then 	   
		if (rst = '0') then 
			data_in_d_present_state <= (others => '0');
		else
			data_in_d_present_state <= data_in_d_next_state;  
		end if;
	end if;
end process data_in_delay_sync;

data_in_delay_comb: process (data_in_d_present_state,bit_sample,data_in)
begin
  if bit_sample = '1' then
	data_in_d_next_state <= data_in(3 downto 0);
  else
	data_in_d_next_state <= data_in_d_present_state;
  end if;
end process data_in_delay_comb;

latch_sync: process (clk)
begin
  if (rising_edge(clk) and clock_enable ='1' ) 
	 then 	   
		if (rst = '0') then 
			present_state2 <= (others => '0');
		else
			present_state2 <= next_state2;  
	 end if;
	end if;
end process latch_sync;

latch_comb: process (present_state2, le, bit_sample,data_in_d_present_state)
begin
	if bit_sample = '1' and le='1'then 
		next_state2 <= data_in_d_present_state; --LE has delay of 1 clock cycle
	else
		next_state2 <= present_state2;
	end if;	
end process latch_comb;


end behavior;

