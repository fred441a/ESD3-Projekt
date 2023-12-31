----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2023 10:04:18 AM
-- Design Name: 
-- Module Name: createCalibration - Behavioral
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
use IEEE.numeric_std.ALL;
USE ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity createCalibration is
       
    Port (
        CLK      : in    STD_LOGIC; -- 12M hz internal clock
        ready    : in    STD_LOGIC;-- Flag form user
        finish   : out   STD_LOGIC; -- Flag to say it is done
        output   : out   STD_LOGIC_VECTOR (7 downto 0) -- Out put to become pwm
           );
end createCalibration;

architecture Behavioral of createCalibration is
signal count:       unsigned(6 downto 0) := (others => '0'); -- To descale clock
signal clkDivider:   unsigned(11 downto 0)  := (others => '0'); -- skal v�re 12 bit for at n� 2048
signal rise:        unsigned(7 downto 0) := "00101111"; -- To make it go up and then down
signal hold:        unsigned(7 downto 0) := (others => '0');
signal go:          std_logic := '0'; -- Internal flag so the code can start
signal state:       std_logic_vector (1 downto 0) := "00"; -- Has the purpos of inc and dec, calibration
signal halt:        std_logic := '0'; -- Stops the code from running. Is set low at the end of calibration cycle.
constant newPWM :   INTEGER := 2327; -- otherwise it will be 1 clock Cycles slower the PWM modul and then trail
constant desVal :   INTEGER := 254; -- Desired val pwm wil go uo to. 255 = 100% of duty cycle. Has to been one smaller then max
CONSTANT high   :   INTEGER := 103; -- To descale clock so it ends with roughly 50 Hz
begin
process(CLK) 

begin

if(CLK'event and CLK = '1') then
-- Waiting ()


--Ready starts
    if(ready = '1') then --Ready given by the user
        go <= '1';
    end if;
-- Ready ends    
           
    if (go = '1' AND halt = '0') then -- Enters this part when ready is given by user
    
 --Descaling clock begins    
    count <= count +1; 

        if(count = high) then
            count <= (others => '0');
            clkDivider <= clkDivider +1; -- Creates a new clock cycle count
        end if;
-- Descaling clock ends

-- Rising begins    
        if( clkDivider = newPWM AND state = "00") then
            clkDivider <= (others => '0');
            rise <= rise +1; -- increases by one
            output <= std_logic_vector(unsigned(rise)); -- sends it to pwmModule
                if(rise = desVal) then -- Changes state so it will decrease can happen
                    state <= "01";
                end if;
        end if;
    
-- Rising ends

    if (clkDivider = newPwm AND state = "01") then
        clkDivider <= (others => '0');
            hold <= hold + 1;
            if (hold >= 150) then -- roughly 1 seconds as 50hz
                state <= "10";
            end if;      
    end if;
    
-- Falling begins    
        if (clkDivider = newPWM AND state = "10") then
            clkDivider <= (others => '0');
            rise <= rise -1; -- decreases one by one
            output <= std_logic_vector(unsigned(rise));
        end if;
-- Falling ends

--Finished begins        
        if(rise = 69 AND state = "10") then -- It has finished calibration now
            finish <= '1'; -- external flag, to say it is finished calibrating
            halt <= '1'; --Makes sure the procces ends.  
        end if;
-- Finished ends
    end if;
    
end if;      
end process;
end Behavioral;