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
        kp        : in real;
        ki        : in real;
        kd        : in real;
        SetPoint  : in real;
        Measured  : in real;
        Result    : out real
    );
    end component;
    
    signal mclk : std_logic;
    signal res : real;
begin

    PID: PID_Controller
    Port map (
        MCLK      => mclk,
        kp        => 2.0,
        ki        => 3.0,
        kd        => 1.5,
        SetPoint  => 100.0,
        Measured  => 20.0,
        Result    => res
    );

end Behavioral;
