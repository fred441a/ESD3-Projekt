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
           PercentCh0 : in STD_LOGIC_VECTOR (7 downto 0);
           PercentCh1 : in STD_LOGIC_VECTOR (7 downto 0);
           PercentCh2 : in STD_LOGIC_VECTOR (7 downto 0);
           PercentCh3 : in STD_LOGIC_VECTOR (7 downto 0);
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
    
    component I2C_EXTERNAL_ACCESS is
        port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic;
		MEMORY_READ : in ram_type;

        WRITE_ADDRESS : out std_logic_vector(7 downto 0);
		WRITE_DATA    : out std_logic_vector(31 downto 0);
		WRITE_REQ     : out std_logic
	);
    end component;   
    
     -- Write internal signals here:
    signal calibrationPwmOut : std_logic_vector(7 downto 0);
    signal calibrationPwmFinish : std_logic;
    
    signal EXTERNAL_WRITE_ADDRESS : std_logic_vector(7 downto 0);
	signal EXTERNAL_WRITE_DATA    : std_logic_vector(31 downto 0);
	signal EXTERNAL_WRITE_REQ     : std_logic := '0';
begin
    
    MEMORY_WRITE: process (CLK) begin
        if (falling_edge(CLK)) then 
            -- write to memory on falling-edge as values are set to write on rising-edge  
            memory(16#01#)(1) <= calibrationPwmFinish;
            if (calibrationPwmFinish = '0') then 
                -- only set calibration pwm values when calibrating
                -- i.e when not finished calibration
                memory(16#15#)(7 downto 0)   <= calibrationPwmOut;
                memory(16#15#)(15 downto 8)  <= calibrationPwmOut;
                memory(16#15#)(23 downto 16) <= calibrationPwmOut;
                memory(16#15#)(31 downto 24) <= calibrationPwmOut;
            end if;
            
            if (EXTERNAL_WRITE_REQ = '1') then -- write recieved data from mcu
                memory(to_integer(unsigned(EXTERNAL_WRITE_ADDRESS))) <= EXTERNAL_WRITE_DATA;
            end if;
        end if;
    end process;

    pwmCal: createCalibration
    port map (
        CLK => CLK,
        ready => memory(16#01#)(0), -- "EXTERNAL READY"
        finish => calibrationPwmFinish,
        output => calibrationPwmOut
    );

    pwmGen: PwmModule
    port map (
        PercentCh0 => memory(16#15#)(7 downto 0),
        PercentCh1 => memory(16#15#)(15 downto 8),
        PercentCh2 => memory(16#15#)(23 downto 16),
        PercentCh3 => memory(16#15#)(31 downto 24),
        clock => CLK,
        PWM => PWM
    );

    i2cExternal: I2C_EXTERNAL_ACCESS
    port map(
        MCLK => CLK,
        nRST => '1', -- this module shall never reset
        SCL => scl_slave,
        SDA => sda_slave,
        MEMORY_READ => memory,
        
        WRITE_ADDRESS => EXTERNAL_WRITE_ADDRESS,
        WRITE_DATA => EXTERNAL_WRITE_DATA,
        WRITE_REQ => EXTERNAL_WRITE_REQ
    );


end Behavioral;
