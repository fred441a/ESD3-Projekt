----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2023 10:06:57 AM
-- Design Name: 
-- Module Name: PID - Behavioral
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
use ieee.float_pkg.all;
use work.shared_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PID is
    Port (
        MCLK         : in std_logic;
        MEMORY       : in ram_type;      
        RES_PITCH    : out float32;
        RES_ROLL     : out float32;
        RES_YAW      : out float32;
        RES_ALTITUDE : out float32
    );
end PID;

architecture Behavioral of PID is    
    
    component PID_Controller
    Port (
        MCLK     : std_logic;
        kp       : in float32;
        ki       : in float32;
        kd       : in float32;
        SetPoint : in float32;
        Measured : in float32;
        Result   : out float32
    );
    end component;
begin

    PID_ALTITUDE: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => to_float(MEMORY(16#03#)), -- Altitude Kp
        ki        => to_float(MEMORY(16#04#)), -- Altitude Ki
        kd        => to_float(MEMORY(16#05#)), -- Altitude Kd
        SetPoint  => to_float(MEMORY(16#02#)), -- Wanted altitude
        Measured  => to_float(MEMORY(16#18#)), -- Measured altitude,
        Result    => RES_ALTITUDE
    );
    
    PID_PITCH: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => to_float(MEMORY(16#07#)), -- Pitch Kp
        ki        => to_float(MEMORY(16#08#)), -- Pitch Ki
        kd        => to_float(MEMORY(16#09#)), -- Pitch Kd
        SetPoint  => to_float(MEMORY(16#06#)), -- Wanted Pitch
        Measured  => to_float(MEMORY(16#22#)), -- Measured Pitch around x-axis,
        Result    => RES_PITCH
    );
    
    PID_ROLL: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => to_float(MEMORY(16#0C#)), -- ROLL Kp
        ki        => to_float(MEMORY(16#0D#)), -- ROLL Ki
        kd        => to_float(MEMORY(16#0E#)), -- ROLL Kd
        SetPoint  => to_float(MEMORY(16#0B#)), -- Wanted ROLL
        Measured  => to_float(MEMORY(16#24#)), -- Measured ROLL around y-axis,
        Result    => RES_ROLL
    );
    
    PID_YAW: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => to_float(MEMORY(16#11#)), -- YAW Kp
        ki        => to_float(MEMORY(16#12#)), -- YAW Ki
        kd        => to_float(MEMORY(16#13#)), -- YAW Kd
        SetPoint  => to_float(MEMORY(16#10#)), -- Wanted YAW
        Measured  => to_float(MEMORY(16#26#)), -- Measured YAW around z-axis,
        Result    => RES_YAW
    );

end Behavioral;
