--+----------------------------------------------------------------------------
--|
--| � COPYRIGHT 2013 Air Force Institute of Technology All rights reserved.
--|                                             ___    ________________
--| Air Force Institute of Technology          /   |  / ____/  _/_  __/         
--| 2950 Hobson Way                           / /| | / /_   / /  / /   
--| Wright-Patterson AFB, OH 45433-7765      / ___ |/ __/ _/ /  / /                
--| 937.255.3636                            /_/  |_/_/   /___/ /_/     
--|                                                                    
--+----------------------------------------------------------------------------
--|
--|                                 NOTICE
--|
--|
--+----------------------------------------------------------------------------
--|
--| FILE    : clock_enable.vhd
--| AUTHOR  : LTC Bob McTasney
--| RELEASE : 
--| CREATED : 3 Apr 2014
--| UPDATED : 
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : 
--|    Used in   : 
--|
--+----------------------------------------------------------------------------
--|
--| Description : 
--|                  
-------------------------------------------------------------------------------
--|
--| NAMING CONVENTIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clock_enable is
port(
  i_clk     : in    std_logic;  -- 50 MHz clock, 50% duty cycle
  i_rst     : in    std_logic;
  o_clk_en  : out   std_logic   -- 50 KHz clock, pulse width 1/(2*10e6) 
);
end clock_enable;

architecture behav_arch of clock_enable is
	  
  -- intermediate signal with initial value
  signal f_counter   : unsigned(25 downto 0) := (others => '0');
  
begin

  d_f_en_proc : process(i_clk, i_rst) 
  begin
    if (i_rst = '0') then  -- reset occurs asynchronously
      f_counter <= (others=>'0');
      o_clk_en <= '0';
    elsif (rising_edge(i_clk)) then
      if f_counter = 50000000 then
        o_clk_en <= '1';
        f_counter <= (others=>'0');
      else
        o_clk_en <= '0';
        f_counter <= f_counter + 1;
      end if;
    end if;
  end process d_f_en_proc;
	
end behav_arch;
