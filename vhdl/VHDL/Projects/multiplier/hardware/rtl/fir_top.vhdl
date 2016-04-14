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
--| FILE    : fir_top.vhd
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

  entity fir_top is
  port(
    i_clk : in std_logic;
    i_x   : in std_logic_vector(15 downto 0);
    i_en  : in std_logic;
    i_rst : in std_logic;
    i_b0  : in std_logic_vector(11 downto 0);
    i_b1  : in std_logic_vector(11 downto 0);
    i_b2  : in std_logic_vector(11 downto 0);
    i_b3  : in std_logic_vector(11 downto 0);
    o_result : out std_logic_vector(31 downto 0)
  );
  
  end fir_top;
  
  architecture rtl_top of fir_top is
  -- Declare components
  component direct_fir 
  port(
  i_clk      : in std_logic;
  i_en       : in std_logic;
  i_x        : in std_logic_vector(15 downto 0);
  i_rst      : in std_logic;
  i_bypass   : in std_logic;
  i_chainin  : in std_logic_vector(31 downto 0);
  i_b0       : in std_logic_vector(11 downto 0);
  i_b1       : in std_logic_vector(11 downto 0); --i_b1 goes through register
  o_result   : out std_logic_vector(31 downto 0);
  o_dv       : out std_logic
  );
  end component direct_fir;
  --Declare signals
  signal w_chainin : std_logic_vector(31 downto 0);
  signal w_zero    : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal w_bypass  : std_logic := '0';
  signal w_dv      : std_logic;
  
  begin 
  
  --Instantiate components
  fir1 : direct_fir
  port map(
  i_clk     => i_clk,
  i_en      => i_en,
  i_x       => i_x,
  i_rst     => i_rst,
  i_bypass  => w_bypass,
  i_chainin => w_zero,
  i_b0      => i_b0,
  i_b1      => i_b1,
  o_result  => w_chainin,
  o_dv      => w_dv
  );
  
  -- fir2 : direct_fir
  -- port map(
  -- i_clk     => i_clk,
  -- i_en      => w_dv,
  -- i_x       => i_x,
  -- i_rst     => i_rst,
  -- i_bypass  => w_bypass,
  -- i_chainin => w_chainin,
  -- i_b0      => i_b2,
  -- i_b1      => i_b3,
  -- o_result  => o_result,
  -- o_dv      => w_dv
  -- );
  
  
  end rtl_top;