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
--| FILE    : check_rcvr.vhd
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
--| Description : This is the check file for the two signal multiplication. Test file is check_mult.txt
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
  
entity check_rcvr is
  generic(
           g_file_name : string := "../tb/tests/check_mult.txt"
           );
  port(
       i_clk : in    std_logic;
       i_c   : in    std_logic_vector(15 downto 0); --Value from receiver.vhd
       i_dv  : in    std_logic
      );
end check_rcvr; 



architecture tb of check_rcvr is 
  file infile : text;
  signal c_c  : integer   := 0; -- Value from check_mult.txt
  signal f_c  : integer   := 0;
  signal ff_c : integer   := 0;
  
begin

  delay: process(i_clk) is
  begin
    if rising_edge(i_clk) then
      f_c <= to_integer(signed(i_c)); 
    end if;          
  end process;

  io_process: process is
    variable v_buf   : line;
    variable v_value : integer;
  begin
    file_open(infile, g_file_name, READ_MODE);
      while (not endfile(infile)) loop
        if rising_edge(i_clk) then
          if (i_dv = '1') then
            readline(infile, v_buf);
            read(v_buf, v_value);
            c_c <= v_value;
            ff_c <= c_c;
            assert (ff_c = f_c) report "Expecting = " & integer'image(ff_c) & ", Received = " & integer'image(f_c) severity failure;
          end if;
        end if;
        wait until rising_edge(i_clk);
      end loop;    
    assert false report "All test completed without error." severity failure;     
    file_close(infile);
    wait;    
  end process;

end tb;