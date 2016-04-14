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
--| FILE    : tb_decoder.vhd
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
--| Description : 2-4 Decoder Testbench
--|   Accepts a 2-bit input and generates as an output one of four unique symbols     
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
  
--Define Entity
entity tb_decoder is
end entity;

--Define Architecture
architecture tb_rtl of tb_decoder is
--Declare components
component decoder
port(
  i_in1 : in std_logic_vector(1 downto 0);
  i_in2 : in std_logic_vector(1 downto 0);
  i_sel : in std_logic;
  o_D0  : out std_logic;
  o_D1  : out std_logic;
  o_D2  : out std_logic;
  o_D3  : out std_logic

);
end component decoder;

--Declare Signals
signal w_in1 : std_logic_vector(1 downto 0) := "00";
signal w_in2 : std_logic_vector(1 downto 0) := "00";
signal w_sel : std_logic := '0';
signal w_D0  : std_logic;
signal w_D1  : std_logic;
signal w_D2  : std_logic;
signal w_D3  : std_logic;
signal w_clk : std_logic := '0';
begin
  --Instantiate component
  dec : decoder
  port map(
    i_in1 => w_in1,
    i_in2 => w_in2,
    i_sel => w_sel,
    o_D0  => w_D0,
    o_D1  => w_D1,
    o_D2  => w_D2,
    o_D3  => w_D3
  );
  w_clk <= not(w_clk) after 10 ns; -- Build 50 MHz clock
   dec_proc : process
   begin
    wait for 10 ns;
    w_sel <= '1';
    wait for 20 ns;
    w_in1  <= "01";
    wait for 20 ns;
    w_in1  <= "10";
    wait for 20 ns;
    w_in1  <= "11";
   end process;
end tb_rtl;