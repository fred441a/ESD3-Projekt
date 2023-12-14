----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2023 11:55:21 AM
-- Design Name: 
-- Module Name: pwmMap - Behavioral
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

entity pwmMap is
  Port (
    MCLK: in            std_logic;
    ch0: in             float32;
    ch1: in             float32;
    ch2: in             float32;
    ch3: in             float32;
   
    outCh0: out         std_logic_vector(7 downto 0);
    outCh1: out         std_logic_vector(7 downto 0);
    outCh2: out         std_logic_vector(7 downto 0);
    outCh3: out         std_logic_vector(7 downto 0)
  
  );
end pwmMap;

architecture Behavioral of pwmMap is
signal stateSwitch:     std_logic_vector (1 downto 0) := "00";

signal ch0conv:         float32;
signal ch1conv:         float32;
signal ch2conv:         float32;
signal ch3conv:         float32;

type tswitch is (DESCALE, CLAMP, OUTPUT);
signal switch   :tswitch := DESCALE;

--signal ch0: float32 :=to_float(50);
--signal ch1: float32 :=to_float(900);
--signal ch2: float32 :=to_float(350);
--signal ch3: float32 :=to_float(700);

-- Bruges til at omskrive float32 to stdLogic32
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
  -- Og nu er den færdig med det.
       
begin

process(MCLK)

begin
if(MCLK'event and MCLK = '1') then

case switch is

    when DESCALE =>
        ch0conv <= ch0*0.32;
        ch1conv <= ch1*0.32;
        ch2conv <= ch2*0.32;
        ch3conv <= ch3*0.32;
        switch <= CLAMP;
        
    when CLAMP =>
            if (ch0conv > 255) then
                ch0conv <= to_float(255.0);
            elsif (ch0conv < 1) then
                ch0conv <= to_float(1.0);
            end if;
            
            if (ch1conv > 255) then
                ch1conv <= to_float(255.0);
            elsif (ch1conv < 1) then
                ch1conv <= to_float(1.0);                
            end if;
            
             if (ch2conv > 255) then
                ch2conv <= to_float(255.0);
            elsif (ch2conv < 1) then
                ch2conv <= to_float(1.0);
            end if;
            
             if (ch3conv > 255) then
                ch3conv <= to_float(255.0);
            elsif (ch3conv < 1) then
                ch3conv <= to_float(1.0);
            end if; 
            
            switch <= OUTPUT;
            
    when OUTPUT =>               
        Outch0 <= float32ToInteger(to_Std_Logic_Vector(ch0conv))(7 downto 0);
        Outch1 <= float32ToInteger(to_Std_Logic_Vector(ch1conv))(7 downto 0);   
        Outch2 <= float32ToInteger(to_Std_Logic_Vector(ch2conv))(7 downto 0);
        Outch3 <= float32ToInteger(to_Std_Logic_Vector(ch3conv))(7 downto 0);
        switch <= DESCALE;
   when others =>
   end case;
    
end if;
end process;
end Behavioral;
