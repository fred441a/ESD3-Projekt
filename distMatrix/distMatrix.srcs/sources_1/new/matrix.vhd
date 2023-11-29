----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2023 11:16:36 AM
-- Design Name: 
-- Module Name: matrixReloaded - Behavioral
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

entity matrix is
    Port ( 
        MCLK:       in std_logic;
        
        pidPitch:   in  float32;
        pidRoll:    in  float32;
        pidYaw:     in  float32;
        pidLat:     in  float32;
    
        ch0 :       out std_logic_vector ( 31 downto 0) := (others => '0');
        ch1 :       out std_logic_vector ( 31 downto 0) := (others => '0');
        ch2 :       out std_logic_vector ( 31 downto 0) := (others => '0');
        ch3 :       out std_logic_vector ( 31 downto 0) := (others => '0')
        
        );
end matrix;

architecture Behavioral of matrix is
-- These values are the inv og dist matrix. Take directly from Matlab Script
signal pitchRollVal:            float32:= to_float(57604.0);
signal yawVal:                  float32:= to_float(35741.0);
signal latVal:                  float32:= to_float(17857.0);
-- Matlab script stops
signal liftConst:                   float32:= to_float((3.3)*0.2250); -- Tallet inde 
--
signal floCh0:                      float32;
signal floCh1:                      float32;
signal floCh2:                      float32;
signal floCh3:                      float32;

signal r0:  float32;
signal r1:  float32;
signal r2:  float32;
signal r3:  float32;

signal stateSwitch:            std_logic_vector(2 downto 0):= (others => '0');

-- Bruges til at omskrive float32 to stdLogic32
function float32ToInteger(float_input : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable exponent, shift, fractionInt : INTEGER;
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
  -- Og nu er den færdig med det.
begin

process(MCLK)

begin
if(MCLK'event and MCLK = '1') then
stateSwitch <= stateSwitch+1;

    if(stateSwitch = 1) then
        r0 <= pidPitch*pitchRollVal;
        r1 <= pidRoll*pitchRollVal;
        r2 <= pidYaw*yawVal;
        r3 <= pidLat*latVal;
        
    elsif (stateSwitch =  2) then -- ch0
        --floCh0 <= (r0+r1+r2+r3)+liftConst;
        --ch0 <= float32ToInteger(to_Std_Logic_Vector(floch0));
        
    elsif (stateSwitch = 3) then --ch1   
        --floCh1 <= (r0-r1-r2+r3)+liftConst;
        --ch1 <= float32ToInteger(to_Std_Logic_Vector(floch1));
        
   elsif (stateSwitch = 4) then -- ch2
        --floCh2 <= (-r0-r1+r2+r3)+liftConst;
        --ch2 <= float32ToInteger(to_Std_Logic_Vector(floch2));
        
   elsif (stateSwitch = 5) then --ch3
       floCh3 <= (-r0+r1-r2+r3)+liftConst;
       ch3 <= float32ToInteger(to_Std_Logic_Vector(floch3));
       stateSwitch <= "000"; -- reset så vi kan køre igen.
       
   end if;
    
end if;

end process;
end Behavioral;
