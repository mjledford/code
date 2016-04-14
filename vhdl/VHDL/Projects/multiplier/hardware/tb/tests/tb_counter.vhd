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
--| FILE    : tb_counter.vhd
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

entity tb_counter is
generic (g_OUT_BW : integer := 8;
         g_LED_BW: integer := 4
);
end tb_counter; 

-- Define tb architecture
architecture tb_rtl of tb_counter is
--Declare Components
component top_counter is
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
end component top_counter;

--Define signals and wires
signal w_clk  : std_logic := '0';
signal w_rst  : std_logic := '0';
signal w_s1   : std_logic := '1'; --start off in manual increment mode
signal w_s2   : std_logic := '0'; --start off displaying LSBs
signal w_pb   : std_logic := '0'; 
signal w_led  : std_logic_vector(g_LED_BW-1 downto 0) := (others=>'0');
  
begin
  --Instantiate components
  tb_top : top_counter
  port map(
  i_clk =>  w_clk,
  i_rst =>  w_rst,
  i_s1  =>  w_s1,
  i_s2  =>  w_s2,
  i_pb  =>  w_pb,
  o_led =>  w_led
  );
  
  -- Build 50 MHz clock
  w_clk <= not(w_clk) after 10 ns;
  
  --Begin stimulus
  cnt_proc : process
  begin
  wait for 20 ns;
  w_rst <= '1'; 
  --w_s1 is initially 1, so begin in manual increment road
  wait for 20 ns;
  w_pb  <= '1';
  wait for 1 ms;
  wait for 80 ns;
  w_pb  <= '0';
  wait for 80 ns;
  w_pb  <= '1';
  wait for 1 ms;
  wait for 80 ns;
  w_pb  <= '0';
  w_s1  <= '0'; --chante to automatic increment mode
  w_s2  <= '1'; -- start displaying MSBs
  --w_s2 is initially 0, display 4 LSBs to LEDs
  wait;
  end process;
end tb_rtl;


