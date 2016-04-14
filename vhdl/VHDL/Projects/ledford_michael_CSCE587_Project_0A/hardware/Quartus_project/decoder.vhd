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
--| FILE    : decoder.vhd
--| AUTHOR  : Ledford, LT. Michael
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
--| Description : 2-4 Decoder
--|   Accepts a 2-bit input and generates as an output one of four unique symbols     
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
--Declare Libraries
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
  
--Define Entity
entity decoder is
port (
  i_in1 : in std_logic_vector(1 downto 0);
  i_in2 : in std_logic_vector(1 downto 0);
  i_sel : in std_logic;
  o_D0  : out std_logic;
  o_D1  : out std_logic;
  o_D2  : out std_logic;
  o_D3  : out std_logic
);
end decoder;

--Define Architecture
architecture rtl of decoder is 
--Declare signals

begin
  dec : process(i_in1,i_in2,i_sel) is
  begin
    if i_sel = '1' then --Use data from input 1
      case i_in1 is
        when "00" => 
          o_D0 <= '1';
          o_D1 <= '0';
          o_D2 <= '0';
          o_D3 <= '0';
        when "01" => 
          o_D0 <= '0';
          o_D1 <= '1';
          o_D2 <= '0';
          o_D3 <= '0';
        when "10" => 
          o_D0 <= '0';
          o_D1 <= '0';
          o_D2 <= '1';
          o_D3 <= '0';
        when "11" => 
          o_D0 <= '0';
          o_D1 <= '0';
          o_D2 <= '0';
          o_D3 <= '1';
        when others => 
          o_D0 <= '0';
          o_D1 <= '0';
          o_D2 <= '0';
          o_D3 <= '0';
      end case;
    else
      case i_in2 is --Use data from input 2
        when "00" => 
          o_D0 <= '1';
          o_D1 <= '0';
          o_D2 <= '0';
          o_D3 <= '0';
        when "01" => 
          o_D0 <= '0';
          o_D1 <= '1';
          o_D2 <= '0';
          o_D3 <= '0';
        when "10" => 
          o_D0 <= '0';
          o_D1 <= '0';
          o_D2 <= '1';
          o_D3 <= '0';
        when "11" => 
          o_D0 <= '0';
          o_D1 <= '0';
          o_D2 <= '0';
          o_D3 <= '1';
        when others => 
          o_D0 <= '0';
          o_D1 <= '0';
          o_D2 <= '0';
          o_D3 <= '0';
      end case;
    end if;
  end process;
end rtl;
