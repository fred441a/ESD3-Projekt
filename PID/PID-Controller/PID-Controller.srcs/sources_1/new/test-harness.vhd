----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2023 01:33:06 PM
-- Design Name: 
-- Module Name: test-harness - Behavioral
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
use IEEE.float_pkg.ALL;
use work.shared_types.all;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEST_HARNESS is
 Port (
    signal MCLK : in std_logic;
    signal OutPWM : out std_logic_vector(11 downto 0) 
 );
end TEST_HARNESS;

architecture Behavioral of TEST_HARNESS is
    function float32ToInteger(float_input : std_logic_vector(31 downto 0)) return std_logic_vector is
        variable exponent, shift, fractionInt : INTEGER := 0;
        variable sign : BOOLEAN;
        variable fraction : unsigned(22 downto 0);
      begin
        sign := float_input(31) = '1'; -- get sign
        exponent := to_integer(unsigned(float_input(30 downto 23))) - 127; --take exponent and subtract bias
        shift := -(exponent - 23); -- subtract fraction size (23) and inverrt sign, indicates the amount to right shift inorder to get 
        
        if shift < 23 then 
            fraction := shift_right(unsigned(float_input(22 downto 0)), shift); -- right shift fraction to get missing integer part
            fractionInt := to_integer(fraction); -- conver shiftet fracton to integer
        end if;
            
        if sign then
            return std_logic_vector(to_signed(-((2**exponent) + fractionInt), 32));
        else
            return std_logic_vector(to_signed((2**exponent) + fractionInt, 32));
        end if;
    end float32ToInteger;
  
    component PID
    Port (
        MCLK         : in std_logic;
        MEMORY       : in ram_type;      
        RES_PITCH    : out float32;
        RES_ROLL     : out float32;
        RES_YAW      : out float32;
        RES_ALTITUDE : out float32
    );
    end component;
    
    signal ram : ram_type;
    signal RES_PITCH, RES_ROLL, RES_YAW, RES_ALTITUDE : float32;
begin
    OutPWM <= float32ToInteger(to_Std_Logic_Vector(RES_ALTITUDE))(11 downto 0);
    
    PID_BLOCK: PID
    Port map (
        MCLK         => mclk,
        MEMORY       => ram, 
        RES_PITCH    => RES_PITCH,
        RES_ROLL     => RES_ROLL,
        RES_YAW      => RES_YAW,
        RES_ALTITUDE => RES_ALTITUDE
    );

end Behavioral;
