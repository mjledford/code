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
--| FILE    : clock_enable_tb.vhd  (TEST BENCH)
--| AUTHOR  : LTC Bob McTasney
--| RELEASE : 
--| CREATED : 3 Apr 2014
--| UPDATED : Lt. Ledford
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
--| NAMING CONVENSIONS :
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

entity clock_enable_tb is
end clock_enable_tb;

architecture test_bench of clock_enable_tb is
	  
  -- declare the component of your top-level design under test (DUT)
  component clock_enable is
    port(
       i_clk     : in    std_logic;  
       i_rst     : in    std_logic;
       o_clk_en  :   out std_logic   
       );
  end component;
	  
  -- declare signals needed to stimulate the DUT inputs
  signal f_clk      : std_logic := '0';
  signal f_rst      : std_logic := '0';

  signal f_clk_en   : std_logic := '0';
  
begin

  -- instantiate the DUT component and associate '=>' values (port mapping is like wiring hardware)
 dut_inst : clock_enable port map (
                                    i_clk     => f_clk,
                                    i_rst     => f_rst,
                                    o_clk_en  => f_clk_en
                                    );

  -- Generating the clock signal (only works if you initialize the clock signal when you declare it)
  f_clk <= not f_clk after 10.0000 ns; -- generates a 50 MHz clock , Modified by Lt. Ledford
																		
  -- Implement the test plan here.  Body of process is continuously from time = 0  
  test_process : process 
  begin
    -- timing is important, in this case the DUT is rising edge triggered, therefore I'm transitioning
    -- inputs on the falling edge
    f_rst <= '0'; wait for 20 ns;
    f_rst <= '1';
	wait; -- now the current state of the inputs just continues on til the simulation ends.   	
  end process;

end test_bench;
