----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2023 09:55:36 AM
-- Design Name: 
-- Module Name: change_sensor - Behavioral
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
use work.shared_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity change_sensor is
  Port (
        clk : in STD_LOGIC;
        scl : inout STD_LOGIC;
        sda : inout STD_LOGIC;
        
        EN : IN STD_LOGIC;

        WriteMemBus : inout STD_LOGIC_VECTOR( 31 downto 0 );
        ADDRMemBus : inout STD_LOGIC_VECTOR( 7 downto 0 );
        MemWrite : INOUT STD_LOGIC;
        ReadMem : IN ram_type

       );
end change_sensor;

architecture Behavioral of change_sensor is
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

    TYPE StateMachine is (Ready,AltZ,MagX,MagY,MagZ,GyroX,GyroY,GyroZ,AccX,AccY,AccZ);
    SIGNAL STATE : StateMachine := Ready;

    TYPE PulseMachine is ( Pulsing, DonePulsing);
    SIGNAL Pulse : PulseMachine := Pulsing;

    SIGNAL ENABLE: STD_LOGIC_VECTOR(3 downto 0);

    SIGNAL ADDR1 :  STD_LOGIC_VECTOR( 7 downto 0);
    SIGNAL ADDR2 :  STD_LOGIC_VECTOR( 7 downto 0);
    SIGNAL ADDR3 :  STD_LOGIC_VECTOR( 7 downto 0);
    SIGNAL ADDR4 :  STD_LOGIC_VECTOR( 7 downto 0);

    SIGNAL I2CADDR : STD_LOGIC_VECTOR( 6 downto 0);

    SIGNAL BCBusy : STD_LOGIC;

SIGNAL begin_transaction : STD_LOGIC := '0';

