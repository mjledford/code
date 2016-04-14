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
--| FILE    : tb_decoder_top.vhd
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

-- Define Entity
entity tb_decoder_top is
end entity tb_decoder_top;

architecture rtl_tb_decoder_top of tb_decoder_top is
--Declare Component
component top_decoder is
port (
   i_clk : in std_logic;
  i_sel : in std_logic;
  i_in1 : in std_logic_vector(1 downto 0);
  i_in2 : in std_logic_vector(1 downto 0);
  o_D0  : out std_logic;
  o_D1  : out std_logic;
  o_D2  : out std_logic;
  o_D3  : out std_logic
);
end component top_decoder;
--Declare signals
signal w_clk : std_logic := '0';
signal w_sel : std_logic := '0';
signal w_in1 : std_logic_vector(1 downto 0);
signal w_in2 : std_logic_vector(1 downto 0);
signal w_D0  : std_logic;
signal w_D1  : std_logic;
signal w_D2  : std_logic;
signal w_D3  : std_logic;
begin
  --instantiate component
  td : top_decoder
  port map (
  i_clk => w_clk,
  i_sel => w_sel,
  i_in1 => w_in1,
  i_in2 => w_in2,
  o_D0  => w_D0,
  o_D1  => w_D1,
  o_D2  => w_D2,
  o_D3  => w_D3
  
  );

  -- Begin processes
  w_clk <= not(w_clk) after 10 ns; --50 MHz clock
  
  tb : process 
  begin
    w_in1 <= "00"; -- Begin with 00. D1 should be high since w_sel = 0, we take input 2
    w_in2 <= "01"; -- 
    wait for 50 ns;
    w_in1 <= "10"; 
    w_in2 <= "11"; -- D3 should be only LED on
    w_sel <= '1'; --push button
    wait for 1 ms;
    wait for 80 ns;
    w_sel <= '0';
    wait for 80 ns;
    w_sel <= '1';
    wait for 1 ms;
    wait for 80 ns;
    w_sel <= '0';
    wait;   -- 1 second later D3 should turn off and D2 should turn on
  end process;
  
end rtl_tb_decoder_top;