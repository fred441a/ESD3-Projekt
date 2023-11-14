----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2023 10:11:32
-- Design Name: 
-- Module Name: Addition1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Addition1 is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
           sum : out STD_LOGIC_VECTOR (31 downto 0); --);
           auxud : out std_logic_vector (23 downto 0);
           exp_diff_ud : out std_logic_vector (7 downto 0);
           y_new_mantissa_ud : out std_logic_vector (22 downto 0);
           x_mantissa_ud : out std_logic_vector (22 downto 0);
           z_mantissa_ud : out std_logic_vector (22 downto 0)
           );
end Addition1;

architecture Behavioral of Addition1 is

begin
    process(x,y)
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
    begin
        x_mantissa := x(22 downto 0);
		x_exponent := x(30 downto 23);
		x_sign := x(31);
		y_mantissa := y(22 downto 0);
		y_exponent := y(30 downto 23);
		y_sign := y(31);
		
		if (unsigned(x_exponent) > unsigned(y_exponent)) then
		    if (y_sign = '1') then
		    
		    else
		        exp_diff := (x_exponent) - (y_exponent);
		        aux := ('1' & y_mantissa);
		        y_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
		    
		        z_mantissa := x_mantissa + y_new_mantissa;
		        z_exponent := x_exponent;
		        z_sign := x_sign;
		    end if;
		    
        else if (unsigned(x_exponent) < unsigned(y_exponent)) then
            if (x_sign = '1') then
                
            else
                exp_diff := y_exponent - x_exponent;
                aux := ('1' & x_mantissa);
                x_new_mantissa := std_logic_vector(shift_right(unsigned(aux(23 downto 1)) , to_integer(unsigned(exp_diff))-1));
            
                z_mantissa := y_mantissa + x_new_mantissa;
		        z_exponent := y_exponent;
		        z_sign := y_sign;
            end if;
            
            
		else if (x_exponent = y_exponent and y_sign = '1') then
		    z_mantissa := x_mantissa - y_mantissa;
		    z_exponent := x_exponent;
		    z_sign := x_sign;
		else if (x_exponent = y_exponent and y_sign = '1'
--		end if;
		end if;
		end if;
		
---------- For mellem værdier:
		z_mantissa_ud <= z_mantissa;
		y_new_mantissa_ud <= y_new_mantissa;
		x_mantissa_ud <= x_mantissa;
		auxud <= aux;
		exp_diff_ud <= exp_diff;
---------------------------------------
            sum(22 downto 0) <= z_mantissa;
		    sum(30 downto 23) <= z_exponent;
		    sum(31) <= z_sign;
    end process;
end Behavioral;
