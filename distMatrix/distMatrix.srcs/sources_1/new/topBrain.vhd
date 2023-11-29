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
  --cha0:     out std_logic_vector ( 31 downto 0);
  --cha1:     out std_logic_vector ( 31 downto 0);
  --cha2:     out std_logic_vector ( 31 downto 0);
  cha3:     out std_logic_vector ( 31 downto 0)
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
    
    ch0: out std_logic_vector ( 31 downto 0);
    ch1: out std_logic_vector ( 31 downto 0);
    ch2: out std_logic_vector ( 31 downto 0);
    ch3: out std_logic_vector ( 31 downto 0)
    );
end component;

signal zero:    float32 := to_float(0.0);
signal one:     float32 := to_float(1.0);
begin

matrixReloaded: matrix
port map (
    MCLK => CLK,
    pidPitch => zero,
    pidRoll => zero,
    pidYaw => one,
    pidLat => zero,
    
    --ch0 => cha0,
    --ch1 => cha1,
    --ch2 => cha2,
    ch3 => cha3
);

end Behavioral;
