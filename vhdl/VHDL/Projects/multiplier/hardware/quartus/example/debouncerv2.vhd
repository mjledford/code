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
--| FILE    : debouncerv2.vhd
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
--| Description : Pushbutton debouncer
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

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncerv2 is 
  port(
        i_db    : in std_logic; -- push button
        i_clk   : in std_logic; 
        o_pb    : out std_logic   -- output signal , 1 for high or 0 for low
      
      );
      
end debouncerv2;

architecture rtl of debouncerv2 is
-- signals go here
type sm_db is (idle, waiting, check_high, assertout, deassert);
signal s_current_state : sm_db := idle;
signal f_db   : std_logic := '0';
signal f_count  : unsigned(16 downto 0) := (others => '0');
signal f_deb  : std_logic := '0';


begin
-- flow
-- check if sample 1 is high
-- wait a certain duration
-- check if sample 1 is stil high and call this sample 2
-- If still hi, the button was pushed, if not then it wasnt

o_pb <= f_deb;

p_debouncer: process (i_clk) is
  begin
    if rising_edge(i_clk) then
      f_db <= i_db; -- store value of i_db
      case s_current_state is
        when idle =>
          if f_db = '0' and i_db = '1' then
            s_current_state <= waiting;
          end if;
        when waiting =>
          --f_deb <= '0';
          f_count <= f_count + 1; -- count clock cycles
          if(f_count = 50000) then
            s_current_state <= check_high; -- move to check_high state
            f_count <= (others => '0'); -- reset count
          end if;
        when check_high =>
          if(i_db = '1') then
            --f_deb <= '1';
            s_current_state <= assertout;
          else
            --f_deb <= '0';
            s_current_state <= idle;
          end if;
        when assertout =>
          f_deb <= '1';
          s_current_state <= deassert;
        when deassert =>
          f_deb <= '0';
          s_current_state <= idle;
      end case;
            
           
          
          
    
    
    
    
    end if;
        
  
  
  end process;



end rtl;