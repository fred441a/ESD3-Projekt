----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2023 10:04:18 AM
-- Design Name: 
-- Module Name: top2 - Behavioral
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

entity top2 is
    Port ( ready : in STD_LOGIC;
           CLK : in STD_LOGIC;
           inter_ready : out STD_LOGIC;
           PWM : out STD_LOGIC_VECTOR );
end top2;

architecture Behavioral of top2 is
signal count:   unsigned(7 downto 0) := (others => '0');
signal rise:    unsigned(7 downto 0) := (others => '0');
signal state:   unsigned(1 downto 0) := (others => '0');
signal go:      unsigned(1 downto 0) := (others => '0');
begin

process(CLK)

begin
      if (ready = '1') then
        go <= go +1; 
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
             go <= go - 1;  
            end if;
      end if; 
     end if;      
end process;

end Behavioral;