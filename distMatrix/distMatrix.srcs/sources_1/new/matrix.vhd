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
signal pitchRollVal:            float32:= to_float(576.0);
signal yawVal:                  float32:= to_float(357.0);
signal latVal:                  float32:= to_float(178.0);
-- Matlab script stops
signal liftConst:                   float32:= to_float((3.3)*0.2250); -- Tallet inde 
--

signal r0:  float32;
signal r1:  float32;
signal r2:  float32;
signal r3:  float32;
signal opVal:                       std_logic_vector (1 downto 0) := (others => '0');

signal        data0:     float32;
signal        data1:     float32;
signal        op:        std_logic_vector (1 downto 0);
signal        inData:    float32;

signal        temp:      float32;
signal        tempRes:   float32 := (others => '0');

type tstate is (MULTr0, MULTr1, MULTr2, MULTr3, PLUSc0, PLUSc1, PLUSc2, PLUSc3, READr0, READr1, READr2, READr3);
signal state    :tstate := MULTr0;

type tstatec0 is (PLUSc00, PLUSc01, PLUSc02, PLUSc03, READc00, READc01, READc02);
signal c0state   :tstatec0 :=PLUSc01;

type tstatec1 is (PLUSc10, PLUSc11, PLUSc12, PLUSc13, READc10, READc11, READc12);
signal c1state   :tstatec1 :=PLUSc10;

type tstatec2 is (PLUSc20, PLUSc21, PLUSc22, PLUSc23, READc20, READc21, READc22);
signal c2state   :tstatec2 :=PLUSc20;

type tstatec3 is (PLUSc30, PLUSc31, PLUSc32, PLUSc33, READc30, READc31, READc32);
signal c3state   :tstatec3 :=PLUSc30;
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
        when MULTr0 =>
            data0 <= pitchRollVal;
            data1 <= pidPitch;
            op <= "11";
            state <= READr0;
        when READr0 =>
            r0 <= inData;
            state <= MULTr1;
                
        when MULTr1 =>
            data0 <= pitchRollVal;
            data1 <= pidRoll;
            op <= "11";
            state <= READr1;
        when READr1 =>                    
            r1 <= inData;
            state <= MULTr2;
            
        when MULTr2 =>
            data0 <= yawVal;
            data1 <= pidYaw;
            op <= "11";
            state <= READr2;
        when READr2 =>                   
            r2 <= inData;
            state <= MULTr3;
            
        when MULTr3 =>
            data0 <= latVal;
            data1 <= pidLat;
            op <= "11";
            state <= READr3;
        when READr3 =>                 
            r3 <= inData;
            state <= PLUSc0;
        when PLUSc0 =>
            case c0state is
            
                when PLUSc00 =>
                    data0 <= r0;
                    data1 <= r1;
                    op <= "11";
                    c0state <= READc00;
                when READc00 =>     
                    temp <= inData;
                    tempRes <= tempRes + temp;
                    c0state <= PLUSc01;
                    
                when PLUSc01 =>
                    data0 <= tempRes;
                    data1 <= r2;
                    op <= "01";
                    c0state <= READc01;
               when READc01 =>     
                    temp <= inData;
                    tempRes <= tempRes + temp;
                    c0state <= PLUSc02;
                    
                when PLUSc02 =>
                    data0 <= tempRes;
                    data1 <= r3;
                    op <= "01";
                    c0state <= READc02;
                when READc02 =>    
                    temp <= inData;
                    ch0 <= tempRes + temp;
                when others =>
                end case;
       state <= PLUSc1;
                
       when others =>
       end case;
       
            
end if;
end process;
end Behavioral;
