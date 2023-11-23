----------------------------------------------------------------------------------
-- Company: 310's Drone selskab A/S INC 
-- Engineer: Frederik Hansen
-- 
-- Create Date: 11/22/2023 10:55:14 AM
-- Design Name: 
-- Module Name: Byte_compiler - Behavioral
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

entity Byte_compiler is
    Port (  
            clk : in STD_LOGIC;
            
            scl: INOUT STD_LOGIC;
            sda: INOUT STD_LOGIC;

            ENALL: in STD_LOGIC;
            ENABLE: in STD_LOGIC_VECTOR(3 downto 0);
            I2CADDR : in STD_LOGIC_VECTOR (6 downto 0);
            ADDR1 : in STD_LOGIC_VECTOR (7 downto 0);
            ADDR2 : in STD_LOGIC_VECTOR (7 downto 0);
            ADDR3 : in STD_LOGIC_VECTOR (7 downto 0);
            ADDR4 : in STD_LOGIC_VECTOR (7 downto 0);

            WriteMemBus: INOUT STD_LOGIC_VECTOR( 31 downto 0 );
            ADDRMemBus: INOUT STD_LOGIC_VECTOR( 7 downto 0 );
            MemWrite: INOUT STD_LOGIC;
            

            BusyOut: OUT STD_LOGIC
);
end Byte_compiler;

architecture Behavioral of Byte_compiler is

TYPE MachineState is (Ready,Read1Byte,Read2Byte,Read3Byte,Read4Byte,WriteToMem);
SIGNAL STATE: MachineState := Ready;

TYPE PulseMachine is (Pulsing, DonePulsing);
SIGNAL Pulse : PulseMachine := Pulsing;

SIGNAL RBBusy: STD_LOGIC;
SIGNAL begin_transaction: STD_LOGIC;
SIGNAL I2C_REG: std_logic_vector (7 downto 0);
SIGNAL DATA: STD_LOGIC_VECTOR(7 downto 0);
    
begin

Read_Byte : entity work.Read_Byte
        port map (
                    scl => scl,
                    sda => sda,
                    clk => clk,

                    enable => begin_transaction,
                    BusyOut => RBBusy,
                    I2C_ADDR => I2CADDR,
                    I2C_REG => I2C_REG,
                    DATA => DATA
                 );

    PROCESS (clk)
    BEGIN
        if(rising_edge(clk)) THEN
            CASE  STATE IS
                WHEN Ready =>
                    WriteMemBus <= (31 downto 0 => '0');
                    BusyOut <= '0';
                    if(ENALL = '1') THEN
                        STATE <= Read1Byte;
                    END IF;
                WHEN Read1Byte =>
                    IF(ENABLE(0) = '1') THEN
                        I2C_REG <= ADDR1;
                        CASE Pulse IS
                            WHEN Pulsing =>
                        begin_transaction <= '1';
                        Pulse <= DonePulsing;
                            WHEN DonePulsing =>
                        if(RBBusy = '1') THEN
                            begin_transaction <= '0';
                        END IF;
                        if(RBBusy = '0' and begin_transaction = '0') THEN
                            WriteMemBus(31 downto 24) <= DATA;
                            Pulse <= Pulsing;
                            STATE <= Read2Byte;
                        END IF;
                        END CASE;
                    ELSE
                       STATE <=Ready; 
                    END IF;
                WHEN Read2Byte =>
                    IF(ENABLE(1) = '1') THEN
                        I2C_REG <= ADDR2;
                        CASE Pulse IS
                            WHEN Pulsing =>
                        begin_transaction <= '1';
                        Pulse <= DonePulsing;
                    WHEN DonePulsing =>

                        if(RBBusy = '1') THEN
                            begin_transaction <= '0';
                        END IF;
                        if(RBBusy = '0' and begin_transaction = '0') THEN
                            WriteMemBus(23 downto 16) <= DATA;
                            STATE <= Read3Byte;
                            Pulse <= Pulsing;
                        END IF;
                    WHEN OTHERS => Pulse<=DonePulsing;
                END CASE;
                     ELSE
                       STATE <=Ready; 
                    END IF;
                WHEN Read3Byte =>
                    IF(ENABLE(2) = '1') THEN
                        I2C_REG <= ADDR3;
                        CASE Pulse IS
                            WHEN Pulsing =>
                        begin_transaction <= '1';
                        Pulse <= DonePulsing;
                    WHEN DonePulsing =>

                        if(RBBusy = '1') THEN
                            begin_transaction <= '0';
                        END IF;
                        if(RBBusy = '0' and begin_transaction = '0') THEN
                            WriteMemBus(15 downto 8) <= DATA;
                            STATE <= Read4Byte;
                            Pulse <= Pulsing;
                        END IF;
                    WHEN OTHERS => Pulse<=DonePulsing;
                END CASE;
                     ELSE
                       STATE <=Ready; 
                    END IF;
                WHEN Read4Byte =>
                    IF(ENABLE(3) = '1') THEN
                        I2C_REG <= ADDR4;
                        CASE Pulse IS
                            WHEN Pulsing =>
                        begin_transaction <= '1';
                        Pulse <= DonePulsing;
                    WHEN DonePulsing =>

                        if(RBBusy = '1') THEN
                            begin_transaction <= '0';
                        END IF;
                        if(RBBusy = '0' and begin_transaction = '0') THEN
                            WriteMemBus(7 downto 0) <= DATA;
                            STATE <= WriteToMem;
                            Pulse <= Pulsing;
                        END IF;
                    WHEN OTHERS => Pulse<=DonePulsing;
                END CASE;
                     ELSE
                       STATE <=Ready; 
                    END IF;
                WHEN WriteToMem =>
                    IF(MemWrite = '0') THEN
                        MemWrite <= '1';
                    ELSIF (MemWrite = '1') THEN
                        MemWrite <= '0';
                        STATE <= Ready;
                    END IF;
                WHEN OTHERS => STATE <= Ready;
            END CASE;


        END IF;

    END PROCESS;


end Behavioral;
