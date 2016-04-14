----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:33:10 04/13/2016 
-- Design Name: 
-- Module Name:    Counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
port (
	i_clk : in std_logic;
	i_rst : in std_logic;
	o_cnt : out std_logic_vector(7 downto 0)
	
);
end Counter;

architecture Behavioral of Counter is
signal f_cnt : unsigned(7 downto 0);
signal f_check : unsigned(25 downto 0) := (others => '0');

begin
	o_cnt <= std_logic_vector(f_cnt);
  inc : process(i_clk)  is
  begin
    if rising_edge(i_clk) then
      if (i_rst = '1') then
        f_cnt <= (others => '0');
      else
        f_check <= f_check + 1;
        if(f_check = 50000000) then
          f_cnt <= f_cnt + 1;
          f_check <= (others => '0');
        end if;
      end if;
    end if;
  end process;



end Behavioral;

