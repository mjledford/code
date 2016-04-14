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
--| FILE    : fir.vhd
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
--| 2 inputs
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
  
entity direct_fir is
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
end direct_fir;

architecture rtl of direct_fir is
-- Declare any needed signals
signal f_chainin : signed(31 downto 0);
signal f_in_reg_bank : signed (15 downto 0); --Use this register if don't bypass input reg bank
signal f_syst_reg : signed(15 downto 0); -- Register that signal x goes through
signal f_syst_reg2 : signed(11 downto 0); -- Register that coefficients go through 
signal f_out_reg  : signed(31 downto 0);
signal ff_out_reg : signed(31 downto 0); -- Use this register if you don't bypass output reg bank
signal f_dv     : std_logic;
-- Declare Components

begin
--Instantiate components
altera_fir: process(i_clk) is
  begin
  -- Assign Outputs
    o_result <= std_logic_vector(f_out_reg);
    o_dv     <= f_dv;
    if rising_edge(i_clk) then -- SHOULD I PUT RESET OUTSIDE RISING EDGE?
    -- Creating first DSP block using coefficients b3 and b2
    -- x[n] and b3 are sent to systolic registers to delay x[n]. Then are multiplied and sent to adder
    -- x[n] and b2 follow path without registers to multiplier and then adder.
    -- First DSP block, do not bypass output register
      if i_rst = '0' then --active low reset, reset all registers and data valid
        f_syst_reg <= (others => '0');
        f_syst_reg2<= (others => '0');
        f_chainin  <= (others => '0');
        f_dv       <= '0';
      elsif i_en = '1' then
        f_syst_reg <= signed(i_x);
        f_syst_reg2<= signed(i_b1);
        f_out_reg  <= signed(i_x)*signed(i_b0) + f_syst_reg*f_syst_reg2 + signed(f_chainin);
        -- NEED TO ADD BYPASS LOGIC
        f_dv       <= '1';
      else
        f_dv       <= '0'; -- data isn't valid yet
      end if;
    
    end if;
  end process;


end rtl;