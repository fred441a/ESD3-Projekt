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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( 
           clk : in STD_LOGIC;
           scl : inout STD_LOGIC;
           sda : inout STD_LOGIC;
           enable: in std_logic       
           
           );
end Top;

architecture Behavioral of Top is

Type SensorState IS(AltZ,GyroX,GyroY,GyroZ,AccelX,AccelY,AccelZ,MagX,MagY,MagZ);
Type RegisterState IS (Reg1,Reg2,Reg3,Reg4);
Type Mem IS ARRAY(natural range 0 to 45) OF std_logic_vector (32 -1  DOWNTO 0);



SIGNAL     SensorStateMachine: SensorState := AltZ;
SIGNAL	   RegisterStateMachine : RegisterState := Reg1;
SIGNAL     Memory:Mem := (others => (others => '0'));

-- altitude

constant AltSetupReg : natural := 16#16#;
constant AltAddressZReg :natural := AltSetupReg+1;
constant AltValueZReg : natural := AltAddressZReg+1;

-- Magnetomemter
constant MagSetupReg : natural := AltValueZReg+1;
constant MagAddressXReg : natural := MagSetupReg+1;
constant MagValueXReg : natural := MagAddressXReg+1;
constant MagAddressYReg :natural := MagValueXReg+1;
constant MagValueYReg : natural := MagAddressYReg+1;
constant MagAddressZReg :natural := MagValueYReg+1;
constant MagValueZReg : natural := MagAddressZReg+1;

-- Gyro

constant GyroSetupReg : natural := MagValueZReg+1;
constant GyroAddressXReg : natural := GyroSetupReg+1;
constant GyroValueXReg : natural := GyroAddressXReg+1;
constant GyroAddressYReg :natural := GyroValueXReg+1;
constant GyroValueYReg : natural := GyroAddressYReg+1;
constant GyroAddressZReg :natural := GyroValueYReg+1;
constant GyroValueZReg : natural := GyroAddressZReg+1;

-- Accel

constant AccelSetupReg : natural := GyroValueZReg+1;
constant AccelAddressXReg : natural := AccelSetupReg+1;
constant AccelValueXReg : natural := AccelAddressXReg+1;
constant AccelAddressYReg :natural := AccelValueXReg+1;
constant AccelValueYReg : natural := AccelAddressYReg+1;
constant AccelAddressZReg :natural := AccelValueYReg+1;
constant AccelValueZReg : natural := AccelAddressZReg+1;

SIGNAL BufferI2CEnable  : std_logic := Memory(AltSetupReg)(1);
SIGNAL BufferI2CReg1EN  : std_logic := Memory(AltSetupReg)(8);
SIGNAL BufferI2CReg2EN  : std_logic := Memory(AltSetupReg)(9);
SIGNAL BufferI2CReg3EN  : std_logic := Memory(AltSetupReg)(10);
SIGNAL BufferI2CReg4EN  : std_logic := Memory(AltSetupReg)(11);
SIGNAL BufferI2CAddress : std_logic_vector (6 downto 0) := Memory(AltSetupReg)(7 downto 1);
SIGNAL BufferI2CRegister: std_logic_vector(7 downto 0) := Memory(AltAddressZReg)(7 downto 0);

SIGNAL     BeginWrite: std_logic;
SIGNAL     rw: std_logic;
SIGNAL     data_wr:std_logic_vector(7 downto 0);
SIGNAL     data_rd:std_logic_vector(7 downto 0);
SIGNAL     busy:std_logic;
SIGNAL     ack_error:std_logic;

SIGNAL busyQ: std_logic;
SIGNAL busyQQ: std_logic;

SIGNAL ClockDiv: std_logic := '0';
SIGNAL I2CStep: std_logic;


PROCEDURE RegisterSwitch(
SIGNAL I2CADDR : in std_logic_vector(6 downto 0);
SIGNAL Reg1 : in std_logic_vector(7 downto 0);
SIGNAL Reg2 : in std_logic_vector(7 downto 0);
SIGNAL Reg3 : in std_logic_vector(7 downto 0);
SIGNAL Reg4 : in std_logic_vector(7 downto 0)
						)is

begin
		CASE RegisterStateMachine is
				WHEN Reg1 =>
						if()	

		end case

end procedure RegisterSwitch;

begin

I2C_Master : entity work.i2c_master
port map (
    scl       => scl,      --serial clock output of i2c bus
    sda       => sda,      --serial data output
    clk       => clk,      --system clock

    reset_n   => '1',  --active low reset TODO add I2C enable memory flag
    ena       => BeginWrite,      --latch in command
    addr      => BufferI2CAddress,     --address of target slave
    rw        => rw,       --'0' is write, '1' is read
    data_wr   => data_wr,  --data to write to slave
    busy      => busy,     --indicates transaction in progress
    data_rd   => data_rd,  --data read from slave
    ack_error => ack_error --flag if improper acknowledge from slave
);

process (clk)
begin
   if (clk'event and clk = '1') then
   
   busyQQ <= busyQ;
   busyQ <= busy;
   
   if(BusyQQ = '1' and BusyQ = '0') then
   
   ClockDiv <= not ClockDiv;
   
   if( ClockDiv = '1') then
		CASE SensorStateMachine is
		   when AltZ=>
				   BufferI2CAddress <= Memory(AltSetupReg)(7 downto 1);
		   when MagX=>
				   BufferI2CAddress <= Memory(AltSetupReg)(7 downto 1);
		   when AltZ=>
				   BufferI2CAddress <= Memory(AltSetupReg)(7 downto 1);
		   when AltZ=>
				   BufferI2CAddress <= Memory(AltSetupReg)(7 downto 1);






				
		END CASE

		CASE RegisterStateMachine is
				when Reg1=>

		END CASE
   
   
   
   end if;



   
--   case SensorStateMachine is
--
--		when AltZ =>
--		 
--
--   end case;
   
   end if;
   
   
   end if;
end process;
				

--Memory(15) <= X"ff_ff_ff_ff";


end Behavioral;

--BufferI2CEnable <= Memory(GyroSetupReg)(1);
--		BufferI2CReg1EN <= Memory(GyroSetupReg)(8);
--		BufferI2CReg2EN <= Memory(GyroSetupReg)(9);
--		BufferI2CReg3EN <= Memory(GyroSetupReg)(10);
--		BufferI2CReg4EN <= Memory(GyroSetupReg)(11);
--		BufferI2CAddress <= Memory(GyroSetupReg)(7 downto 1);
--		BufferI2CRegister <= Memory(GyroAddressXReg)(7 downto 0);
		  --SIGNAL BufferI2CEnable  : std_logic := Memory(AltSetupReg)(1);
--SIGNAL BufferI2CReg1EN  : std_logic := Memory(AltSetupReg)(8);
--SIGNAL BufferI2CReg2EN  : std_logic := Memory(AltSetupReg)(9);
--SIGNAL BufferI2CReg3EN  : std_logic := Memory(AltSetupReg)(10);
--SIGNAL BufferI2CReg4EN  : std_logic := Memory(AltSetupReg)(11);
--SIGNAL BufferI2CAddress : std_logic_vector (6 downto 0) := Memory(AltSetupReg)(7 downto 1);
--SIGNAL BufferI2CRegister: std_logic_vector(7 downto 0) := Memory(AltAddressZReg)(7 downto 0);
		 
