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
USE ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top2 is
       
    Port (
        CLK      : in    STD_LOGIC;
        ready    : in    STD_LOGIC;
        reset    : in    STD_LOGIC;
        finish   : out   STD_LOGIC;
        output   : out   STD_LOGIC_VECTOR (7 downto 0)
       
           );
end top2;

architecture Behavioral of top2 is
signal count:       unsigned(10 downto 0) := (others => '0');
signal newCount:    unsigned(8 downto 0)  := (others => '0'); -- skal være 9 bit for at 0 til 256 
signal rise:        unsigned(7 downto 0) := (others => '0');
signal go:          std_logic;
signal state:       std_logic;
signal halt:        std_logic;
--signal scaleClk   STD_LOGIC;
constant newPWM :   INTEGER := 256;
constant desVal :   INTEGER := 255;
CONSTANT high   :   INTEGER := 942;
begin
process(CLK) 
   
begin
go <= '1';
if(CLK'event and CLK = '1') then

    if(ready = '1') then
        go <= '1';
    end if;

    if(reset = '1') then
        go <= '1';
        halt <= '0';
    end if;
   
    --if (halt = '1') then
        --rise <= "00000000";
        --output <= std_logic_vector(unsigned(rise));
   --end if;
        
    if (go = '1') then    
    count <= count +1; 
 
    if(count = high) then
        count <= "00000000000";
        newCount <= newCount +1;
    end if;
    
    if( newCount = newPWM) then
            newCount <= (others => '0');
            rise <= rise +1;
            output <= std_logic_vector(unsigned(rise));
    end if;
    
     if(rise = desVal) then
            state <= '1';
     end if;
    
    if (newCount = newPWM AND state = '1') then
            newCount <= (others => '0');
            rise <= rise -1;
            output <= std_logic_vector(unsigned(rise));
    end if;
        
    if(rise = 0 AND state = '1') then
            --state <= state;
            finish <= '1';
            go <= '0';    
            --halt <= '1';     
    end if;

 end if;
end if;      
end process;
end Behavioral;