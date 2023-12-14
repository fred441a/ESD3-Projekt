----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.05.2023 08:47:53
-- Design Name: 
-- Module Name: idk2 - Behavioral
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
--      16 bit normalized float input
--      Float format: sign | 6 bits exponent + 31 | 9 bits normalized fraction
--      Fungerer kun med normalizerede floating points
--      Bruger standarden IEEE - 754
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all; 


entity multiplikation is
    Port ( x_in : in STD_LOGIC_VECTOR (15 downto 0);
           y_in : in STD_LOGIC_VECTOR (15 downto 0);
           sum : out STD_LOGIC_VECTOR (15 downto 0)                 --;
--           sum_exponent_2 : out std_logic_vector (6 downto 0);    -- Til evt test
--           sum_aux : out std_logic_vector (19 downto 0)           -- Til evt test
           );
end multiplikation;

architecture Behavioral of multiplikation is
begin
    process (x_in, y_in)
        variable x_mantissa : std_logic_vector (8 downto 0);
        variable x_exponent : std_logic_vector (5 downto 0);
        variable x_sign : std_logic;
        
        variable y_mantissa : std_logic_vector (8 downto 0);
        variable y_exponent : std_logic_vector (5 downto 0);
        variable y_sign : std_logic;
        
        variable z_mantissa : STD_LOGIC_VECTOR (8 downto 0);
		variable z_exponent : STD_LOGIC_VECTOR (5 downto 0);
		variable z_sign : STD_LOGIC;
		
		variable aux : std_logic_vector (19 downto 0);
		variable aux2 : std_logic;
		variable sum_exponent : std_logic_vector (6 downto 0);
        


    begin
--              Her splittes floating point input op    
        x_mantissa := x_in (8 downto 0);
        x_exponent := x_in (14 downto 9);
        x_sign := x_in(15);
        
        y_mantissa := y_in (8 downto 0);
        y_exponent := y_in (14 downto 9);
        y_sign := y_in(15);
        
        
        -- Udregning af fraction/mantissa
        aux := ('1' & x_mantissa) * ('1' & y_mantissa);
--        sum_aux <= aux;
        if (aux(19) = '1') then
            z_mantissa := aux(18 downto 10) + aux(9); -- med afrunding
            aux2 := '1';
        else
            z_mantissa := aux(17 downto 9) + aux(8); -- med afrunding
            aux2 := '0';
        end if;
        
        
        -- Udregning af exponenten
        sum_exponent := ('0' & x_exponent) + ('0' & y_exponent) + aux2 - 31;
--        sum_exponent_2 <= sum_exponent;
             if (sum_exponent(6) = '1') then
                if (sum_exponent(5) = '0') then     -- Overflow
                    z_exponent := "111111";
                    z_mantissa := (others => '0');
                    z_sign := x_sign xor y_sign;
                else                                -- Underflow
                    z_exponent := (others => '0');
                    z_mantissa := (others => '0');
                    z_sign := '0';
                end if;
            else
                z_exponent := sum_exponent(5 downto 0);
                z_sign := x_sign xor y_sign;
            end if;
            
            sum(8 downto 0) <= z_mantissa;      -- 9 bit
            sum(14 downto 9) <= z_exponent;     -- 6 bit
            sum(15) <= z_sign;                  -- 1 bit
            
    end process;
end Behavioral;
