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
--| FILE    : top_counter.vhd
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
--| Description : Test Bench to Multiplication receiver
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
  
entity top_counter is
generic(
          g_BW : integer := 4
);
port (
  i_clk     : in std_logic;
  i_rst     : in std_logic;
  i_s1      : in std_logic;
  i_s2      : in std_logic;
  o_led     : out std_logic_vector(g_BW-1 downto 0)

);
end entity top_counter;

architecture rtl_top of top_counter is
component counter is
  generic (g_BW : integer := 8;
         g_OBW: integer := 4
  );
  port(
    i_clk     : in std_logic;
    i_clk_en  : in std_logic;
    i_rst     : in std_logic;
    i_s1      : in std_logic;
    i_s2      : in std_logic;
    o_out     : out std_logic_vector(g_BW-1 downto 0);
    o_led     : out std_logic_vector(g_OBW-1 downto 0)
  );
end component counter;

component clock_enable is
  port(
    i_clk     : in    std_logic;  -- 50 MHz clock, 50% duty cycle
    i_rst     : in    std_logic;
    o_clk_en  : out std_logic   -- Output at 1 Sec ~ 1 Hz
  );
end component clock_enable;

-- declare signals
signal w_clk_en : std_logic;
signal w_out    : std_logic_vector(7 downto 0);
begin
  --Instantiate Components
  count : counter
  port map(
    i_clk     => i_clk,
    i_clk_en  => w_clk_en,
    i_rst     => i_rst,
    i_s1      => i_s1,
    i_s2      => i_s2,
    o_out     => w_out,
    o_led     => o_led
  );
  
  clk_en  : clock_enable
  port map (
    i_clk   => i_clk,
    i_rst   => i_rst,
    o_clk_en=> w_clk_en
  );
end rtl_top;