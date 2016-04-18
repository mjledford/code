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
--| FILE    : tb_filtcoeff_rom.vhd
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
  use ieee.numeric_std.all;
library std;
  use std.standard.all;
  use std.textio.all;

entity tb_filtcoeff_rom is
generic( g_BW : integer := 14;
         g_idxBW : integer := 5
);
end entity tb_filtcoeff_rom;

architecture behav of tb_filtcoeff_rom is
component filtcoeff_rom is
generic(
  g_BW : integer := 14;
  g_hexBW : integer := 16;
  g_idxBW : integer := 5
);
port(
  i_clk : in std_logic;
  i_en  : in std_logic;
  i_idx : in std_logic_vector(g_idxBW-1 downto 0);
  i_idx2: in std_logic_vector(g_idxBW-1 downto 0);
  o_d0  : out std_logic_vector(g_BW-1 downto 0);
  o_d1  : out std_logic_vector(g_BW-1 downto 0)
);
end component filtcoeff_rom;

--Declare signals
signal w_clk : std_logic := '0';
signal w_en  : std_logic := '0';
signal w_cnt : unsigned(g_idxBW-1 downto 0) := (others=>'0');
signal w_idx : std_logic_vector(g_idxBW-1 downto 0) := (others=>'0');
signal w_idx2: std_logic_vector(g_idxBW-1 downto 0) := "00001";
signal w_d0  : std_logic_vector(g_BW-1 downto 0);
signal w_d1  : std_logic_vector(g_BW-1 downto 0);

begin
  rom_dut : filtcoeff_rom 
  port map(
    i_clk => w_clk,
    i_en  => w_en,
    i_idx => w_idx,
    i_idx2=> w_idx2,
    o_d0 => w_d0,
    o_d1 => w_d1
  
  );

  w_clk <= not(w_clk) after 10 ns;
  
  tb : process is
  begin
    wait for 20 ns;
    w_en <= '1';
    wait for 20 ns;
    w_cnt <= w_cnt + 1;
    w_idx <= std_logic_vector(w_cnt);
    w_idx2<= std_logic_vector(w_cnt + 1);
    wait for 10 ns;
    w_cnt <= w_cnt + 1;
  end process tb;
end behav;