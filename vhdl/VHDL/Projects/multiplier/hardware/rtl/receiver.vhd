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
--| FILE    : receiver.vhd
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

-- Define Entity
entity receiver is  
  port (
    i_clk   : in std_logic; -- Input clock
    i_dv    : in std_logic; -- Data valid line
    i_in    : in std_logic_vector(11 downto 0); -- Stimulus Reader (22 kHz)
    i_nco   : in std_logic_vector(11 downto 0); -- Numerically Controlled Oscillator (21 kHz)
    o_out   : out std_logic_vector(15 downto 0); -- Output signal after multiplication
    o_dv    : out std_logic -- Output dv

  );
end receiver;

-- Define Architecture
architecture rtl of receiver is

-- Declare any needed signals
--signal f_out   : signed (23 downto 0);
signal f_out   : signed(15 downto 0);
signal c_out   : signed (23 downto 0);
signal f_dv    : std_logic;
signal ff_dv   : std_logic;
signal f_rom_idx : unsigned(3 downto 0) := (others => '0'); 
signal c_nco   : std_logic_vector(11 downto 0);
signal ff_in   : std_logic_vector(11 downto 0);

component nco_rom is 
port(
		clk  : in  std_logic;
		en   : in  std_logic;
		addr : in  std_logic_vector(3 downto 0);
		data : out std_logic_vector(11 downto 0)
	);
end component;

begin
--instantiate component
u_nco : nco_rom
port map(
  clk => i_clk,
  en => i_dv,
  addr => std_logic_vector(f_rom_idx),
  data => c_nco
);

--o_out <= std_logic_vector(f_round_out);
o_out <= std_logic_vector(f_out);
--o_dv <= ff_dv;
o_dv <= ff_dv;
--c_out <= signed(ff_in)*signed(c_nco); 
          -- multiplication when data valid is high
rcvr: process(i_clk) is
  begin
    if rising_edge(i_clk) then
    --c_out <= signed(i_in)*signed(c_nco); 
      if i_dv = '1' then
        ff_in <= i_in;
        c_out <= signed(ff_in)*signed(c_nco); 
        f_rom_idx <= f_rom_idx + 1;
        if c_out(7) = '1' then
          f_out <= c_out(23 downto 23-15) + 1;
        else
          f_out <= c_out(23 downto 23-15);
        end if;
      end if;
      -- if f_out(7) = '1' then
        -- f_round_out <= f_out(23 downto 23-15) + 1;
      -- else
        -- f_round_out <= f_out(23 downto 23-15);
      -- end if;
      f_dv  <= i_dv;
      ff_dv <= f_dv;
    end if;
  end process;


end rtl;