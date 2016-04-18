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
--| FILE    : filtcoeff_rom.vhd
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
--| Description : 
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
use ieee.numeric_std.all; --93 library

entity filtcoeff_rom is
generic(
        g_BW : integer := 14;
        g_hexBW : integer := 16;
        g_idxBW : integer := 5
);
port (
  i_clk : in std_logic;
  i_en  : in std_logic;
  i_idx : in std_logic_vector(g_idxBW-1 downto 0);
  i_idx2: in std_logic_vector(g_idxBW-1 downto 0);
  o_d0  : out std_logic_vector(g_BW-1 downto 0);
  o_d1  : out std_logic_vector(g_BW-1 downto 0)
);
end entity filtcoeff_rom;

architecture behav of filtcoeff_rom is
type rom_type is array (0 to 20) of std_logic_vector(g_hexBW-1 downto 0);

signal COEFF_ROM : rom_type := (x"0023", x"3ff7", x"3fc6", x"3f96", x"3f6c", x"3f4c",
                                x"3f3c", x"3f41", x"3f5c", x"3f90", x"3fdb", x"003d",
                                x"00b0", x"012f", x"01b4", x"0236", x"02ae", x"0314",
                                x"0362", x"0393", x"03a3"
                               );
signal f_d0 : std_logic_vector(g_hexBW-1 downto 0);
signal f_d1 : std_logic_vector(g_hexBW-1 downto 0);

attribute rom_style : string;
attribute rom_style of COEFF_ROM : signal is "block";

begin
  o_d0 <= f_d0(g_BW-1 downto 0);
  o_d1 <= f_d1(g_BW-1 downto 0);
  process(i_clk)
  begin
    if rising_edge(i_clk) then
      if (i_en = '1') then
        f_d0 <= COEFF_ROM(to_integer(unsigned(i_idx)));
        f_d1 <= COEFF_ROM(to_integer(unsigned(i_idx2)));
      end if;
    end if;
  end process;
                                
                              



end behav;