begin

    Byte_compiler :  entity work.Byte_compiler
        port map (
                    scl=>scl,
                    sda=>sda,
                    clk=>clk,
                    
                    ENALL => begin_transaction, 
                    ENABLE => ENABLE,
                    
                    
                    ADDR1 => ADDR1,
                    ADDR2 => ADDR2,
                    ADDR3 => ADDR3,
                    ADDR4 => ADDR4,

                    I2CADDR => I2CADDR,

                    WriteMemBus => WriteMemBus,
                    ADDRMemBus => ADDRMemBus,
                    MemWrite => MemWrite,
                    readmem =>ReadMem,

                    BusyOut=>BCBusy,
                    dointegrate => '0'
                 );

        PROCESS ( CLK )
        BEGIN
            IF(rising_edge(clk)) THEN
                CASE STATE IS
                    WHEN Ready =>
                        if(EN = '1') THEN
                            State <= AltZ;
                        END IF;
                    WHEN AltZ =>
                        if(ReadMem(AltSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(AltSetup)(7 downto 1);
                            ENABLE <= ReadMem(AltSetup)(11 downto 8);
                            ADDR1 <= ReadMem(AltAdresses)(7 downto 0);
                            ADDR2 <= ReadMem(AltAdresses)(15 downto 8);
                            ADDR3 <= ReadMem(AltAdresses)(23 downto 16);
                            ADDR4 <= ReadMem(AltAdresses)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(to_unsigned(AltMem,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= MagX;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= Magx;
                        END IF;

                    WHEN MagX =>
                        if(ReadMem(MagSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(MagSetup)(7 downto 1);
                            ENABLE <= ReadMem(MagSetup)(11 downto 8);
                            ADDR1 <= ReadMem(MagAdressesX)(7 downto 0);
                            ADDR2 <= ReadMem(MagAdressesX)(15 downto 8);
                            ADDR3 <= ReadMem(MagAdressesX)(23 downto 16);
                            ADDR4 <= ReadMem(MagAdressesX)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(MagMemX,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= MagY;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= MagY;
                        END IF;

 
                    WHEN MagY =>
                        if(ReadMem(MagSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(MagSetup)(7 downto 1);
                            ENABLE <= ReadMem(MagSetup)(11 downto 8);
                            ADDR1 <= ReadMem(MagAdressesY)(7 downto 0);
                            ADDR2 <= ReadMem(MagAdressesY)(15 downto 8);
                            ADDR3 <= ReadMem(MagAdressesY)(23 downto 16);
                            ADDR4 <= ReadMem(MagAdressesY)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(MagMemY,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= MagZ;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= MagZ;
                        END IF;

 
                    WHEN MagZ =>
                        if(ReadMem(MagSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(MagSetup)(7 downto 1);
                            ENABLE <= ReadMem(MagSetup)(11 downto 8);
                            ADDR1 <= ReadMem(MagAdressesZ)(7 downto 0);
                            ADDR2 <= ReadMem(MagAdressesZ)(15 downto 8);
                            ADDR3 <= ReadMem(MagAdressesZ)(23 downto 16);
                            ADDR4 <= ReadMem(MagAdressesZ)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(MagMemZ,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= GyroX;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= GyroX;
                        END IF;

 
                    WHEN GyroX =>
                        if(ReadMem(GyroSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(GyroSetup)(7 downto 1);
                            ENABLE <= ReadMem(GyroSetup)(11 downto 8);
                            ADDR1 <= ReadMem(GyroAdressesX)(7 downto 0);
                            ADDR2 <= ReadMem(GyroAdressesX)(15 downto 8);
                            ADDR3 <= ReadMem(GyroAdressesX)(23 downto 16);
                            ADDR4 <= ReadMem(GyroAdressesX)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(GyroMemX,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= GyroY;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= GyroY;
                        END IF;

 
                    WHEN GyroY =>
                        if(ReadMem(GyroSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(GyroSetup)(7 downto 1);
                            ENABLE <= ReadMem(GyroSetup)(11 downto 8);
                            ADDR1 <= ReadMem(GyroAdressesY)(7 downto 0);
                            ADDR2 <= ReadMem(GyroAdressesY)(15 downto 8);
                            ADDR3 <= ReadMem(GyroAdressesY)(23 downto 16);
                            ADDR4 <= ReadMem(GyroAdressesY)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(GyroMemY,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= GyroZ;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= GyroZ;
                        END IF;

 
                    WHEN GyroZ =>
                        if(ReadMem(GyroSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(GyroSetup)(7 downto 1);
                            ENABLE <= ReadMem(GyroSetup)(11 downto 8);
                            ADDR1 <= ReadMem(GyroAdressesZ)(7 downto 0);
                            ADDR2 <= ReadMem(GyroAdressesZ)(15 downto 8);
                            ADDR3 <= ReadMem(GyroAdressesZ)(23 downto 16);
                            ADDR4 <= ReadMem(GyroAdressesZ)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(GyroMemZ,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= AccX;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= AccX;
                        END IF;

 
                    WHEN AccX =>
                        if(ReadMem(AccSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(AccSetup)(7 downto 1);
                            ENABLE <= ReadMem(AccSetup)(11 downto 8);
                            ADDR1 <= ReadMem(AccAdressesX)(7 downto 0);
                            ADDR2 <= ReadMem(AccAdressesX)(15 downto 8);
                            ADDR3 <= ReadMem(AccAdressesX)(23 downto 16);
                            ADDR4 <= ReadMem(AccAdressesX)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(AccMemX,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= AccY;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= AccY;
                        END IF;

 
                    WHEN AccY =>
                        if(ReadMem(AccSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(AccSetup)(7 downto 1);
                            ENABLE <= ReadMem(AccSetup)(11 downto 8);
                            ADDR1 <= ReadMem(AccAdressesY)(7 downto 0);
                            ADDR2 <= ReadMem(AccAdressesY)(15 downto 8);
                            ADDR3 <= ReadMem(AccAdressesY)(23 downto 16);
                            ADDR4 <= ReadMem(AccAdressesY)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(AccMemY,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= AccZ;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= AccZ;
                        END IF;

 
                    WHEN AccZ =>
                        if(ReadMem(AccSetup)(0)= '1') THEN
                            I2CADDR <= ReadMem(AccSetup)(7 downto 1);
                            ENABLE <= ReadMem(AccSetup)(11 downto 8);
                            ADDR1 <= ReadMem(AccAdressesZ)(7 downto 0);
                            ADDR2 <= ReadMem(AccAdressesZ)(15 downto 8);
                            ADDR3 <= ReadMem(AccAdressesZ)(23 downto 16);
                            ADDR4 <= ReadMem(AccAdressesZ)(31 downto 24);
                            ADDRMemBus <= std_logic_vector(TO_UNSIGNED(AccMemZ,8));

                            CASE Pulse IS
                                WHEN Pulsing =>
                                    begin_transaction <= '1';
                                    Pulse <= DonePulsing;
                                WHEN DonePulsing =>
                                    if (BCBusy = '1') THEN
                                        begin_transaction <= '0';
                                    END IF;

                                    IF(BCBusy = '0' AND begin_transaction = '0') THEN
                                        STATE <= Ready;
                                        Pulse <= Pulsing;
                                    END IF;
                            END CASE;
                        ELSE
                            STATE <= Ready;
                        END IF;

            WHEN OTHERS => STATE <= Ready;
                END CASE;
            END IF;
        END PROCESS;


end Behavioral;
