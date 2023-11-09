----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2023 09:12:15 AM
-- Design Name: 
-- Module Name: testOfCalibration - Behavioral
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

entity testOfCalibration is
    Port (
        CLK : in std_logic;
        ready: in std_logic;
        finish: out std_logic;
        PWM: out std_logic_vector (3 downto 0)
        
        );
end testOfCalibration;

architecture Behavioral of testOfCalibration is
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
        finish   : out   STD_LOGIC;
        output   : out   STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    signal s_output : std_logic_vector(7 downto 0);
    signal newClock: STD_LOGIC; -- til at andvende i pwmModule som intern clock
    
begin
    pwmCalibration: createCalibration 
      port map (
        CLK      => CLK, -- run on internal 12M hz clock
        ready    => ready, -- User says it's ready
        finish   => finish, -- Module says it is finished
        output   => s_output -- So output becomes the pwm calibration
    );    
    
    pwmModule1: pwmModule 
      port map (
        clock      => CLK, -- run on internal 12M hz clock
        PercentCh0 => s_output,
        PercentCh1 => s_output,
        PercentCh2 => s_output,
        PercentCh3 => s_output,
        PWM => PWM -- Channel to the motors
    );    
end architecture;

