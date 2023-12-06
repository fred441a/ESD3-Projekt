library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package shared_types is
    CONSTANT setupReg                       : INTEGER := 1;  -- 0x01
    CONSTANT altitudeWanted                 : INTEGER := 2;  -- 0x02
    CONSTANT altitudeP                      : INTEGER := 3;  -- 0x03
    CONSTANT altitudeI                      : INTEGER := 4;  -- 0x04
    CONSTANT altitudeD                      : INTEGER := 5;  -- 0x05
    CONSTANT pitchWanted                    : INTEGER := 6;  -- 0x06
    CONSTANT pitchP                         : INTEGER := 7;  -- 0x07
    CONSTANT pitchI                         : INTEGER := 8;  -- 0x08
    CONSTANT pitchD                         : INTEGER := 9;  -- 0x09
    CONSTANT pitchTrim                      : INTEGER := 10; -- 0x0A
    CONSTANT rollWanted                     : INTEGER := 11; -- 0x0B
    CONSTANT rollP                          : INTEGER := 12; -- 0x0C
    CONSTANT rollI                          : INTEGER := 13; -- 0x0D
    CONSTANT rollD                          : INTEGER := 14; -- 0x0E
    CONSTANT rollTrim                       : INTEGER := 15; -- 0x0F
    CONSTANT yawWanted                      : INTEGER := 16; -- 0x10
    CONSTANT yawP                           : INTEGER := 17; -- 0x11
    CONSTANT yawI                           : INTEGER := 18; -- 0x12
    CONSTANT yawD                           : INTEGER := 19; -- 0x13
    CONSTANT yawTrim                        : INTEGER := 20; -- 0x14
    CONSTANT PWMOut                         : INTEGER := 21; -- 0x15
    CONSTANT altitudeI2CSlaveSetup          : INTEGER := 22; -- 0x16
    CONSTANT altitudeI2CSlaveAdresses       : INTEGER := 23; -- 0x17
    CONSTANT altitudeI2CSlaveValues         : INTEGER := 24; -- 0x18
    CONSTANT magnetometerI2CSlaveSetup      : INTEGER := 25; -- 0x19
    CONSTANT magnetometerI2CSlaveAdressesX  : INTEGER := 26; -- 0x1A
    CONSTANT magnetometerI2CSlaveValuesX    : INTEGER := 27; -- 0x1B
    CONSTANT magnetometerI2CSlaveAdressesY  : INTEGER := 28; -- 0x1C
    CONSTANT magnetometerI2CSlaveValuesY    : INTEGER := 29; -- 0x1D
    CONSTANT magnetometerI2CSlaveAdressesZ  : INTEGER := 30; -- 0x1E
    CONSTANT magnetometerI2CSlaveValuesZ    : INTEGER := 31; -- 0x1F
    CONSTANT gyroscopeI2CSlaveSetup         : INTEGER := 32; -- 0x20
    CONSTANT gyroscopeI2CSlaveAdressesX     : INTEGER := 33; -- 0x21
    CONSTANT gyroscopeI2CSlaveValuesX       : INTEGER := 34; -- 0x22
    CONSTANT gyroscopeI2CSlaveAdressesY     : INTEGER := 35; -- 0x23
    CONSTANT gyroscopeI2CSlaveValuesY       : INTEGER := 36; -- 0x24
    CONSTANT gyroscopeI2CSlaveAdressesZ     : INTEGER := 37; -- 0x25
    CONSTANT gyroscopeI2CSlaveValuesZ       : INTEGER := 38; -- 0x26
    CONSTANT accelerometerI2CSlaveSetup     : INTEGER := 39; -- 0x27
    CONSTANT accelerometerI2CSlaveAdressesX : INTEGER := 40; -- 0x28
    CONSTANT accelerometerI2CSlaveValuesX   : INTEGER := 41; -- 0x29
    CONSTANT accelerometerI2CSlaveAdressesY : INTEGER := 42; -- 0x2A
    CONSTANT accelerometerI2CSlaveValuesY   : INTEGER := 43; -- 0x2B
    CONSTANT accelerometerI2CSlaveAdressesZ : INTEGER := 44; -- 0x2C
    CONSTANT accelerometerI2CSlaveValuesZ   : INTEGER := 45; -- 0x2D
	
	CONSTANT maxAddress : INTEGER := 45;
	CONSTANT wordSize   : INTEGER := 32;
    TYPE ram_type IS ARRAY (natural range 0 to maxAddress) OF std_logic_vector (wordSize-1 DOWNTO 0);
end package;