----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2023 03:18:04 PM
-- Design Name: 
-- Module Name: testBench - Behavioral
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
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity topBrain is
  Port ( 
  CLK:      in STD_logic;
  cha0:     out std_logic_vector (7 downto 0);
  cha1:     out std_logic_vector (7 downto 0);
  cha2:     out std_logic_vector (7 downto 0);
  cha3:     out std_logic_vector (7 downto 0)
  );
end topBrain;

architecture Behavioral of topBrain is
  
component matrix is
    port (
    MCLK: in STD_LOGIC;
    
    pidPitch: in float32;
    pidRoll: in float32;
    pidYaw: in float32;
    pidLat: in float32;
    
    ch0: out float32;
    ch1: out float32;
    ch2: out float32;
    ch3: out float32
    );
end component;

component pwmMap is
    port (
    MCLK: in            std_logic;
    ch0: in             float32;
    ch1: in             float32;
    ch2: in             float32;
    ch3: in             float32;
    
    outCh0: out         std_logic_vector(7 downto 0);
    outCh1: out         std_logic_vector(7 downto 0);
    outCh2: out         std_logic_vector(7 downto 0);
    outCh3: out         std_logic_vector(7 downto 0)
    );
end component;

signal zero:    float32 := to_float(0.0);
signal one:     float32 := to_float(1.0);

signal sigch0:  float32;
signal sigch1:  float32;
signal sigch2:  float32;
signal sigch3:  float32;
begin

matrixReloaded: matrix
port map (
    MCLK => CLK,
    pidPitch => zero,
    pidRoll => zero,
    pidYaw => one,
    pidLat => zero,
    
    ch0 => sigch0,
    ch1 => sigch1,
    ch2 => sigch2,
    ch3 => sigch3
);

pwmMapSlave: pwmMap
port map (
    MCLK => CLK,
    ch0 => sigch0,
    ch1 => sigch1,
    ch2 => sigch2,
    ch3 => sigch3,
    
    outch0 => cha0,
    outch1 => cha1,    
    outch2 => cha2,
    outch3 => cha3    
);
end Behavioral;
