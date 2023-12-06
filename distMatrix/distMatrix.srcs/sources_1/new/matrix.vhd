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

component fpu is
    port (
    CLK: in            std_logic;
    input0: in          float32;
    input1: in          float32;
    opVal: in           STD_LOGIC_VECTOR (1 downto 0);
    output: out         float32
    );
end component;

-- These values are the inv og dist matrix. Take directly from Matlab Script
signal pitchRollVal:            float32:= to_float(5760.0);
signal yawVal:                  float32:= to_float(178570.0);
signal latVal:                  float32:= to_float(1786.0);
-- Matlab script stops
--signal liftConst:                   float32:= to_float((3.3)*0.2250); -- Dette her er et dummie tal 
--

signal c0:  float32;
signal c1:  float32;
signal c2:  float32;
signal c3:  float32;
signal opVal:                       std_logic_vector (1 downto 0) := (others => '0');

signal        data0:     float32;
signal        data1:     float32;
signal        op:        std_logic_vector (1 downto 0);
signal        inData:    float32;

signal        temp:      float32;
signal        tempRes:   float32 := (others => '0');

type tstate is (MULTc0, MULTc1, MULTc2, MULTc3, PLUSr0, PLUSr1, PLUSr2, PLUSr3, READc0, READc1, READc2, READc3);
signal state    :tstate := MULTc0;

type tstateR0 is (PLUSr00, PLUSr01, PLUSr02, PLUSr03, READr00, READr01, READr02);
signal r0state   :tstateR0 :=PLUSr01;

type tstateR1 is (PLUSr10, PLUSr11, PLUSr12, PLUSr13, READr10, READr11, READr12);
signal r1state   :tstater1 :=PLUSr10;

type tstateR2 is (PLUSr20, PLUSr21, PLUSr22, PLUSr23, READr20, READr21, READr22);
signal r2state   :tstater2 :=PLUSr20;

type tstateR3 is (PLUSr30, PLUSr31, PLUSr32, PLUSr33, READr30, READr31, READr32);
signal r3state   :tstateR3 :=PLUSr30;
begin

fpuCalculations: fpu
port map (
    CLK => MCLK,
    input0 => data0,
    input1 => data1,
    opVal => op,
    output => inData
    );

process(MCLK)

begin
if(MCLK'event and MCLK = '1') then
    case  state is 
        when MULTc0 =>
            data0 <= pitchRollVal;
            data1 <= pidPitch;
            op <= "11";
            state <= READc0;
        when READc0 =>
            c0 <= inData;
            state <= MULTc1;
                
        when MULTc1 =>
            data0 <= pitchRollVal;
            data1 <= pidRoll;
            op <= "11";
            state <= READc1;
        when READc1 =>                    
            c1 <= inData;
            state <= MULTc2;
            
        when MULTc2 =>
            data0 <= yawVal;
            data1 <= pidYaw;
            op <= "11";
            state <= READc2;
        when READc2 =>                   
            c2 <= inData;
            state <= MULTc3;
            
        when MULTc3 =>
            data0 <= latVal;
            data1 <= pidLat;
            op <= "11";
            state <= READc3;
        when READc3 =>                 
            c3 <= inData;
            state <= PLUSr0;
        when PLUSr0 =>
            case r0state is
                when PLUSr00 =>
                    tempRes <= (others => '0');
                    data0 <= c0;
                    data1 <= c1;
                    op <= "01"; -- plus
                    r0state <= READr00;
                when READr00 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r0state <= PLUSr01;
                    
                when PLUSr01 =>
                    data0 <= tempRes;
                    data1 <= c2;
                    op <= "01"; --plus
                    r0state <= READr01;
               when READr01 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r0state <= PLUSr02;
                    
                when PLUSr02 =>
                    data0 <= tempRes;
                    data1 <= c3;
                    op <= "01"; --Plus
                    r0state <= READr02;
                when READr02 =>    
                    temp <= inData;
                    ch0 <= temp;
                when others =>
                end case;
       state <= PLUSr1;
       
       when PLUSr1 =>
            case r1state is
                when PLUSr10 =>
                    tempRes <= (others => '0');
                    data0 <= c0;
                    data1 <= c1;
                    op <= "10"; --Minus
                    r1state <= READr10;
                when READr10 =>     
                    temp <= inData;
                    tempRes <=temp;
                    r1state <= PLUSr11;
                    
                when PLUSr11 =>
                    data0 <= tempRes;
                    data1 <= c2;
                    op <= "10"; --minus
                    r1state <= READr11;
               when READr11 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r1state <= PLUSr12;
                    
                when PLUSr12 =>
                    data0 <= tempRes;
                    data1 <= c3;
                    op <= "01"; --plus
                    r1state <= READr12;
                when READr12 =>    
                    temp <= inData;
                    ch1 <= temp;
                when others =>
                end case;
        state <= PLUSr2;
       when PLUSr2 =>
            case r2state is
                when PLUSr20 =>
                    tempRes <= (others => '0');
                    data0 <= c3;
                    data1 <= c2;
                    op <= "01"; --Plus
                    r2state <= READr20;
                when READr20 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r2state <= PLUSr21;
                    
                when PLUSr21 =>
                    data0 <= tempRes;
                    data1 <= c1;
                    op <= "10"; --Plus
                    r2state <= READr21;
               when READr21 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r2state <= PLUSr22;
                    
                when PLUSr22 =>
                    data0 <= tempRes;
                    data1 <= c0;
                    op <= "10"; --minus
                    r2state <= READr22;
                when READr22 =>    
                    temp <= inData;
                    ch2 <= temp;
                when others =>
                end case;
       state <= PLUSr2;
       when PLUSr3 =>
            case r3state is
                when PLUSr30 =>
                    tempRes <= (others => '0');
                    data0 <= c3;
                    data1 <= c2;
                    op <= "10"; --minus
                    r3state <= READr30;
                when READr30 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r3state <= PLUSr31;
                    
                when PLUSr31 =>
                    data0 <= tempRes;
                    data1 <= c1;
                    op <= "01"; --plus
                    r3state <= READr31;
               when READr31 =>     
                    temp <= inData;
                    tempRes <= temp;
                    r3state <= PLUSr32;
                    
                when PLUSr32 =>
                    data0 <= tempRes;
                    data1 <= c0;
                    op <= "10"; --minus
                    r3state <= READr32;
                when READr32 =>    
                    temp <= inData;
                    ch3 <= temp;
                when others =>
                end case;    
       when others =>
       end case;
       
            
end if;
end process;
end Behavioral;
