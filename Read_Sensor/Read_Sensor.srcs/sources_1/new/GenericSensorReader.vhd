----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2023 11:43:48 AM
-- Design Name: 
-- Module Name: GenericSensorReader - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GenericSensorReader is
--  Port ( );
Port ( 
           clk : in STD_LOGIC;
           scl : inout STD_LOGIC;
           sda : inout STD_LOGIC;
           enable: in std_logic;
           I2CSlaveSetup: inout std_logic_vector( 31 to 0);
           I2CSlaveAdressesX: inout std_logic_vector(31 to 0);
           I2CSlaveValuesX: inout std_logic_vector (31 to 0);
           I2CSlaveAdressesY: inout std_logic_vector(31 to 0);
           I2CSlaveValuesY: inout std_logic_vector(31 to 0);
           I2CSlaveAdressesZ: inout std_logic_vector(31 to 0);
           I2CSlaveValuesZ: inout std_logic_vector(31 to 0)           
           );
end GenericSensorReader;

architecture Behavioral of GenericSensorReader is

begin


end Behavioral;
