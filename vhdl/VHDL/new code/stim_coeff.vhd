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
--| FILE    : stim_coeff.vhd
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
   use ieee.std_logic_textio.all;
library std;
  use std.standard.all;
  use std.textio.all;

  
entity stim_coeff is
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
end stim_coeff; 

architecture behav of stim_coeff is 
  file infile : text;
  --signal c_a  : integer   := 0;
 -- signal c_b  : integer   := 0;
  signal c_a : std_logic_vector(13 downto 0);
  --signal c_b : signed(13 downto 0);
  --signal c_a : std_logic_vector(13 downto 0);
  signal c_b : std_logic_vector(13 downto 0);
  signal c_dv : std_logic := '0';
  --signal c_check : std_logic_vector(2 downto 0);
begin

  --o_a  <= std_logic_vector(to_signed(c_a, 14));
  --o_b  <= std_logic_vector(to_signed(c_b, 14));
  --o_a <= std_logic_vector(c_a);
  --o_b <= std_logic_vector(c_b);
  o_a <= signed(c_a);
  o_b <= signed(c_b);
  o_dv <= c_dv;

  io_process: process is
    variable v_buf   : line;
    --variable v_value : integer;
    --variable v_value : string;
    variable v_value : std_logic_vector(15 downto 0);
    variable v_comma : character;
  begin
    file_open(infile, g_file_name, READ_MODE);
    wait until rising_edge(i_clk);
      while (not endfile(infile)) loop
        readline(infile, v_buf); -- read line and convert
        --c_check <= v_buf(1);
        --next when not(v_buf(1) = '0');
        next when v_buf(1) = '%';
        next when v_buf(1) = 'N';
        --if v_buf(1) = '0' then
          hread(v_buf, v_value);
          c_a <= v_value(13 downto 0);
        --c_a <= to_signed(v_value,14);
         readline(infile,v_buf);
        --next when v_buf(1) = '%';
        --next when v_buf(1) = 'N';
        --read(v_buf, v_comma);
        --c_b <= v_value;
          hread(v_buf, v_value);
          c_b  <= v_value(13 downto 0);
          c_dv <= '1';        
          wait until rising_edge(i_clk); --this rising edge puts data not valid once entire file is read
          c_dv <= '0';
         --else
          --next;
         --end if;
      end loop;    
    file_close(infile);
    report "Stimulus data has ended";
    wait;    
  end process;

end behav;
  