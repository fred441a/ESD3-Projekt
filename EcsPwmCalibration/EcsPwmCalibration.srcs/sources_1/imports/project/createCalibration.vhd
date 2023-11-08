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
        ready    : in    STD_LOGIC; -- Flag form user
        finish   : out   STD_LOGIC; -- Flag to say it is done
        output   : out   STD_LOGIC_VECTOR (7 downto 0) -- Out put to become pwm
       
           );
end createCalibration;

architecture Behavioral of createCalibration is
signal count:       unsigned(10 downto 0) := (others => '0'); -- To descale clock
signal pwmCreate:   unsigned(8 downto 0)  := (others => '0'); -- skal være 9 bit for at 0 til 256 
signal rise:        unsigned(7 downto 0) := (others => '0'); -- To make it go up and then down
signal go:          std_logic := '0'; -- Internal flag so the code can start
signal state:       std_logic := '0'; -- Has the purpos of inc and dec, calibration
signal halt:        std_logic := '0'; -- Stops the code from running. Is set low at the end of calibration cycle.
constant newPWM :   INTEGER := 256; -- otherwise it will be 1 clock Cycles slower the PWM modul and then trail
constant desVal :   INTEGER := 255; -- Desired val pwm wil go uo to. 255 = 100% of duty cycle
CONSTANT high   :   INTEGER := 942; -- To descale clock so it ends with roughly 50 Hz
begin
process(CLK) 

begin

if(CLK'event and CLK = '1') then

    if(ready = '1') then --Ready given by the user
        go <= '1';
    end if;
           
    if (go = '1' AND halt = '0') then -- Enters this part when ready is given by user
    count <= count +1; 
 
        if(count = high) then
        count <= "00000000000";
        pwmCreate <= pwmCreate +1; -- Creates a new clock cycle count
        end if;
    
        if( pwmCreate = newPWM) then
            pwmCreate <= (others => '0');
            rise <= rise +1; -- increases by one
            output <= std_logic_vector(unsigned(rise)); -- sends it to pwmModule
        end if;
    
        if(rise = desVal) then -- Changes state so it will decrease
            state <= '1';
        end if;
    
        if (pwmCreate = newPWM AND state = '1') then
            rise <= (others => '0');
            rise <= rise -1; -- decreases one by one
            output <= std_logic_vector(unsigned(rise));
        end if;
        
        if(rise = 0 AND state = '1') then -- It has ended, it endeds
            count <= "00000000000";
            rise <= (others => '0');
            go <= '0';
            finish <= '1'; -- external flag, flag   
            halt <= '1'; --Makes sure the procces ends.
            state <= '0';    
        end if;
        
    elsif (halt = '1')then -- Makes sure the output from here is zero.
        rise <= (others => '0');
        output <= std_logic_vector(unsigned(rise));
    end if;
    
end if;      
end process;
end Behavioral;