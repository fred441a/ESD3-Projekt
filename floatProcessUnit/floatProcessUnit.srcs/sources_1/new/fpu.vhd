----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2023 10:48:54 AM
-- Design Name: 
-- Module Name: fpu - Behavioral
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
use IEEE.float_pkg.ALL;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpu is
    Port ( input0 : in float32;
           input1 : in float32;
           MCLK : in STD_LOGIC;
           state : in STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
           
           output: out float32
           ); 
end fpu;

architecture Behavioral of fpu is

begin
process(MCLK)
begin

    if(MCLK'event and MCLK = '1') then    
        if (state = 1) then -- add
            output <= (input0+input1);
            
        elsif (state = 2) then -- subtract
            output <= (input0-input1);
            
        elsif (state = 3) then -- multiply
            output <= (input0*input1);
        end if;  
              
    end if;
end process;
end Behavioral;
