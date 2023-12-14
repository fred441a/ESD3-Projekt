----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2023 10:07:37
-- Design Name: 
-- Module Name: PID_PWM_test - Behavioral
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
use IEEE.numeric_std.all;
use IEEE.float_pkg.ALL;

entity PID_PWM_test is
    GENERIC (
        CONSTANT inputClk  : INTEGER := 12_000_000; -- 12Mhz of FPGA
        CONSTANT wantedClk : INTEGER := 400_000*3; -- the frequency wanted for PID, multiplied by 3 as the PID uses 3 clock cycles
        CONSTANT maxClk : INTEGER := ((inputClk / wantedClk)/2) -- divided with 2 as it counts both the low and high period
    );
    Port ( 
        MCLK   : in std_logic;
        InPWM  : in STD_LOGIC;
        OutPWM : out STD_LOGIC_VECTOR(11 downto 0);
        Debug  : out STD_LOGIC
    );
end PID_PWM_test;

architecture Behavioral of PID_PWM_test is
  function float32ToInteger(float_input : std_logic_vector(31 downto 0)) return std_logic_vector is
    variable exponent, shift, fractionInt : INTEGER := 0;
    variable sign : BOOLEAN;
    variable fraction : unsigned(22 downto 0);
  begin
    sign := float_input(31) = '1'; -- get sign
    exponent := to_integer(unsigned(float_input(30 downto 23))) - 127; --take exponent and subtract bias
    shift := -(exponent - 23); -- subtract fraction size (23) and inverrt sign, indicates the amount to right shift inorder to get 
    
    if shift < 23 then 
        fraction := shift_right(unsigned(float_input(22 downto 0)), shift); -- right shift fraction to get missing integer part
        fractionInt := to_integer(fraction); -- conver shiftet fracton to integer
    end if;
        
    if sign then
        return std_logic_vector(to_signed(-((2**exponent) + fractionInt), 32));
    else
        return std_logic_vector(to_signed((2**exponent) + fractionInt, 32));
    end if;
  end float32ToInteger;
  
component PID_Controller
    Port (
        MCLK      : std_logic;
        kp        : in float32;
        ki        : in float32;
        kd        : in float32;
        SetPoint  : in float32;
        Measured  : in float32;
        Result    : out float32;
        ResultReady : out std_logic
    );
    end component;


signal setPoint  : float32;
signal PIDOut, prevPIDOut, Height : float32 := to_float(0.0);
signal clkDivider : INTEGER range 0 to maxClk := 0;
signal clk, ResultReady : std_logic := '0';      
signal s1, mul : float32 := to_float(0.0);
--TYPE tstate is (MULT, SUMa, SUMb, IDLE);
signal state : INTEGER range 0 to 3 := 0;
begin
    setPoint <= to_float(2000.0) when InPWM = '1' else to_float(5.0);
    
    process (MCLK, state) begin
        if (rising_edge(MCLK)) then
            clkDivider <= clkDivider + 1;
            if (clkDivider = maxClk) then 
                clk <= not clk;
            end if; 
             
            if (state = 1) then
                --mul <= PIDOut; -- * to_float(0.5);
                state <= 2;                
                Debug <= not Debug;
            elsif (state = 2) then
                Debug <= not Debug;                                               
                -- s1 <= s1 + mul;
                state <= 3;
            elsif (state = 3) then
                Debug <= not Debug;
                Height <= Height + s1;
                state <= 0;
            end if;
        end if;
        if (falling_edge(MCLK)) then
            --OutPWM <= (others => '0');
            --OutPWM(11) <= float32ToInteger(to_Std_Logic_Vector(Height))(31);
            --OutPWM(10 downto 0) <= float32ToInteger(to_Std_Logic_Vector(Height))(10 downto 0);
            OutPWM(11 downto 0) <= float32ToInteger(to_Std_Logic_Vector(Height))(11 downto 0);
            --OutPWM(3 downto 0) <= "0001" when state = 0 else
            --                      "0010" when state = 1 else
            --                      "0100" when state = 2 else
            --                      "1000" when state = 3 else
            --                      "0000";
        end if;
        if (rising_edge(clk)) then -- and prevPIDOut /= PIDOut) then -- "/=" is VHDL equvalent to C 
            state <= 1;
                        
            --if (PIDOut < -0.4 and Height > 1) then
            --    Height <= (Height - 0.5); --(PIDOut * 0.5)
            --elsif (PIDOut > 0.4) then
            --    Height <= (Height + 0.5);
            --end if;
            
            --if (to_integer(signed(float32ToInteger(to_Std_Logic_Vector(to_float(2.0))))) > 0) then --gt(PIDOut, to_float(0))
            --    Debug <= '1';
                --Height <= (Height + 1.0);
            --elsif (to_integer(signed(float32ToInteger(to_Std_Logic_Vector(Height)))) > 1 and to_integer(signed(float32ToInteger(to_Std_Logic_Vector(PIDOut)))) < 0) then --gt(height, to_float(1)) and lt(PIDOut, to_float(0))
            --    Debug <= '1';
                --Height <= (Height - 1.0);
            --end if;
            --Height <= Height + PIDOut;
        end if;        
        --if (falling_edge(CLK)) then 
        --    Debug <= '0';
        --end if;
    end process;
    
    PID_ALTITUDE: PID_Controller
    Port map (
        MCLK      => CLK,
        kp        => to_float(1.0),  -- Altitude Kp
        ki        => to_float(0.05), -- Altitude Ki
        kd        => to_float(3.0),  -- Altitude Kd
        SetPoint  => setPoint, -- Wanted altitude
        Measured  => Height,   -- Measured altitude
        Result    => PIDOut,
        ResultReady => ResultReady
    );
end Behavioral;
