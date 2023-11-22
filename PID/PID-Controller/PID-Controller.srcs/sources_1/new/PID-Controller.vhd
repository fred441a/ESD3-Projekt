----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2023 12:08:55 PM
-- Design Name: 
-- Module Name: PID-Controller - Behavioral
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
use ieee.float_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PID_Controller is
    Port (
        MCLK      : std_logic;
        kp        : in float32;
        ki        : in float32;
        kd        : in float32;
        SetPoint  : in float32;
        Measured  : in float32;
        Result    : out float32
    );
end PID_Controller;

architecture Behavioral of PID_Controller is
    TYPE tstate IS (CALC_ERROR, PID, RESET);
    signal state : tstate := CALC_ERROR;
    signal error, prevError, prevMeasured : float32 := to_float(0);

begin
    process (MCLK) begin
        if (rising_edge(MCLK)) then
            case (state) is
                when CALC_ERROR =>
                    error <= setPoint - Measured;
                    state <= PID;
                when PID =>
                    state <= RESET;
                    Result <= (Kp * error) + (Ki * (error + preverror)) + (kd * (error - preverror)); --PID
                    --Result <= (Kp * error) + (Ki * (error + preverror)) + (kd * (Measured - prevMeasured)); -- PIV
                when RESET =>
                    state <= CALC_ERROR;
                    prevError <= prevError + error;
                    prevMeasured <= Measured;
            end case;    
        end if;
    end process;

end Behavioral;
