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
use work.shared_types.all;

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
            EN1 : in STD_LOGIC;
            EN2 : in STD_LOGIC;
            EN3 : in STD_LOGIC;
            EN4 : in STD_LOGIC;
            I2CADDR : in STD_LOGIC_VECTOR (6 downto 0);
            ADDR1 : in STD_LOGIC_VECTOR (7 downto 0);
            ADDR2 : in STD_LOGIC_VECTOR (7 downto 0));
            ADDR3 : in STD_LOGIC_VECTOR (7 downto 0));
            ADDR4 : in STD_LOGIC_VECTOR (7 downto 0));

            WriteMemBus: OUT STD_LOGIC_VECTOR( 31 downto 0 );
            ADDRMemBus: OUT STD_LOGIC_VECTOR( 7 downto 0 );
            MemWrite: OUT STD_LOGIC;
            MemRead: IN ram_type;
            

            BusyOut: OUT STD_LOGIC
);
end Byte_compiler;

TYPE MachineState is (Ready,Read1Byte,Read2Byte,Read3Byte,Read4Byte,WriteToMem);
SIGNAL STATE: MachineState := Ready;
SIGNAL RBBusy: STD_LOGIC;
SIGNAL begin_transaction: STD_LOGIC;
SIGNAL I2C_REG: STD_LOGIC;
SIGNAL DATA: STD_LOGIC_VECTOR(7 downto 0);


architecture Behavioral of Byte_compiler is

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

    
begin

    PROCESS (clk)
    BEGIN
        if(rising_edge(clk)) THEN
            CASE  STATE IS
                WHEN Ready =>
                    BusyOut <= '0';
                    if(ENALL = '1') THEN
                        STATE <= Read1Byte;
                    END IF;
                WHEN Read1Byte =>
                    IF(EN1 = '1') THEN
                        I2C_REG <= ADDR1;
                        begin_transaction <= '1';

                        if(RBBusy = '1') THEN
                            begin_transaction <= '0';

                        END IF;



                    END IF;
                WHEN OTHERS => null;
            END CASE;


        END IF;

    END PROCESS;


end Behavioral;
