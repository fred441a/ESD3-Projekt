----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2023 12:53:44 PM
-- Design Name: 
-- Module Name: flightController - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.shared_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flightController is
  Port (
  CLK :                 in std_logic;
  scl_slave:            inout std_logic;
  sda_slave:            inout std_logic;
  --scl_master:         inout std_logic;
  --sda_master:         inout std_logic;
  -- emergency_stop:    in std_logic;
  PWM:                  out std_logic_vector (3 downto 0)
  );
end flightController;

architecture Behavioral of flightController is
signal memory: ram_type := (others =>(OTHERS => '0'));

    component pwmModule is
        Port (     
           PercentCh0 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           PercentCh1 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           PercentCh2 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           PercentCh3 : in STD_LOGIC_VECTOR (7 downto 0); -- := "01111111"; --"50%; 127"
           clock : in STD_LOGIC;
           PWM : out std_logic_vector (3 downto 0)
       );
    end component;
    
    component createCalibration is 
        Port (
        CLK      : in    STD_LOGIC;
        ready    : in    STD_LOGIC;
        --finish   : out   STD_LOGIC;
        output   : out   STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    component I2C_EXTERNAL_ACCESS is
        port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic
		--inMEMORY    : in ram_type;
		--outMEMORY   : out ram_type
	);
    end component;
-- Write internal signals here:
signal memWrite : std_logic_vector(7 downto 0);
   
begin

pwmCal: createCalibration
port map (
 CLK => CLK,
 ready => memory(1)(0),
 --finish => memory(1)(1),
 output => memWrite
);

pwmGen: PwmModule
port map (
PercentCh0 => memory(15)(7 downto 0),
PercentCh1 => memory(15)(15 downto 8),
PercentCh2 => memory(15)(23 downto 16),
PercentCh3 => memory(15)(31 downto 24),
clock => CLK,
PWM => PWM
);

i2cExternal: I2C_EXTERNAL_ACCESS
port map(

MCLK => CLK,
nRST => '1',
SCL => scl_slave,
SDA => sda_slave
--inMEMORY => memory,
--outMEMORY => memory

);

memory(15)(7 downto 0) <= memWrite;
memory(15)(15 downto 8) <= memWrite;
memory(15)(23 downto 16) <= memWrite;
memory(15)(31 downto 24) <= memWrite;
end Behavioral;
