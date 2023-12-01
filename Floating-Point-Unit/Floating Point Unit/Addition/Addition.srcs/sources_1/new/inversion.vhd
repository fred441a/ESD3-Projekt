----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2023 21:24:39
-- Design Name: 
-- Module Name: inversion - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity inversion is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
           z : out std_logic_vector (31 downto 0);--);
           
           y_mantissa_out : out std_logic_vector (23 downto 0);
           y_mantissa2_out : out std_logic_vector (22 downto 0);
           index_out : out std_logic_vector(23 downto 0);
           index2_out : out std_logic_vector(23 downto 0)
           );
end inversion;

architecture Behavioral of inversion is
begin
process (x,y)
        variable x_exponent : std_logic_vector (7 downto 0);
        variable x_mantissa : std_logic_vector (22 downto 0);
        variable x_sign : std_logic;
        
        variable y_exponent : std_logic_vector (7 downto 0);
        variable y_mantissa : std_logic_vector (22 downto 0);
        variable y_sign : std_logic;
        
        variable z_exponent : std_logic_vector (7 downto 0);
        variable z_mantissa : std_logic_vector (22 downto 0);
        variable z_sign : std_logic;
        
        variable exp_diff : std_logic_vector (7 downto 0);
        variable y_new_mantissa : std_logic_vector (23 downto 0);
        variable y_new_mantissa2 :std_logic_vector (22 downto 0);
        variable x_new_mantissa : std_logic_vector (22 downto 0);
        variable y_negated_mantissa : std_logic_vector (23 downto 0);
        variable x_negated_mantissa : std_logic_vector (22 downto 0);
        
        variable aux : std_logic_vector (23 downto 0);
        variable aux2 : std_logic_vector (23 downto 0);
        variable index : std_logic_vector (23 downto 0);
        variable index2 : std_logic_vector (23 downto 0);
        variable norm_count : integer := 0;
        variable sum : std_logic_vector (31 downto 0);
    begin
        x_mantissa := x(22 downto 0);
		x_exponent := x(30 downto 23);
		x_sign := x(31);
		y_mantissa := y(22 downto 0);
		y_exponent := y(30 downto 23);
		y_sign := y(31);
        
    if (x_exponent > y_exponent) then
        exp_diff := x_exponent - y_exponent;
        aux := ('1' & y_mantissa);
        aux2 := ('1' & x_mantissa);
        y_new_mantissa := std_logic_vector(shift_right(unsigned(aux) , to_integer(unsigned(exp_diff))));
        y_new_mantissa2 := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
        y_mantissa_out <= y_new_mantissa;
        y_mantissa2_out <= y_new_mantissa2;
        y_negated_mantissa := not(y_new_mantissa) + 1;
       -- index := aux2 + y_negated_mantissa;
       index := aux2 - y_new_mantissa;
        index2 := aux2 - y_new_mantissa2;
        index_out <= index;
        index2_out <= index2;
        if (index(23) = '1') then
            z_mantissa := index(22 downto 0);
            z_exponent := x_exponent;
        else
                FindPower1 : for count in 23 downto 0
                loop
                if (index(count) = '1') then
                    norm_count := 23 - count;
                exit FindPower1;
                end if;
                end loop;
                z_mantissa(22 downto (norm_count)) := index(23 - norm_count - 1 downto 0);
                z_mantissa((23 - norm_count) downto 0) := (others => '0');
                z_exponent := x_exponent - norm_count;
        end if;
        z_sign := x_sign;
    else if (x_exponent < y_exponent) then
        exp_diff := y_exponent - x_exponent;
        aux := ('1' & x_mantissa);
        aux2 := ('1' & y_mantissa);
        x_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
        index := aux2 - x_new_mantissa;
        if (index(23) = '1') then
            z_mantissa := index(22 downto 0);
            z_exponent := y_exponent;
        else
                FindPower2 : for count in 23 downto 0
                loop
                if (index(count) = '1') then
                    norm_count := 23 - count;
                exit FindPower2;
                end if;
                end loop;
                z_mantissa(22 downto (norm_count)) := index(23 - norm_count - 1 downto 0);
                z_mantissa((23 - norm_count) downto 0) := (others => '0');
                z_exponent := x_exponent - norm_count;
        end if;
        if (x_sign = '1' and y_sign = '1') then
            z_sign := '0';
        else
            z_sign := '1';
        end if;
        
    else if (x_exponent = y_exponent) then
        if (x_mantissa /= y_mantissa) then
            aux := ('1' & y_mantissa);
            aux2 := ('1' & x_mantissa);
            index := aux2 - aux;
            if (index(23) = '1') then
                z_mantissa := index(22 downto 0);
                z_exponent := x_exponent;
            else
                FindPower : for count in 23 downto 0
                loop
                if (index(count) = '1') then
                    norm_count := 23 - count;
                exit FindPower;
                end if;
                end loop;
                z_mantissa(22 downto (norm_count)) := index(23 - norm_count - 1 downto 0);
                z_mantissa((23 - norm_count) downto 0) := (others => '0');
                z_exponent := x_exponent - norm_count;
            end if;
            
            if (x_mantissa > y_mantissa) then
                z_sign := '0';
            else
                z_sign := '1';
            end if;
        else
            z_mantissa := (others => '0');
            z_exponent := (others => '0');
            z_sign := '0';
        end if;
        
    end if;
    end if;
    end if;
    
    z(31)           <= z_sign;
    z(30 downto 23) <= z_exponent;
    z(22 downto 0)  <= z_mantissa;
    
    
end process;
end Behavioral;
