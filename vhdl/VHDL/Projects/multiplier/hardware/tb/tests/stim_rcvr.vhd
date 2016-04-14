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
--| FILE    : stim_rcvr.vhd
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
  
entity stim_rcvr is
  generic(
           g_file1_name : string := "../tb/tests/signal_in_int.txt";
           g_file2_name : string := "../tb/tests/signal_nco_int.txt"
           );
  port(
       i_clk : in    std_logic;
       o_in_sig   :   out std_logic_vector(11 downto 0); --Input signal
       o_nco   :   out std_logic_vector(11 downto 0); -- NCO signal
       o_dv  :   out std_logic
      );
end stim_rcvr; 

architecture tb of stim_rcvr is 
  file infile : text; --Input signal stimulus
  file infile2 : text; -- NCO signal stimulus
  signal c_in_sig  : integer   := 0;
  signal c_nco  : integer   := 0;
  signal c_dv : std_logic := '0';
  signal cnt : integer := 0;
  
begin

  o_in_sig  <= std_logic_vector(to_signed(c_in_sig, 12));
  o_nco  <= std_logic_vector(to_signed(c_nco, 12));
  o_dv <= c_dv;

  io_process: process is
    variable v_buf   : line;
    variable v_buf2  : line;
    variable v_value : integer;
    
  begin
    file_open(infile, g_file1_name, READ_MODE); --open stimulus file for input signal (22 khz)
    file_open(infile2, g_file2_name, READ_MODE); -- open stimulus file for nco
    wait until rising_edge(i_clk);
      while (not endfile(infile)) loop
        readline(infile, v_buf);
        readline(infile2, v_buf2);
        read(v_buf, v_value);
        c_in_sig <= v_value;
        read(v_buf2, v_value);
        c_nco <= v_value;
        while(cnt < 23) loop  --Output data at correct rate
          wait until rising_edge(i_clk);
          cnt <= cnt + 1;
        end loop;
        cnt <= 0;
        c_dv <= '1';        
        wait until rising_edge(i_clk);
        c_dv <= '0';
      end loop;    
    file_close(infile);
    file_close(infile2);
    report "Stimulus data has ended";
    wait;    
  end process;

end tb;