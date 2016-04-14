--+----------------------------------------------------------------------------
--|
--| © COPYRIGHT 2015 Air Force Institute of Technology All rights reserved.
--|                                             ___    ________________
--| Air Force Institute of Technology          /   |  / ____/  _/_  __/         
--| 2950 Hobson Way                           / /| | / /_   / /  / /   
--| Wright-Patterson AFB, OH 45433-7765      / ___ |/ __/ _/ /  / /                
--| 937.255.6565                            /_/  |_/_/   /___/ /_/     
--|                                                                    
--+----------------------------------------------------------------------------
--|
--|                                 NOTICE
--|
--|
--+----------------------------------------------------------------------------
--|
--| FILE    : tb_debouncer.vhd
--| AUTHOR  : Ledford, Michael
--| RELEASE :
--| CREATED : 
--| UPDATED : 
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : 
--|    Packages  : 
--|    Files     : 
--|    Used in   : 
--|
--+----------------------------------------------------------------------------
--|
--| Description : Test Bench To Debouncer
--|        
--|
-------------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
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

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_debouncer is
end entity tb_debouncer;

-- Define architecture

architecture rtl of tb_debouncer is
-- Define Component
component debouncer
  port (
      i_db  : in std_logic;
      i_clk : in std_logic;
      o_pb  : out std_logic
  
  );
end component;

-- Signals go here
signal c_clk :  std_logic := '0';
signal w_db  :  std_logic := '0';
signal w_pb  :  std_logic := '0';

begin
  -- flip clock
  c_clk <= not(c_clk) after 10 ns;
  -- Instantiate DUT
  u_debouncer : debouncer
  port map(
    i_db  => w_db,
    i_clk => c_clk,
    o_pb  => w_pb
  
  );
  
  -- Begin Stimulus
   process
   begin
     wait for 40 ns;
     w_db <= '1';
     wait for 1 ms;
     wait for 40 ns;
     w_db <= '0';
     
    -- wait for 60 ns;
    -- w_db <= '0';
    -- wait;
    -- --wait for 1000060 ns;
    -- --w_db <= '0';
   end process;

end rtl;