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
use work.shared_types.all;

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
           enable : in STD_LOGIC;
           
           LED_1: out std_logic;
           LED_2: out std_logic 
           
           );
end Top;


architecture Behavioral of Top is

        Signal DATA: std_logic_vector(7 downto 0);
        SIGNAL WriteMemBus :  STD_LOGIC_VECTOR( 31 downto 0 );
        SIGNAL ADDRMemBus :  STD_LOGIC_VECTOR( 7 downto 0 );
        SIGNAL MemWrite :  STD_LOGIC;
        SIGNAL ReadMem : ram_type;

        SIGNAL EN : STD_LOGIC := '0';

        TYPE ConfigMachine  IS (Config, DoneConfig);
        SIGNAL ConfigState : ConfigMachine := Config;
        
        
        CONSTANT   AltSetup : integer := 16#16#;
    CONSTANT  AltAdresses : integer := 16#17#;
    CONSTANT  AltMem : integer := 16#18#;

    CONSTANT   MagSetup : integer := 16#19#;
    CONSTANT  MagAdressesX : integer := 16#1A#;
    CONSTANT  MagMemX : integer := 16#1B#;
    CONSTANT  MagAdressesY : integer := 16#1C#;
    CONSTANT  MagMemY : integer := 16#1D#;
    CONSTANT  MagAdressesZ : integer := 16#1E#;
    CONSTANT  MagMemZ : integer := 16#1F#;

    CONSTANT   GyroSetup : integer := 16#20#;
    CONSTANT  GyroAdressesX : integer := 16#21#;
    CONSTANT  GyroMemX : integer := 16#22#;
    CONSTANT  GyroAdressesY : integer := 16#23#;
    CONSTANT  GyroMemY : integer := 16#24#;
    CONSTANT  GyroAdressesZ : integer := 16#25#;
    CONSTANT  GyroMemZ : integer := 16#26#;

    CONSTANT   AccSetup : integer := 16#27#;
    CONSTANT  AccAdressesX : integer := 16#28#;
    CONSTANT  AccMemX : integer := 16#29#;
    CONSTANT  AccAdressesY : integer := 16#2A#;
    CONSTANT  AccMemY : integer := 16#2B#;
    CONSTANT  AccAdressesZ : integer := 16#2C#;
    CONSTANT  AccMemZ : integer := 16#2D#;

begin

    change_sensor : entity work.change_sensor
        port map(
            clk => clk,
            scl => scl,
            sda => sda,
            
            EN=>EN,
            
            ReadMem => ReadMem,
            MemWrite => MemWrite,
            ADDRMemBus => ADDRMemBus,
            WriteMemBus => WriteMemBus
        );

        PROCESS (clk)
        BEGIN
            IF(rising_edge(clk) and enable = '1') THEN
                CASE ConfigState IS
                    WHEN Config =>
                        EN <= '0';
                        ReadMem(AltSetup)(0) <= '1';
                        ReadMem(AltSetup)(7 downto 1) <= std_logic_vector(to_unsigned(16#68#,7)); 
                        ReadMem(AltSetup)(11 downto 8) <= ('0','0','1','1');
                        ReadMem(AltAdresses)(7 downto 0) <= std_logic_vector(to_unsigned(16#3B#,8));
                        ReadMem(Altadresses)(15 downto 8) <= std_logic_vector(to_unsigned(16#3C#,8));

                        ReadMem(MagSetup)(0) <= '1';
                        ReadMem(MagSetup)(7 downto 1) <= std_logic_vector(to_unsigned(16#68#,7)); 
                        ReadMem(MagSetup)(11 downto 8) <= ('0','0','1','1');
                        ReadMem(MagAdressesX)(7 downto 0) <= std_logic_vector(to_unsigned(16#3D#,8));
                        ReadMem(MagadressesX)(15 downto 8) <= std_logic_vector(to_unsigned(16#3E#,8));
                        
                        ReadMem(GyroSetup)(0) <= '0';
                        ReadMem(AccSetup)(0) <= '0';

                        ConfigState <= DoneConfig;
                    WHEN DoneConfig =>
                        EN <= '1';                 
                    WHEN OTHERS => ConfigState <= DoneConfig;
                END CASE;
            END IF;
            
            IF(enable = '0') THEN
                EN <= '0';
            END IF;

       END PROCESS;

end Behavioral;
		 
