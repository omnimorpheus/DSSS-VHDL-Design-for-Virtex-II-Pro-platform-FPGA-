Library IEEE;
Use IEEE.Std_Logic_1164.all;
 
entity rotary_enc is port
   (
     clk,rst,clock_enable : in    std_logic;
     a_channel,b_channel   : in    std_logic;
     clkwise : out   std_logic;
     cclkwise : out   std_logic);
end rotary_enc; 

architecture behavior of rotary_enc is
 
--transitie edge detector
type fsm_states is (w0,w1,p0,p1);
signal present_state_ed : fsm_states;
signal next_state_ed : fsm_states;

begin

--transitie edge detector
--IN: a_channel, b_channel OUT: 
ed_sync: process(clk)
begin
if rising_edge(clk) and clock_enable = '1' then
  if rst = '1' then
    present_state_ed <= w1;
  else
    present_state_ed <= next_state_ed;
  end if;
end if;
end process ed_sync;

ed_comb: process(present_state_ed, a_channel, b_channel)
begin
case present_state_ed is  
  when w1 =>
    if a_channel = '1' then
      next_state_ed <= p1;
    else
      next_state_ed <= w1;
    end if;
	clkwise <= '0';
	cclkwise <= '0';
    
  when p1 =>	--rising edge
    if a_channel = '1' then
      next_state_ed <= w0;
    else
      next_state_ed <= p0;
    end if;
	
	if b_channel = '1' then
		clkwise <= '1';
		cclkwise <= '0';
	else
		clkwise <= '0';
		cclkwise <= '1';
	end if;		
    
  when w0 =>
    if a_channel = '1' then
      next_state_ed <= w0;
    else
      next_state_ed <= p0;
    end if;
	clkwise <= '0';
	cclkwise <= '0';
    
  when p0 =>	--falling edge	
    if a_channel = '1' then
      next_state_ed <= p1;
    else
      next_state_ed <= w1;
    end if;    
	
	if b_channel = '0' then
		clkwise <= '1';
		cclkwise <= '0';
	else
		clkwise <= '0';
		cclkwise <= '1';
	end if;		
	
end case;
end process ed_comb;

end behavior;

 
