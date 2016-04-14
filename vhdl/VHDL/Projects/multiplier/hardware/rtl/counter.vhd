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
--| FILE    : counter.vhd
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
--| Description : 8 bit counter
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
--Declare Libraries
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- Define Entity
entity counter is
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
  o_led     : out std_logic_vector(g_OBW-1 downto 0) --Wire to LEDs
);
end counter;

-- Define architecture
architecture rtl of counter is
--Declare signals
signal f_count : unsigned(g_BW-1 downto 0) := (others => '0');
--signal f_counter : unsigned(15 downto 0) := x"0001";

begin
  o_led <= std_logic_vector(f_count(g_BW-1 downto 4)) when i_s2 = '1' --Display 4 MSBs
  else  std_logic_vector(f_count(3 downto 0)) when i_s2 = '0';  --Display 4 LSBs
  
  o_out <= std_logic_vector(f_count); --just used to make sure 8 bit counter is working
  
  counter : process(i_clk) is
  begin
    if rising_edge(i_clk) then
      if i_rst = '0' then --synchronous reset
        f_count <= (others=>'0');      
      else 
        case (i_s1) is
          when '1' =>     --use manual clock
            if i_pb = '1' then --i_pb gets asserted, goes through debouncer (~1ms) and goes high if button is pressed
              f_count <= f_count + 1;
            end if;
          
          when '0' =>     --use automated clock
            if i_clk_en = '1' then --clk_enable is a 1 second strobe
              f_count <= f_count + 1;
            end if;
          when others =>
              f_count <= (others=>'0');
        end case;
      end if;
    end if;
  
end process;
end rtl;