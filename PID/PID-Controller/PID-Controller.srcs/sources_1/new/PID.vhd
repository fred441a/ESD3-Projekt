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
        MCLK        : in std_logic;
        EN          : in std_logic;
        kp          : in float32;
        ki          : in float32;
        kd          : in float32;
        SetPoint    : in float32;
        Measured    : in float32;
        Result      : out float32;
        ResultReady : out std_logic;
        
        -- fpu connections
        fpuVal0   : inout float32;
        fpuVal1   : inout float32;
        fpuOpCode : inout std_logic_vector(1 downto 0);
        fpuResult : in float32
    );
    end component;
    
    component FPU
    Port ( 
        input0 : in float32;
        input1 : in float32;
        CLK    : in STD_LOGIC;
        opVal  : in STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
        output : out float32
    ); 
    end component;
    
    TYPE tstate is (IDLE, ALTITUDE, PITCH, ROLL, YAW);
    signal state : tstate := ALTITUDE;    
    signal altitudeEn, pitchEn, rollEn, yawEn : std_logic;
    signal altitudeReady, pitchReady, rollReady, yawReady, aRqq, aRq,pRqq, pRq,rRqq, rRq, yRqq, yRq : std_logic;  
            
    -- shared fpu
    signal input0, input1, result : float32;
    signal fpuOpVal : std_logic_vector(1 downto 0);
    
    signal altInput0, altInput1, pitchInput0, pitchInput1, rollInput0, rollInput1, yawInput0, yawInput1 : float32;
    signal altFpuOpVal, pitchFpuOpVal,  rollFpuOpVal, yawFpuOpVal : std_logic_vector(1 downto 0);
    
begin
    
    SHARED_FPU : FPU
    Port map (
        CLK    => MCLK,
        input0 => input0,
        input1 => input1,
        opVal  => fpuOpVal,
        output => result
    );
    
    PID_ALTITUDE: PID_Controller
    Port map (
        MCLK      => MCLK,
        EN        => altitudeEn,
        kp        => to_float(MEMORY(16#03#)), -- Altitude Kp
        ki        => to_float(MEMORY(16#04#)), -- Altitude Ki
        kd        => to_float(MEMORY(16#05#)), -- Altitude Kd
        SetPoint  => to_float(MEMORY(16#02#)), -- Wanted altitude
        Measured  => to_float(MEMORY(16#18#)), -- Measured altitude,
        Result    => RES_ALTITUDE,
        ResultReady => altitudeReady,

        -- fpu connections
        fpuVal0   => altInput0,
        fpuVal1   => altInput1,
        fpuOpCode => altFpuOpVal,
        fpuResult => result
    );
    
    PID_PITCH: PID_Controller
    Port map (
        MCLK      => MCLK,
        EN        => pitchEn,
        kp        => to_float(MEMORY(16#07#)), -- Pitch Kp
        ki        => to_float(MEMORY(16#08#)), -- Pitch Ki
        kd        => to_float(MEMORY(16#09#)), -- Pitch Kd
        SetPoint  => to_float(MEMORY(16#06#)), -- Wanted Pitch
        Measured  => to_float(MEMORY(16#22#)), -- Measured Pitch around x-axis,
        Result    => RES_PITCH,
        ResultReady => pitchReady,
                
        -- fpu connections
        fpuVal0   => pitchInput0,
        fpuVal1   => pitchInput1,
        fpuOpCode => pitchFpuOpVal,
        fpuResult => result
    );
    
    PID_ROLL: PID_Controller
    Port map (
        MCLK      => MCLK,
        EN        => rollEn,
        kp        => to_float(MEMORY(16#0C#)), -- ROLL Kp
        ki        => to_float(MEMORY(16#0D#)), -- ROLL Ki
        kd        => to_float(MEMORY(16#0E#)), -- ROLL Kd
        SetPoint  => to_float(MEMORY(16#0B#)), -- Wanted ROLL
        Measured  => to_float(MEMORY(16#24#)), -- Measured ROLL around y-axis,
        Result    => RES_ROLL,
        ResultReady => rollReady,
        
        -- fpu connections
        fpuVal0   => rollInput0,
        fpuVal1   => rollInput1,
        fpuOpCode => rollFpuOpVal,
        fpuResult => result
    );
    
    PID_YAW: PID_Controller
    Port map (
        MCLK      => MCLK,
        EN        => yawEn,
        kp        => to_float(MEMORY(16#11#)), -- YAW Kp
        ki        => to_float(MEMORY(16#12#)), -- YAW Ki
        kd        => to_float(MEMORY(16#13#)), -- YAW Kd
        SetPoint  => to_float(MEMORY(16#10#)), -- Wanted YAW
        Measured  => to_float(MEMORY(16#26#)), -- Measured YAW around z-axis,
        Result    => RES_YAW,
        ResultReady => yawReady,
        
        -- fpu connections
        fpuVal0   => yawInput0,
        fpuVal1   => yawInput1,
        fpuOpCode => yawFpuOpVal,
        fpuResult => result
    );
        
    -- changing between PID controllers, 
    -- ensuring only one is running at a giventime as all use a shared fpu.
    -- all PID controllers will be updated at 166Khz with a MCLK@12Mhz
    process (MCLK) begin    
        if (rising_edge(MCLK)) then 
           aRqq <= aRq;
           aRq <= altitudeReady;           
           pRqq <= pRq;
           pRq <= pitchReady;           
           rRqq <= rRq;
           rRq <= rollReady;           
           yRqq <= yRq;
           yRq <= yawReady;
           
            case state is
                when ALTITUDE =>
                    altitudeEn <= '1';             
                    input0 <= altInput0;
                    input1 <= altInput1;
                    fpuOpVal <= altFpuOpVal;                    
                    if (aRqq = '0' and aRq = '1') then --rising_edge(altitudeReady)
                        altitudeEn <= '0';
                        state <= PITCH;                        
                    end if;                    
                when PITCH =>
                    pitchEn <= '1';             
                    input0 <= pitchInput0;
                    input1 <= pitchInput1;
                    fpuOpVal <= pitchFpuOpVal;
                    if (pRqq = '0' and pRq = '1') then --rising_edge(pitchReady)
                        pitchEn <= '0';
                        state <= ROLL;
                    end if;
                when ROLL =>
                    rollEn <= '1';             
                    input0 <= rollInput0;
                    input1 <= rollInput1;
                    fpuOpVal <= rollFpuOpVal;
                    if (rRqq = '0' and rRq = '1') then --rising_edge(rollReady)
                        rollEn <= '0';
                        state <= YAW;
                    end if;
                when YAW =>
                    yawEn <= '1';                                 
                    input0 <= yawInput0;
                    input1 <= yawInput1;
                    fpuOpVal <= yawFpuOpVal;
                    if (yRqq = '0' and yRq = '1') then --rising_edge(yawReady)
                        yawEn <= '0';
                        state <= ALTITUDE;
                    end if;
                when others =>
            end case;
        end if;
    end process;
end Behavioral;
