----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2023 10:07:37
-- Design Name: 
-- Module Name: PID_PWM_test - Behavioral
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

entity PID_PWM_test is
    Port ( 
        MCLK   : in std_logic;
        InPWM  : in STD_LOGIC;
        OutPWM : out STD_LOGIC_VECTOR(11 downto 0)
    );
end PID_PWM_test;

architecture Behavioral of PID_PWM_test is
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
        return std_logic_vector(to_unsigned(-((2**exponent) + fractionInt), 32));
    else
        return std_logic_vector(to_unsigned((2**exponent) + fractionInt, 32));
    end if;
  end float32ToInteger;
  
component PID_Controller
    Port (
        MCLK      : std_logic;
        kp        : in float32;
        ki        : in float32;
        kd        : in float32;
        SetPoint  : in float32;
        Measured  : in float32;
        Result    : out float32
    );
    end component;

signal setPoint  : float32;
signal PIDOut, prevPIDOut, Height : float32 := to_float(0.0);
      
begin
    setPoint <= to_float(4000.0) when InPWM = '1' else to_float(0.0);
    
    process (MCLK) begin
        if (falling_edge(MCLK)) then
            OutPWM <= float32ToInteger(to_Std_Logic_Vector(setPoint))(11 downto 0);
        end if;
        if (falling_edge(MCLK) and not (prevPIDOut = PIDOut)) then
            prevPIDOut <= PIDOut;
            Height <= Height + PIDOut;
        end if;
    end process;
    
    PID_ALTITUDE: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => to_float(1.0),  -- Altitude Kp
        ki        => to_float(0.05), -- Altitude Ki
        kd        => to_float(3.0),  -- Altitude Kd
        SetPoint  => setPoint, -- Wanted altitude
        Measured  => Height,   -- Measured altitude,
        Result    => PIDOut
    );
end Behavioral;
