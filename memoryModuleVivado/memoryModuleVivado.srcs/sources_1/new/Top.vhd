----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2023 15:05:22
-- Design Name: 
-- Module Name: Top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
GENERIC (
    wordSize : INTEGER := 32;
    wordCount : INTEGER := 44 --0x2C
  );
end Top;

architecture Behavioral of Top is

TYPE ram_type IS ARRAY (natural range <>) OF std_logic_vector (wordSize - 1 DOWNTO 0);
  subtype ram_stype is ram_type(0 to wordCount-1);
  subtype ram_mstype is ram_type(0 to 8+wordCount-1);
  subtype ram_rstype is ram_type(0 to 3);

begin


end Behavioral;
