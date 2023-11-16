----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2023 09:31:27 AM
-- Design Name: 
-- Module Name: pwmModule - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwmModule is
Port (     PercentCh0 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           PercentCh1 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           PercentCh2 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           PercentCh3 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           clock      : in STD_LOGIC; -- 12M hz internal clock
           PWM : out std_logic_vector (3 downto 0));
end pwmModule;

architecture Behavioral of pwmModule is
signal count: unsigned(6 downto 0) := (others => '0');
CONSTANT high       :   INTEGER := 117; -- To descale clock to 50 Hz
signal sclCount     :   unsigned(10 downto 0)  := (others => '0'); -- 2^11 = 2048  
begin

process(clock)
 
    begin
    
    if(clock'event and clock = '1') then --Clock divider so clock is 50 Hz instead of 12MHz
    count <= count +1;
        if(count = high) then
            count <= (others => '0');
            sclCount <= sclCount +1;
            
        end if;
        
            --PWM channel 0
            if(sclCount +1 <= unsigned(PercentCh0)) then --Creates a pwm, with 256 increaments from a integere
                PWM(0) <= '1'; -- If scale count is smaller, turn on.
            else
                PWM(0) <= '0'; -- If sclCount+1 is/equal bigger, turn of. +1 is to ensure 0 = 1 pulse in pwm.
            end if;
            
            --PWM channel 1
            if(sclCount +1 <= unsigned(PercentCh1)) then
                PWM(1) <= '1';
            else
                PWM(1) <= '0';
            end if;
            
            --PWM channel 2
            if(sclCount +1 <= unsigned(PercentCh2)) then
                PWM(2) <= '1';
            else
                PWM(2) <= '0';
            end if;
            
            --PWM channel 3
            if(sclCount +1 <= unsigned(PercentCh3)) then
                PWM(3) <= '1';
            else
                PWM(3) <= '0';
            end if;
                                    
        end if;
    end process;

end Behavioral;
