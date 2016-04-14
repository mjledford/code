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
--| FILE    : nco_rom.vhd
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

-- ROM Inference on array
-- File: nco_rom.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --93 library

entity nco_rom is
	port(
		clk  : in  std_logic;
		en   : in  std_logic;
		addr : in  std_logic_vector(3 downto 0);
		data : out std_logic_vector(11 downto 0)
	);
end nco_rom;

architecture behavioral of nco_rom is
	type rom_type is array (0 to 15) of std_logic_vector(11 downto 0);
	-- signal ROM : rom_type := (X"000", X"310", X"5A8", X"040",
		                      -- X"003", X"086", X"029", X"020",
		                      -- X"082", X"005", X"040", X"025", 
		                      -- X"040", X"083", X"085", X"005"
		                     -- );
  signal ROM : rom_type := (std_logic_vector(to_signed(0,12)), std_logic_vector(to_signed(784,12)), std_logic_vector(to_signed(-1448,12)), std_logic_vector(to_signed(1892,12)),
                            std_logic_vector(to_signed(-2048,12)), std_logic_vector(to_signed(1892,12)), std_logic_vector(to_signed(-1448,12)), std_logic_vector(to_signed(784,12)),
                            std_logic_vector(to_signed(0,12)), std_logic_vector(to_signed(-784,12)), std_logic_vector(to_signed(1448,12)), std_logic_vector(to_signed(-1892,12)),
                            std_logic_vector(to_signed(2047,12)), std_logic_vector(to_signed(-1892,12)), std_logic_vector(to_signed(1448,12)), std_logic_vector(to_signed(-784,12))
		                     );
	attribute rom_style : string;
	attribute rom_style of ROM : signal is "block";

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (en = '1') then
				data <= ROM(To_integer(unsigned(addr)));
			end if;
		end if;
	end process;

end behavioral;