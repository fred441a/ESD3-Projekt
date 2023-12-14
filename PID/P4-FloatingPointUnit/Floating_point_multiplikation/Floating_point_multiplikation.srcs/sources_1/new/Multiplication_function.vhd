----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2023 09:02:46
-- Design Name: 
-- Module Name: Multiplication_function - Behavioral
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

entity Multiplication_function is
    Port ( Value_one : in STD_LOGIC_VECTOR (31 downto 0);
           Value_two : in STD_LOGIC_VECTOR (31 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0)
           );
end Multiplication_function;

architecture Behavioral of Multiplication_function is
function multiply(x : std_logic_vector; y : std_logic_vector) return std_logic_vector is
    variable x_mantissa : STD_LOGIC_VECTOR (22 downto 0);
	variable x_exponent : STD_LOGIC_VECTOR (7 downto 0);
	variable x_sign : STD_LOGIC;
	variable y_mantissa : STD_LOGIC_VECTOR (22 downto 0);
	variable y_exponent : STD_LOGIC_VECTOR (7 downto 0);
	variable y_sign : STD_LOGIC;
	variable z_mantissa : STD_LOGIC_VECTOR (22 downto 0);
	variable z_exponent : STD_LOGIC_VECTOR (7 downto 0);
	variable z_sign : STD_LOGIC;
	variable aux : STD_LOGIC;
	variable aux2 : STD_LOGIC_VECTOR (47 downto 0);
	variable exponent_sum : STD_LOGIC_VECTOR (8 downto 0);
	variable sum : std_logic_vector (31 downto 0);
begin
    -- Opdeling af input i sign, mantissa og exponent
    x_mantissa := x(22 downto 0);
	x_exponent := x(30 downto 23);
	x_sign := x(31);
	y_mantissa := y(22 downto 0);
	y_exponent := y(30 downto 23);
	y_sign := y(31);

    if (x_exponent=255 or y_exponent=255) then 
		-- inf*x or x*inf
		z_exponent := "11111111";
		z_mantissa := (others => '0');
		z_sign := x_sign xor y_sign;
		
	elsif (x_exponent=0 or y_exponent=0) then 
	-- 0*x or x*0
		z_exponent := (others => '0');
		z_mantissa := (others => '0');
		z_sign := '0';
	else
			
		aux2 := ('1' & x_mantissa) * ('1' & y_mantissa);
			-- args in Q23 result in Q46
		if (aux2(47)='1') then 
			-- >=2, shift left and add one to exponent
			z_mantissa := aux2(46 downto 24) + aux2(23); -- with rounding
			aux := '1';
		else
			z_mantissa := aux2(45 downto 23) + aux2(22); -- with rounding
			aux := '0';
		end if;
		
		-- calculate exponent
		exponent_sum := ('0' & x_exponent) + ('0' & y_exponent) + aux - 127;
		if (exponent_sum(8)='1') then 
			if (exponent_sum(7)='0') then -- overflow
				z_exponent := "11111111";
				z_mantissa := (others => '0');
				z_sign := x_sign xor y_sign;
			else 									-- underflow
				z_exponent := (others => '0');
				z_mantissa := (others => '0');
				z_sign := '0';
			end if;
		else								  		 -- Ok
			z_exponent := exponent_sum(7 downto 0);
			z_sign := x_sign xor y_sign;
		end if;
	end if;
	sum(31) := z_sign;
	sum(30 downto 23) := z_exponent;
	sum(22 downto 0) := z_mantissa;
	
end function;

begin

result <= multiply(value_one, value_two);

end Behavioral;
