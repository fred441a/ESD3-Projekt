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
        MCLK        : in std_logic;
        EN          : in std_logic;
        kp          : in float32;
        ki          : in float32;
        kd          : in float32;
        SetPoint    : in float32;
        Measured    : in float32;
        Result      : out float32;
        ResultReady : out std_logic;
        
        -- fpu connections
        fpuVal0   : inout float32;
        fpuVal1   : inout float32;
        fpuOpCode : inout std_logic_vector(1 downto 0);
        fpuResult : in float32
    );
end PID_Controller;

architecture Behavioral of PID_Controller is
    TYPE tstate IS (CALC_ERROR, RES_ERROR, 
                    ACCUM_ERROR, ACCUM_ERROR_RES, 
                    P_MUL, P_MUL_RES, 
                    I_MUL, I_MUL_RES, 
                    D_SUB, D_SUB_RES, D_MUL, D_MUL_RES, 
                    PI_SUM, PI_SUM_RES, ID_SUM, ID_SUM_RES,
                    RESET);
    signal state : tstate := CALC_ERROR;
    signal error, errorAccum, prevError : float32 := to_float(0);
    -- signal prevMeasured : float32 := to_float(0);
    signal ri, rp, rd, temp : float32;

begin
    -- release fpu bus when not enabled
    --fpuVal0   <= (others => 'Z') when EN = '1' else (others => '0');
    --fpuVal1   <= (others => 'Z') when EN = '1' else (others => '0');
    --fpuOpCode <= (others => 'Z') when EN = '1' else (others => '0');
        
    process (MCLK) begin
        if (rising_edge(MCLK) and EN = '1') then
            case (state) is
                when CALC_ERROR =>
                    -- error <= setPoint - Measured;
                    fpuVal0 <= setPoint;
                    fpuVal1 <= Measured;
                    fpuOpCode <= "10"; -- subtract
                    ResultReady <= '0';
                    state <= RES_ERROR;
                when RES_ERROR =>
                    error <= fpuResult;
                    if (fpuResult /= prevError) then
                        state <= ACCUM_ERROR;
                    else 
                        state <= RESET;
                    end if;
                when ACCUM_ERROR =>
                    --errorAccum <= errorAccum + error;
                    fpuVal0 <= errorAccum;
                    fpuVal1 <= error;
                    fpuOpCode <= "01"; -- add
                    state <= ACCUM_ERROR_RES;
                when ACCUM_ERROR_RES =>
                    errorAccum <= fpuResult;
                    state <= P_MUL;
                when P_MUL =>
                    --rp <= (Kp * error); 
                    fpuVal0 <= kp;
                    fpuVal1 <= error;
                    fpuOpCode <= "11"; -- multiply
                    state <= P_MUL_RES;
                when P_MUL_RES =>
                    rp <= fpuResult;
                    state <= I_MUL;
                when I_MUL =>
                    --ri <= (Ki * errorAccum);
                    fpuVal0 <= ki;
                    fpuVal1 <= errorAccum;
                    fpuOpCode <= "11"; -- multiply
                    state <= I_MUL_RES;
                when I_MUL_RES =>
                    ri <= fpuResult;                                 
                    state <= D_SUB;
                when D_SUB =>
                    --rd <= (kd * (error - preverror));
                    fpuVal0 <= error;
                    fpuVal1 <= preverror;
                    fpuOpCode <= "10"; -- subtract
                    state <= D_SUB_RES;                    
                when D_SUB_RES =>
                    temp <= fpuResult;
                    state <= D_MUL;
                when D_MUL =>
                    fpuVal0 <= kd;
                    fpuVal1 <= temp;
                    fpuOpCode <= "11"; -- multiply
                    state <= D_MUL_RES;
                when D_MUL_RES => 
                    rd <= fpuResult;
                    state <= PI_SUM;
                when PI_SUM =>
                    -- temp <= rp + ri;
                    fpuVal0 <= rp;
                    fpuVal1 <= ri;
                    fpuOpCode <= "01"; -- add
                    state <= PI_SUM_RES;
                when PI_SUM_RES =>
                    temp <= fpuResult;
                    state <= ID_SUM;
                when ID_SUM =>
                    -- result <= temp + rd;
                    fpuVal0 <= temp;
                    fpuVal1 <= rd;
                    fpuOpCode <= "01"; -- add
                    state <= ID_SUM_RES;
                when ID_SUM_RES =>
                    Result <= fpuResult;
                    state <= RESET;
                when RESET =>                                        
                    prevError <= error;
                    ResultReady <= '1';
                    state <= CALC_ERROR;                     
            end case;
        end if;
    end process;

end Behavioral;
