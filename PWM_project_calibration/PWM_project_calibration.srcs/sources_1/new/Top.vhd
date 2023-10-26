----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/27/2023 11:49:18 AM
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
    Port ( CLK :        in STD_LOGIC;
           PWM :        out std_logic_vector (3 downto 0);
           ready :      in std_logic;
           inter_ready: out std_logic
            );
end Top;

architecture Behavioral of Top is
signal count:   unsigned(7 downto 0) := (others => '0');
signal rise:    unsigned(7 downto 0) := (others => '0');
signal state:   unsigned(1 downto 0) := (others => '0');
begin 


process(CLK)

begin

if(ready = '1') then
       if(CLK'event and CLK = '1') then
           if(state = 0) then
                count <= count +1;
                
                --PWM channel 0
                if(count < unsigned(rise)) then
                    PWM(0) <= '1';
                else
                    PWM(0) <= '0';
                end if;
                
                --PWM channel 1
                if(count < unsigned(rise)) then
                    PWM(1) <= '1';
                else
                    PWM(1) <= '0';
                end if;
                
                --PWM channel 2
                if(count < unsigned(rise)) then
                    PWM(2) <= '1';
                else
                    PWM(2) <= '0';
                end if;
                
                --PWM channel 3
                if(count < unsigned(rise)) then
                    PWM(3) <= '1';
                else
                    PWM(3) <= '0';
                end if;
                
                if(count > 254) then
                    count <= TO_UNSIGNED(0,8);
                    rise <= rise+5;     
                   -- PWM <= "1111";         
                end if;
                
                if(rise > 249) then
                count <= TO_UNSIGNED(0,8);
                state <= state +1;
                end if;
            end if;
            
        if(state = 1) then
            count <= count +1;  
                --PWM channel 0
                if(count < unsigned(rise)) then
                    PWM(0) <= '1';
                else
                    PWM(0) <= '0';
                end if;
                
                --PWM channel 1
                if(count < unsigned(rise)) then
                    PWM(1) <= '1';
                else
                    PWM(1) <= '0';
                end if;
                
                --PWM channel 2
                if(count < unsigned(rise)) then
                    PWM(2) <= '1';
                else
                    PWM(2) <= '0';
                end if;
                
                --PWM channel 3
                if(count < unsigned(rise)) then
                    PWM(3) <= '1';
                else
                    PWM(3) <= '0';
                end if;
                
                if(count > 254) then
                    rise <= rise-5;     
                   -- PWM <= "1111";         
                end if;
                
                if(rise < 6 ) then
                    count <= TO_UNSIGNED(0,8);                
                    state <= state +1;
                end if;
            end if;
            
        if(state =2) then
            PWM <= "0000";
            count <= TO_UNSIGNED(0,8);
            inter_ready <= '1';
            end if;
      end if;
    end if;          
end process;

end Behavioral;
