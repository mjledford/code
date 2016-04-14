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
--| FILE    : tb_addr.vhd
--| AUTHOR  : Patel, Pranav
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

entity tb_addr is
end tb_addr;  

architecture tb of tb_addr is

  component stim_addr is
    generic(
             g_file_name : string := "../tb/tests/stim_addr.txt"
             );
    port(
         i_clk : in    std_logic;
         o_a   :   out std_logic_vector(7 downto 0);
         o_b   :   out std_logic_vector(7 downto 0);
         o_dv  :   out std_logic
        );
  end component; 
  
  component addr is
    port(
         i_clk : in    std_logic;
         i_a   : in    std_logic_vector(7 downto 0);
         i_b   : in    std_logic_vector(7 downto 0);
         i_dv  : in    std_logic;
         o_c   :   out std_logic_vector(8 downto 0);
         o_dv  :   out std_logic
        );
  end component;   

  component check_addr is
    generic(
             g_file_name : string := "../tb/tests/check_addr.txt"
             );
    port(
         i_clk : in    std_logic;
         i_c   : in    std_logic_vector(8 downto 0);
         i_dv  : in    std_logic
        );
  end component; 
  
  signal c_clk  : std_logic := '1';
  signal w_a    : std_logic_vector(7 downto 0);
  signal w_b    : std_logic_vector(7 downto 0);
  signal w_dv   : std_logic;
  signal w_c    : std_logic_vector(8 downto 0);
  signal w_c_dv : std_logic;
  
begin

  c_clk <= not(c_clk) after 10 ns;

  u_stim: stim_addr 
    generic map(
             g_file_name => "../tb/tests/stim_addr.txt"
             )
    port map(
         i_clk => c_clk,
         o_a   => w_a,
         o_b   => w_b,
         o_dv  => w_dv
        );

  u_addr: addr 
    port map(
         i_clk => c_clk,
         i_a   => w_a,
         i_b   => w_b,
         i_dv  => w_dv,
         o_c   => w_c,
         o_dv  => w_c_dv
        );        
  
  -- u_check: check_addr
    -- generic map(
             -- g_file_name => "../tb/tests/check_addr.txt"
             -- )
    -- port map(
         -- i_clk => c_clk,
         -- i_c   => w_c,
         -- i_dv  => w_c_dv
        -- );
  
end tb;