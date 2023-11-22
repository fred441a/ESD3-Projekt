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
use IEEE.float_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PID_PWM_test is
    Port ( 
        MCLK   : in std_logic;
        InPWM  : in STD_LOGIC;
        OutPWM : out STD_LOGIC_VECTOR(11 downto 0)
    );
end PID_PWM_test;

architecture Behavioral of PID_PWM_test is

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
signal PIDOut    : float32 := to_float(0);
signal Height    : float32 := to_float(0);
    
begin
    setPoint <= to_float(4000.0) when InPWM = '1' else to_float(0.0);
    OutPWM <= std_logic_vector(to_unsigned(to_integer(PIDOut), OutPWM'length));
    
    process (PIDOut) begin
        Height <= Height + PIDOut;
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
