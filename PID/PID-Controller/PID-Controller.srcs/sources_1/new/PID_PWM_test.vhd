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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PID_PWM_test is
    Port ( MCLK : in std_logic;
           InPWM : in STD_LOGIC;
           OutPWM : out STD_LOGIC_VECTOR(11 downto 0)
           );
end PID_PWM_test;

architecture Behavioral of PID_PWM_test is

component PID_Controller
    Port (
        MCLK      : std_logic;
        kp        : in real;
        ki        : in real;
        kd        : in real;
        SetPoint  : in real;
        Measured  : in real;
        Result    : out real
    );
    end component;

signal setPoint : Real;
signal PIDOut : Real;
signal Height: Real;
signal Converter: integer ;
begin
    setPoint <= 4000.0 when InPWM = '1' else 0.0;
    Height <= Height + PIDOut ;
    Converter <= integer(;
    OutPWM <= std_logic_vector (TO_UNSIGNED (Converter,OutPWM'length));
    PID_ALTITUDE: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => 1.0,  -- Altitude Kp
        ki        => 0.05, -- Altitude Ki
        kd        => 3.0,  -- Altitude Kd
        SetPoint  => setPoint, -- Wanted altitude
        Measured  => Height, -- Measured altitude,
        Result    => PIDOut
    );

end Behavioral;
