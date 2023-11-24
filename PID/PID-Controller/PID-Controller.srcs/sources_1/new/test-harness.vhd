----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2023 01:33:06 PM
-- Design Name: 
-- Module Name: test-harness - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEST_HARNESS is
--  Port ( );
end TEST_HARNESS;

architecture Behavioral of TEST_HARNESS is
    component PID_Controller
    Port (
        MCLK      : std_logic;
        kp        : in float32;
        ki        : in float32;
        kd        : in float32;
        SetPoint  : in float32;
        Measured  : in float32;
        Result    : out float32
    );
    end component;
    
    signal mclk : std_logic;
    signal res : float32;
begin

    PID: PID_Controller
    Port map (
        MCLK      => mclk,
        kp        => to_float(2.0),
        ki        => to_float(3.0),
        kd        => to_float(1.5),
        SetPoint  => to_float(100.0),
        Measured  => to_float(20.0),
        Result    => res
    );

end Behavioral;
