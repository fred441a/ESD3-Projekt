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
use IEEE.float_pkg.ALL;

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
    result : out std_logic_vector(31 downto 0)
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
  
  function float32ToInteger(float_input : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable exponent, shift, fractionInt : INTEGER := 0;
    variable sign : BOOLEAN;
    variable fraction : unsigned(22 downto 0);
  begin
    sign := float_input(31) = '1'; -- get sign
    exponent := to_integer(unsigned(float_input(30 downto 23))) - 127; --take exponent and subtract bias
    shift := -(exponent - 23); -- subtract fraction size (23) and inverrt sign, indicates the amount to right shift inorder to get 
    
    if shift < 23 then 
        fraction := shift_right(unsigned(float_input(22 downto 0)), shift); -- right shift fraction to get missing integer part
        fractionInt := to_integer(fraction); -- conver shiftet fracton to integer
    end if;
        
    if sign then
        return std_logic_vector(to_signed(-((2**exponent) + fractionInt), 32));
    else
        return std_logic_vector(to_signed((2**exponent) + fractionInt, 32));
    end if;
  end float32ToInteger;

begin
  
  process (ena) begin
    result <= float32ToInteger(to_Std_Logic_Vector(to_float(2.0)));
end process;

end Behavioral;
