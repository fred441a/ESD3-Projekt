----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2023 11:41:32
-- Design Name: 
-- Module Name: tester - Behavioral
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

entity tester is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : in STD_LOGIC_VECTOR (31 downto 0);
           z : out std_logic_vector (31 downto 0);--);
           y_negated_out : out std_logic_vector(22 downto 0);
           index_out : out std_logic_vector (24 downto 0);
           y_new_out : out std_logic_vector (23 downto 0);
           z_mantissa_out : out std_logic_vector (22 downto 0);
           place : out std_logic_vector (1 downto 0)
           );
end tester;

architecture Behavioral of tester is
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
        variable x_new_mantissa : std_logic_vector (23 downto 0);
        variable y_negated_mantissa : std_logic_vector (22 downto 0);
        variable x_negated_mantissa : std_logic_vector (22 downto 0);
        
        variable aux : std_logic_vector (23 downto 0);
        variable aux2 : std_logic_vector (23 downto 0);
        variable index : std_logic_vector (24 downto 0);
        variable index2 : std_logic_vector (23 downto 0);
        variable norm_count : integer := 0;
        variable sum : std_logic_vector (31 downto 0);
        variable ex_aux : integer := 0;
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
            x_new_mantissa := aux2;
            z_exponent := x_exponent;
        else if (x_exponent < y_exponent) then
            exp_diff := y_exponent - x_exponent;
            aux := ('1' & y_mantissa);
		    aux2 := ('1' & x_mantissa);
		    --y_new_mantissa := aux;
		    --x_new_mantissa := std_logic_vector(shift_right(unsigned(aux2) , to_integer(unsigned(exp_diff))));
		    z_exponent := y_exponent;
		    
		    y_new_mantissa := std_logic_vector(shift_right(unsigned(aux2) , to_integer(unsigned(exp_diff))));
		    x_new_mantissa := aux;
		    
		else
		    aux := ('1' & y_mantissa);
		    aux2 := ('1' & x_mantissa);
		    y_new_mantissa := aux;
		    x_new_mantissa := aux2;
		    z_exponent := x_exponent;
		 end if;
		 end if;   
		    index := ('0' & x_new_mantissa - y_new_mantissa);
		    index_out <= index;
    if (index(24) = '1') then
        place <= "01";
        z_mantissa := index(23 downto 1);
        z_exponent := x_exponent + 1;
    else if (index(23) = '1' and index(24) = '0') then
    place <= "10";
        z_mantissa := index(22 downto 0);
    else
    place <= "11";
        FindPower4 : for count in 24 downto 0
                loop
                if (index(count) = '1') then
                    norm_count := 24 - count;
                    exit FindPower4;
                end if;
                end loop;
                ex_aux := norm_count - 1;
            z_mantissa(22 downto (norm_count)) := index(24 - norm_count - 1 downto 1);
            z_mantissa((22 - norm_count) downto 0) := (others => '0');
            z_exponent := x_exponent - (ex_aux);
    end if;
    end if;
        
     
    
    z(31) <= x_sign;
    z(30 downto 23) <= z_exponent;
    z(22 downto 0) <= z_mantissa;
    
    
    end process;
end Behavioral;
