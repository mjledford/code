Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led is
port (
  i_clk : in std_logic;
  i_rst : in std_logic;
  i_in  : in std_logic;
  o_out : out std_logic

);
end entity led;

architecture rtl of led is
 component debouncerv2 is
 port(
         i_db    : in std_logic; -- push button
         i_clk   : in std_logic; 
         o_pb    : out std_logic   -- output signal , 1 for high or 0 for low
 );
 end component debouncerv2;

signal w_pb : std_logic;

begin
   deb : debouncerv2 
   port map(
     i_db => i_in,
     i_clk => i_clk,
     o_pb => w_pb
   );
  
  db : process (i_rst,i_in) is
  begin
  if i_rst = '0' then
    o_out <= '0';
  elsif w_pb = '1' then
    o_out <= '1';
  end if;
  end process;
end rtl;