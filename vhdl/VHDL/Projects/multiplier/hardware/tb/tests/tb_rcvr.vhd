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
--| FILE    : tb_rcvr.vhd
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

entity tb_rcvr is
end tb_rcvr;  

architecture tb of tb_rcvr is
-- Instantiate Components

-- Instantiate Receiver Stimulus
component stim_rcvr is
     generic(
           g_file1_name : string := "../tb/tests/signal_in_int.txt";
           g_file2_name : string := "../tb/tests/signal_nco_int.txt"
           );
    port(
         i_clk : in    std_logic;
         o_in_sig   :   out std_logic_vector(11 downto 0);
         o_nco   :   out std_logic_vector(11 downto 0);
         o_dv  :   out std_logic
        );
  end component; 
  
-- Instantiate Check Stimulus
component check_rcvr is
   generic(
           g_file_name : string := "../tb/tests/check_mult.txt"
           );
  port(
       i_clk : in    std_logic;
       i_c   : in    std_logic_vector(15 downto 0);
       i_dv  : in    std_logic
      );
  end component; 

-- Instantiate Receiver Multiplier Unit
  component receiver is
   port (
    i_clk   : in std_logic; -- Input clock
    i_dv    : in std_logic; -- Data valid line
    i_in    : in std_logic_vector(11 downto 0); -- Stimulus Reader (22 kHz)
    i_nco   : in std_logic_vector(11 downto 0); -- Numerically Controlled Oscillator (21 kHz)
    o_out   : out std_logic_vector(15 downto 0); -- Output signal after multiplication
    o_dv    : out std_logic

  );
  end component;
  
  -- Declare Signals
  signal c_clk : std_logic := '1';
  signal w_dv  : std_logic := '0';
  signal w_dv_2_check : std_logic := '0';
  signal w_nco : std_logic_vector(11 downto 0);
  signal w_out : std_logic_vector(15 downto 0);
  signal w_in_sig : std_logic_vector(11 downto 0);
  
  begin
  
    c_clk <= not(c_clk) after 416.5 ns; -- 1.2 MHz clock
    
    -- Instantiate Receiver Stimulus
    u_stim : stim_rcvr
    generic map(
       g_file1_name => "../tb/tests/signal_in_int.txt",
       g_file2_name => "../tb/tests/signal_nco_int.txt"
    )
    port map(
         i_clk => c_clk,
         o_in_sig   => w_in_sig,
         o_nco   => w_nco,
         o_dv  => w_dv
    );
    
    -- Instantiate Receiver
    u_rcvr : receiver
    port map(
         i_clk  => c_clk,
         i_dv   => w_dv,
         i_in   => w_in_sig,
         i_nco  => w_nco,
         o_out  => w_out,
         o_dv   => w_dv_2_check
         
    );   
        
    -- Instantiate Check Stimulus
    u_check : check_rcvr
    generic map(
             g_file_name => "../tb/tests/check_mult.txt"
             )
    port map(
        i_clk    => c_clk,
        i_c      => w_out,
        i_dv     => w_dv_2_check
    
    );
      
  

end tb;