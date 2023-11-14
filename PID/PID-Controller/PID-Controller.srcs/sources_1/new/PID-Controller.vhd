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
        kp        : in real;
        ki        : in real;
        kd        : in real;
        SetPoint  : in real;
        Reference : in real;
        Result    : out real
    );
end PID_Controller;

architecture Behavioral of PID_Controller is
    TYPE tstate IS (CALC_ERROR, PID, RESET);
    signal state : tstate := CALC_ERROR;
    signal error, prevError : real := 0.0;

begin
    process (MCLK) begin
        if (rising_edge(MCLK)) then
            case (state) is
                when CALC_ERROR =>
                    error <= setPoint - Reference;
                    state <= PID;
                when PID =>
                    state <= RESET;
                    Result <= (Kp * error) + (Ki * (error + preverror)) + (kd * error);
                when RESET =>
                    state <= CALC_ERROR;
                    prevError <= error;
            end case;    
        end if;
    end process;

end Behavioral;
