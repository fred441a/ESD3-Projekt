----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2023 15:34:39
-- Design Name: 
-- Module Name: Addition2 - Behavioral
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


entity Addition2 is
    Port ( value_one : in STD_LOGIC_VECTOR (31 downto 0);
           value_two : in STD_LOGIC_VECTOR (31 downto 0);
           z_mantissa_out : out std_logic_vector(22 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           add_or_sub : in std_logic
           );
end Addition2;

architecture Behavioral of Addition2 is

function addition(x : std_logic_vector; y : std_logic_vector) return std_logic_vector is
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
        variable y_new_mantissa : std_logic_vector (22 downto 0);
        variable x_new_mantissa : std_logic_vector (22 downto 0);
        
        variable aux: std_logic_vector (23 downto 0);
        variable aux2 : std_logic_vector (23 downto 0);
        variable sum : std_logic_vector (31 downto 0);
    begin
        x_mantissa := x(22 downto 0);
		x_exponent := x(30 downto 23);
		x_sign := x(31);
		y_mantissa := y(22 downto 0);
		y_exponent := y(30 downto 23);
		y_sign := y(31);
    
        if (x_exponent > y_exponent) then
            exp_diff := (x_exponent) - (y_exponent);
		    aux := ('1' & y_mantissa);
		    y_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
		    
		    z_mantissa := x_mantissa + y_new_mantissa;
		    z_exponent := x_exponent;
		    z_sign := x_sign;
        else if (x_exponent < y_exponent) then
            exp_diff := y_exponent - x_exponent;
            aux := ('1' & x_mantissa);
            x_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
            
            z_mantissa := y_mantissa + x_new_mantissa;
		    z_exponent := y_exponent;
		    z_sign := y_sign;
        else
            aux := ('1' & y_mantissa);
            aux2 := ('1' & x_mantissa);
            y_new_mantissa := aux(23 downto 1);
            x_new_mantissa := aux2(23 downto 1);
            z_mantissa := x_new_mantissa + y_new_mantissa;
		    z_exponent := x_exponent + 1;
		    z_sign := x_sign;
		    
        end if;
        end if;
        
        sum(30 downto 23) := z_exponent;
        sum(22 downto 0) := z_mantissa;
        sum(31) := z_sign;
    return sum;
end function;

function subtraction(x : std_logic_vector; y : std_logic_vector) return std_logic_vector is
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
        variable y_new_mantissa : std_logic_vector (22 downto 0);
        variable x_new_mantissa : std_logic_vector (22 downto 0);
        variable y_negated_mantissa : std_logic_vector (22 downto 0);
        variable x_negated_mantissa : std_logic_vector (22 downto 0);
        
        variable aux : std_logic_vector (23 downto 0);
        variable aux2 : std_logic_vector (23 downto 0);
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
        y_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
        -- negate y mantissa
        y_negated_mantissa := (not(y_new_mantissa)) + 1;
        z_mantissa := x_mantissa + y_negated_mantissa;
        z_exponent := x_exponent;
        z_sign := x_sign;
    else if (x_exponent < y_exponent) then
        exp_diff := y_exponent - x_exponent;
        aux := ('1' & x_mantissa);
        x_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
        x_negated_mantissa := (not(x_new_mantissa)) + 1;
        z_mantissa := y_mantissa + x_negated_mantissa;
        z_exponent := y_exponent;
        if (x_sign = '1' and y_sign = '1') then
            z_sign := '0';
        else
            z_sign := '1';
        end if;
    else if (x_exponent = y_exponent) then
        if (x_mantissa /= y_mantissa) then
            aux := ('1' & y_mantissa);
            aux2 := ('1' & x_mantissa);
            y_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))));
            x_new_mantissa := aux2(23 downto 1);
            --y_new_mantissa := aux(23 downto 1);
            -- negate y mantissa
            y_negated_mantissa := (not(y_new_mantissa)) + 1;
            z_mantissa := x_new_mantissa + y_negated_mantissa;
            
            --z_mantissa := x_new_mantissa - y_new_mantissa;
            z_exponent := x_exponent;
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
    sum(30 downto 23)   := z_exponent;
    sum(22 downto 0)    := z_mantissa;
    sum(31)             := z_sign;
return sum;
end function;

begin
    process(value_one, value_two)
        begin
        if (add_or_sub ='1') then                                           -- Addition
            if (value_one(31) = '1' and value_two(31) = '1') then           -- negativ plus negativ
                result <= addition(value_one, value_two);
                result(31)<= '1';
                
            else if (value_one(31) = '0' and value_two(31) = '0') then      -- positiv plus positiv
                result <= addition(value_one, value_two);
                result(31)<= '0';
                
            else if (value_one(31) > value_two(31)) then                    -- negativ plus positiv - 3 tilfælde
                result <= subtraction(value_two, value_one);
                
            else if (value_one(31) < value_two(31)) then                    -- positiv plus negativ
                result <= subtraction(value_one, value_two);
                
            end if;
            end if;
            end if;
            end if;
        
        else if (add_or_sub = '0') then                                     -- Subtraction
            if (value_one(31) < value_two(31)) then                         -- positiv minus negativ
                result <= addition(value_one, value_two);
                result(31) <= '0';
            
            else if (value_one(31) = '0' and value_two(31) = '0') then      -- positiv minus positiv
                result <= subtraction(value_one, value_two);
           
            else if (value_one(31) = '1' and value_two(31) = '1') then      -- negativ minus negativ - 3 tilfælde
                result <= subtraction(value_one,value_two);
                
            else if (value_one(31) > value_two(31)) then                    -- negativ minus positiv
                result <= addition(value_one, value_two);
                result(31) <= '1';
            
            end if;
            end if;
            end if;
            end if;
            
        end if;
        
        end if;
            

    end process;
end Behavioral;
