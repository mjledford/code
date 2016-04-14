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
--| Description : Top Level Module for 8 Bit Counter
--|        Clock_enable code is used from LTC. McTasney
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


--Define Libraries
Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
--Define entity
entity top_counter is
generic(
          g_BW : integer := 4
);
port (
  i_clk     : in std_logic; --50 MHz clock                                                                --> Pin: AF14
  i_rst     : in std_logic; --active low                                                                  --> Pin: AE12 (KEY1)
  i_s1      : in std_logic; --1 --> manual increment w/ push button | 0 --> automatic increment w/ clk_en --> Pin: W25 (SW0)
  i_s2      : in std_logic; --1 --> Display 4 MSBs                  | 0 --> Display 4 LSBs                --> Pin: V23 (SW1)
  i_pb      : in std_logic; --push button for manual increment                                            --> Pin: AE9 (KEY0)
  o_led     : out std_logic_vector(g_BW-1 downto 0) --output to LEDs                                      --> Pin: AF10 (LED0), AD10 (LED1), AE11 (LED2), AD7 (LED3)
  
);
end entity top_counter;

--Define architecture
architecture rtl_top of top_counter is
-- Declare components
component counter is
generic (g_BW : integer := 8;
         g_OBW: integer := 4
);
port(
  i_clk     : in std_logic; --50 MHz clock
  i_clk_en  : in std_logic; -- Strobe at 1 second
  i_rst     : in std_logic; --wire to Key 1
  i_s1      : in std_logic; --wire to SW0
  i_s2      : in std_logic; --wire to SW1
  i_pb      : in std_logic; --wire to Key 0
  o_out     : out std_logic_vector(g_BW-1 downto 0);
  o_led     : out std_logic_vector(g_OBW-1 downto 0)  --Wire to LEDs
  );
end component counter;

component clock_enable is       --clock_enable module from LTC. McTasney with my modifications
port(
  i_clk     : in    std_logic;  -- 50 MHz clock, 50% duty cycle
  i_rst     : in    std_logic;
  o_clk_en  : out   std_logic   -- Strobe at 1 Hz 
);
end component clock_enable;

component debouncerv2 is
port(
  i_db    : in std_logic; -- push button
  i_clk   : in std_logic; 
  o_pb    : out std_logic   -- output signal , 1 for high or 0 for low    
);
end component debouncerv2;

--Declare signals and wires
signal w_clk_en : std_logic := '0';
signal w_pb     : std_logic := '0';
signal w_out    : std_logic_vector(7 downto 0) := (others=>'0');
begin
  --Instantiate and map components
  cnt : counter 
  port map(
    i_clk     =>  i_clk,
    i_clk_en  =>  w_clk_en,
    i_rst     =>  i_rst,
    i_s1      =>  i_s1,
    i_s2      =>  i_s2,
    i_pb      =>  w_pb,
    o_out     =>  w_out,
    o_led     =>  o_led
  );
  
  clk_en : clock_enable
  port map(
    i_clk     =>  i_clk,
    i_rst     =>  i_rst,
    o_clk_en  =>  w_clk_en
  );
  
  deb : debouncerv2
  port map(
    i_db      =>  i_pb,
    i_clk     =>  i_clk,
    o_pb      =>  w_pb
  );
end rtl_top;