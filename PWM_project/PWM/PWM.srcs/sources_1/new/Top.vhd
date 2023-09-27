----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2023 11:49:18 AM
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( Percent : in STD_LOGIC_VECTOR (7 to 0);
           CLK : in STD_LOGIC;
           PWM : out STD_LOGIC);
end Top;

architecture Behavioral of Top is
signal count: unsigned(7 downto 0);
begin 

process(CLK) 
    begin
        if(CLK'event and CLK = '1') then
        
            if(unsigned(Percent) > count) then
                count <= count +1;
                PWM <= '0';
            end if;
            
            if(count > 254) then
            count <= TO_UNSIGNED(0,7);
            PWM <= '1';
            end if;
            
            
        end if;
    end process;


end Behavioral;
