----------------------------------------------------------------------------------
-- Company:  Gruppe310
-- Engineer: Frederik Hansen
-- 
-- Create Date: 11/02/2023 10:18:55 AM
-- Design Name: 
-- Module Name: Top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( 
           clk : in STD_LOGIC;
           scl : inout STD_LOGIC;
           sda : inout STD_LOGIC;
           en : in STD_LOGIC
           );
end Top;


architecture Behavioral of Top is

        Signal DATA: std_logic_vector(7 downto 0);
        SIGNAL BCBusy: std_logic ;

begin

    Byte_compiler: entity work.Byte_compiler
        port map(
            clk => clk,
            sda => sda,
            scl => scl,
            ENALL => en,
            BusyOut => BCBusy,
            I2CADDR => std_logic_vector(TO_UNSIGNED(16#68#,7)),
            ENABLE => ('0','0','1','1'),
            ADDR1 => X"3B",
            ADDR2 => X"3C",
            ADDR3 => X"00",
            ADDR4 => X"00"
            
        );

end Behavioral;
		 
