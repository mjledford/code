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
--| FILE    : stim_addr.vhd
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
library std;
  use std.standard.all;
  use std.textio.all;
  
entity stim_addr is
  generic(
           g_file_name : string := "tests/stim_addr.txt"
           );
  port(
       i_clk : in    std_logic;
       o_a   :   out std_logic_vector(7 downto 0); -- read from signal 1 file
       o_b   :   out std_logic_vector(7 downto 0); -- read from signal 2 file
       o_dv  :   out std_logic
      );
end stim_addr; 

architecture tb of stim_addr is 
  file infile : text;
  signal c_a  : integer   := 0;
  signal c_b  : integer   := 0;
  signal c_dv : std_logic := '0';
  
begin

  o_a  <= std_logic_vector(to_unsigned(c_a, 8));
  o_b  <= std_logic_vector(to_unsigned(c_b, 8));
  o_dv <= c_dv;

  io_process: process is
    variable v_buf   : line;
    variable v_value : integer;
    variable v_comma : character;
  begin
    file_open(infile, g_file_name, READ_MODE);
    wait until rising_edge(i_clk);
      while (not endfile(infile)) loop
        readline(infile, v_buf);
        read(v_buf, v_value);
        c_a <= v_value;
        read(v_buf, v_comma);
        read(v_buf, v_value);
        c_b  <= v_value;
        c_dv <= '1';        
        wait until rising_edge(i_clk);
        c_dv <= '0';
      end loop;    
    file_close(infile);
    report "Stimulus data has ended";
    wait;    
  end process;

end tb;
  