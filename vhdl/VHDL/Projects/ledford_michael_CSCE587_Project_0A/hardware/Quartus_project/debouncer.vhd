-- Debouncer

Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is 
  port(
        i_db    : in std_logic; -- push button
        i_clk   : in std_logic; 
        o_pb    : out std_logic   -- output signal , 1 for high or 0 for low
      
      );
      
end debouncer;

architecture rtl of debouncer is
-- signals go here
type sm_db is (idle, waiting, check_high, assertout, stay_high, deassert);--stay_high new state
--type sm_db is (idle, waiting, check_high, assertout, stay_high);--stay_high new state
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
          --s_current_state <= deassert;
          s_current_state <= stay_high; --new
        when stay_high =>
          if f_db = '0' and i_db = '1' then --new
            s_current_state <= deassert; --new
          end if;
        when deassert =>
          f_deb <= '0';
          s_current_state <= idle;
      end case;
            
           
          
          
    
    
    
    
    end if;
        
  
  
  end process;



end rtl;