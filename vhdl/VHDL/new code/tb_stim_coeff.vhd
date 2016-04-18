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
--| FILE    : tb_stim_coeff.vhd
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
library std;
  use std.standard.all;
  use std.textio.all;
  
entity tb_stim_coeff is
end entity;

architecture tb of tb_stim_coeff is
component stim_coeff is
generic(
           g_file_name : string := "../tb/tests/fir_proj1_coef_file.fcf"
           --g_file_name : string := "../tb/tests/check_addr.txt"
           );
  port(
       i_clk : in    std_logic;
       o_a   :   out signed(13 downto 0); -- read from signal 1 file
       o_b   :   out signed(13 downto 0); -- read from signal 2 file
       o_dv  :   out std_logic
      );
end component stim_coeff;

signal w_clk : std_logic := '0';
signal w_a : signed(13 downto 0);
signal w_b : signed(13 downto 0);
signal w_dv: std_logic;

begin

  dut : stim_coeff
  port map(
    i_clk=> w_clk,
    o_a => w_a,
    o_b => w_b,
    o_dv=> w_dv
  );
  
  w_clk <= not(w_clk) after 10 ns;
end tb;