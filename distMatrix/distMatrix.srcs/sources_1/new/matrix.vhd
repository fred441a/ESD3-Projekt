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
    
        ch0 :       out float32;
        ch1 :       out float32;
        ch2 :       out float32;
        ch3 :       out float32
        
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

signal r0:  float32;
signal r1:  float32;
signal r2:  float32;
signal r3:  float32;

signal stateSwitch:            std_logic_vector(2 downto 0):= (others => '0');
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
        Ch0 <= (r0+r1+r2+r3)+liftConst;
        
    elsif (stateSwitch = 3) then --ch1   
        Ch1 <= (r0-r1-r2+r3)+liftConst;
        
   elsif (stateSwitch = 4) then -- ch2
        Ch2 <= (-r0-r1+r2+r3)+liftConst;
        
   elsif (stateSwitch = 5) then --ch3
        Ch3 <= (-r0+r1-r2+r3)+liftConst;
        stateSwitch <= "000"; -- reset s� vi kan k�re igen.
       
   end if;
    
end if;

end process;
end Behavioral;
