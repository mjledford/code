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
--| FILE    : addr.vhd
--| AUTHOR  : Patel, Pranav
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
--| Description : 
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity addr is
  port(
       i_clk : in    std_logic;
       i_a   : in    std_logic_vector(7 downto 0);
       i_b   : in    std_logic_vector(7 downto 0);
       i_dv  : in    std_logic;
       o_c   :   out std_logic_vector(8 downto 0);
       o_dv  :   out std_logic
      );
end addr;  

architecture rtl of addr is

  signal f_c  : unsigned(8 downto 0) := (others => '0');
  signal f_dv : std_logic := '0';
  
begin

  o_c  <= std_logic_vector(f_c);
  o_dv <= f_dv;

  add: process(i_clk) is
  begin
    if rising_edge(i_clk) then
      f_c  <= resize(unsigned(i_a), 9) + resize(unsigned(i_b), 9);
      f_dv <= i_dv;
    end if;          
  end process;

end rtl;