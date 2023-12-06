library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package shared_types is
    TYPE ram_type IS ARRAY (natural range 0 to 45) OF std_logic_vector (31 DOWNTO 0);
end package;