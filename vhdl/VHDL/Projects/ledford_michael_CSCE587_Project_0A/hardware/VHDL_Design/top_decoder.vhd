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
--| FILE    : top_decoder.vhd
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

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  
entity top_decoder is
port (
  i_clk : in std_logic;
  i_sel : in std_logic;
  i_in1 : in std_logic_vector(1 downto 0);
  i_in2 : in std_logic_vector(1 downto 0);
  o_D0  : out std_logic;
  o_D1  : out std_logic;
  o_D2  : out std_logic;
  o_D3  : out std_logic
);

end entity top_decoder;


architecture top_rtl of top_decoder is
component decoder is
port (
  i_in1 : in std_logic_vector(1 downto 0);
  i_in2 : in std_logic_vector(1 downto 0);
  i_sel : in std_logic;
  o_D0  : out std_logic;
  o_D1  : out std_logic;
  o_D2  : out std_logic;
  o_D3  : out std_logic
);
end component decoder;



 component debouncer is
 port (
         i_db    : in std_logic; -- push button
         i_clk   : in std_logic; 
         o_pb    : out std_logic   -- output signal , 1 for high or 0 for low
 );
 end component debouncer;

--Declare signals
signal w_pb1 : std_logic := '0';


begin
  d24 : decoder
  port map(
    i_in1    => i_in1 ,
    i_in2    => i_in2,
    i_sel    => w_pb1,
    o_D0     => o_D0,
    o_D1     => o_D1,
    o_D2     => o_D2,
    o_D3     => o_D3
  
  );
  
   db1 : debouncer
   port map (
     i_db  => i_sel,
     i_clk => i_clk,
     o_pb  => w_pb1
   );
  



end top_rtl;