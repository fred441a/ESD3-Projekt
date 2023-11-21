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
        MCLK : in std_logic;
        MEMORY : in ram_type;      
        RES_PITCH : out real;
        RES_ROLL : out real;
        RES_YAW : out real;
        RES_ALTITUDE : out real
    );
end PID;

architecture Behavioral of PID is
   function ConvertFloatToReal(float_input : STD_LOGIC_VECTOR(31 downto 0)) return REAL is
        variable sign : BOOLEAN;
        variable exponent : INTEGER;
        variable fraction : REAL;
    begin
        -- Interpret 32-bit float representation
        sign := float_input(31) = '1';
        exponent := to_integer(unsigned(float_input(30 downto 23))) - 127;
        fraction := 1.0 + Real(to_integer(unsigned(float_input(22 downto 0)))) / 2.0**23;
        
        -- Output VHDL real based on interpretation
        if sign then
            return -fraction * 2.0**exponent;
        else
            return fraction * 2.0**exponent;
        end if;
    end ConvertFloatToReal;
    
    
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
begin

    PID_ALTITUDE: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => ConvertFloatToReal(MEMORY(16#03#)), -- Altitude Kp
        ki        => ConvertFloatToReal(MEMORY(16#04#)), -- Altitude Ki
        kd        => ConvertFloatToReal(MEMORY(16#05#)), -- Altitude Kd
        SetPoint  => ConvertFloatToReal(MEMORY(16#02#)), -- Wanted altitude
        Measured  => Real(to_integer(unsigned(MEMORY(16#18#)))), -- Measured altitude,
        Result    => RES_ALTITUDE
    );
    
    PID_PITCH: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => ConvertFloatToReal(MEMORY(16#07#)), -- Pitch Kp
        ki        => ConvertFloatToReal(MEMORY(16#08#)), -- Pitch Ki
        kd        => ConvertFloatToReal(MEMORY(16#09#)), -- Pitch Kd
        SetPoint  => ConvertFloatToReal(MEMORY(16#06#)), -- Wanted Pitch
        Measured  => Real(to_integer(unsigned(MEMORY(16#22#)))), -- Measured Pitch around x-axis,
        Result    => RES_PITCH
    );
    
    PID_ROLL: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => ConvertFloatToReal(MEMORY(16#0C#)), -- ROLL Kp
        ki        => ConvertFloatToReal(MEMORY(16#0D#)), -- ROLL Ki
        kd        => ConvertFloatToReal(MEMORY(16#0E#)), -- ROLL Kd
        SetPoint  => ConvertFloatToReal(MEMORY(16#0B#)), -- Wanted ROLL
        Measured  => Real(to_integer(unsigned(MEMORY(16#24#)))), -- Measured ROLL around y-axis,
        Result    => RES_ROLL
    );
    
    PID_YAW: PID_Controller
    Port map (
        MCLK      => MCLK,
        kp        => ConvertFloatToReal(MEMORY(16#11#)), -- YAW Kp
        ki        => ConvertFloatToReal(MEMORY(16#12#)), -- YAW Ki
        kd        => ConvertFloatToReal(MEMORY(16#13#)), -- YAW Kd
        SetPoint  => ConvertFloatToReal(MEMORY(16#10#)), -- Wanted YAW
        Measured  => Real(to_integer(unsigned(MEMORY(16#26#)))), -- Measured YAW around z-axis,
        Result    => RES_YAW
    );

end Behavioral;
