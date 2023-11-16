----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2023 12:38:18 PM
-- Design Name: 
-- Module Name: RealTest - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RealTest is
 Port (
    ena : in std_logic;
    a   : in std_logic_vector(31 downto 0);
    result : out real
 );
end RealTest;

architecture Behavioral of RealTest is
    
   function ConvertFloatToReal(float_input : STD_LOGIC_VECTOR(31 downto 0)) return REAL is
        variable sign : BOOLEAN;
        variable exponent : INTEGER;
        variable fraction : REAL;
    begin
        -- Interpret 32-bit float representation
        sign := float_input(31) = '1';
        exponent := to_integer(unsigned(float_input(30 downto 23))) - 127;
        fraction := Real(to_integer(unsigned(float_input(22 downto 0)))); --1.0 + Real(to_integer(unsigned(float_input(22 downto 0)))) / 2.0**23;
        
        -- Output VHDL real based on interpretation
        if sign then
            return -fraction * 1.0**exponent; --2.0**exponent;
        else
            return fraction * 1.0**exponent; --2.0**exponent;
        end if;
    end ConvertFloatToReal;
    
begin
  
  process (ena) begin
    if (ena = '1') then
        result <= ConvertFloatToReal(a);
    end if;
end process;

end Behavioral;
