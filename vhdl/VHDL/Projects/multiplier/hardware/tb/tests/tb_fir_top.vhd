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
--| FILE    : tb_fir_top.vhd
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

entity tb_fir_top is
end tb_fir_top; 

architecture rtl_tb of tb_fir_top is
--Declare components
component fir_top is
port(
    i_clk : in std_logic;
    i_x   : in std_logic_vector(15 downto 0);
    i_en  : in std_logic;
    i_rst : in std_logic;
    i_b0  : in std_logic_vector(11 downto 0);
    i_b1  : in std_logic_vector(11 downto 0);
    i_b2  : in std_logic_vector(11 downto 0);
    i_b3  : in std_logic_vector(11 downto 0);
    o_result : out std_logic_vector(31 downto 0)
  );
end component fir_top;

--Declare signals if needed
signal c_clk : std_logic := '1';
signal w_rst : std_logic := '1';
signal w_en  : std_logic := '0';
signal w_x   : std_logic_vector(15 downto 0) := "0000000000000001";
signal w_b0  : std_logic_vector(11 downto 0) := "000000000000";
signal w_b1  : std_logic_vector(11 downto 0) := "000000000000";
signal w_b2  : std_logic_vector(11 downto 0) := "000000000000";
signal w_b3  : std_logic_vector(11 downto 0) := "000000000000";
signal w_result : std_logic_vector(31 downto 0);
begin
--build clock
--c_clk <= not(c_clk) after 416.5 ns; -- 1.2 MHz clock
c_clk <= not(c_clk) after 10 ns; -- 50 MHz clock
--instantiate component
ft : fir_top
port map (
  i_clk => c_clk,
  i_x   => w_x,
  i_rst => w_rst,
  i_en  => w_en,
  i_b0  => w_b0,
  i_b1  => w_b1,
  i_b2  => w_b2,
  i_b3  => w_b3,
  o_result => w_result
);

firt : process
begin
wait for 10 ns;
w_rst <= '0';
wait for 10 ns;
w_en <= '1';
w_x  <= "1000000000000000";
w_b0 <= "000000000001";
w_b1 <= "000000000010";
w_b2 <= "000000000011";
w_b3 <= "000000000100";
end process firt;


end rtl_tb; 