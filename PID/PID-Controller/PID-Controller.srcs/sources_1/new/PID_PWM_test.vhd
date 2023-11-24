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
    
    --OutPWM <= std_logic_vector(to_unsigned(to_integer(PIDOut), OutPWM'length));
     
    process (MCLK) begin
        if (rising_edge(MCLK)) then
            if (InPWM = '1') then
                setPoint <= to_float(4000.0); 
            else 
                setPoint <= to_float(0.0);
            end if;
        end if;
        if (falling_edge(MCLK)) then
            OutPWM <= std_logic_vector(to_unsigned(TO_INTEGER(setPoint), OutPWM'length)); --to_integer(setPoint)
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
