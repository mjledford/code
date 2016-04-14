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
--| FILE    : fir.vhd
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
--| Description : AM Receiver Project w/ Pranav
--| FIR Filter using modified transposed form
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
--|    <signal name>_n          = active low 
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--| 
--+----------------------------------------------------------------------------

-- Declare Libraries
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity fir is
  port(
  i_clk      : in std_logic;
  i_x        : in std_logic_vector(15 downto 0);
  i_b0       : in std_logic_vector(11 downto 0);
  i_b1       : in std_logic_vector(11 downto 0);
  i_b2       : in std_logic_vector(11 downto 0);
  i_b3       : in std_logic_vector(11 downto 0);
  o_result   : out std_logic_vector(16 downto 0)
  
  );
end fir;

architecture rtl of fir is
-- Declare any needed signals
signal f_chainin : std_logic_vector(15 downto 0);
signal f_syst_reg : std_logic_vector(15 downto 0); -- Register before the MAC
signal f_syst_reg2
signal f_out_reg  : std_logic_vector(16 downto 0);
-- Declare Components

begin
--Instantiate components
altera_fir: process(i_clk) is
  begin
    if rising_edge(i_clk) then
    -- Creating first DSP block using coefficients b3 and b2
    -- x[n] and b3 are sent to systolic registers to delay x[n]. Then are multiplied and sent to adder
    -- x[n] and b2 follow path without registers to multiplier and then adder.
    -- First DSP block, do not bypass output register
    
    end if;
  end process;


end rtl;