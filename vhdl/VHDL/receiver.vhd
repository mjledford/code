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
--| FILE    : receiver.vhd
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

-- Define Entity
entity receiver is  
  port (
    i_clk   : in std_logic; -- Input clock
    i_dv    : in std_logic; -- Data valid line
    i_stim  : in std_logic_vector(11 downto 0); -- Stimulus Reader (22 kHz)
    i_nco   : in std_logic_vector(11 downto 0); -- Numerically Controlled Oscillator (21 kHz)
    o_out   : out std_logic_vector(15 downto 0) -- Output signal after multiplication

  );
end receiver;

-- Define Architecture
architecture rtl of receiver is

-- Declare any needed signals

begin
signal f_out   : unsigned(15 downto 0);

o_out <= std_logic_vector(f_out);
rcvr: process(i_clk) is
  begin
    if rising_edge(i_clk) then
      if i_dv = '1' then
        f_out <= signed(i_stim) * signed(i_nco);
      end if;
    end if;
  end process;
      
end

end rtl;