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
use IEEE.float_pkg.all;
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
  scl_sensor:           inout std_logic;
  sda_sensor:           inout std_logic;
  emergency_stop:       in std_logic;
  PWM:                  out std_logic_vector (3 downto 0)
  );
end flightController;

architecture Behavioral of flightController is
   signal memory: ram_type := (others =>(OTHERS => '0'));
   signal INTERNAL_READY_FLAG: STD_LOGIC := '0';
   
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
        generic (deviceAddress : std_logic_vector(7 downto 0));
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
    
--    component change_sensor is
--        port (
--        clk : in STD_LOGIC;
--        scl : inout STD_LOGIC;
--        sda : inout STD_LOGIC;

--        EN : IN STD_LOGIC;

--        WriteMemBus : inout STD_LOGIC_VECTOR( 31 downto 0 );
--        ADDRMemBus : inout STD_LOGIC_VECTOR( 7 downto 0 );
--        MemWrite : INOUT STD_LOGIC;
--        ReadMem : IN ram_type    
--        );   
--    end component;
    
    component PID is
    port (
        MCLK         : in std_logic;
        MEMORY       : in ram_type;      
        RES_PITCH    : out float32;
        RES_ROLL     : out float32;
        RES_YAW      : out float32;
        RES_ALTITUDE : out float32
    );
    end component;
    
    component topBrain is
    Port ( 
          CLK:      in STD_logic;
          cha0:     out std_logic_vector (7 downto 0);
          cha1:     out std_logic_vector (7 downto 0);
          cha2:     out std_logic_vector (7 downto 0);
          cha3:     out std_logic_vector (7 downto 0);
          
          pitchPid:     in float32;
          rollPid:      in float32;
          yawPid:       in float32;
          latPid:       in float32          
    );
    end component;
 
     -- Write internal signals here:
    signal calibrationPwmOut              : std_logic_vector(7 downto 0);
    signal calibrationPwmFinish           : std_logic;
    signal resCh0, resCh1, resCh2, resCh3 : std_logic_vector(7 downto 0);

    signal sda_master : std_logic;
    signal scl_master : std_logic;
    
    signal EXTERNAL_WRITE_ADDRESS : std_logic_vector(7 downto 0);
    signal EXTERNAL_WRITE_DATA    : std_logic_vector(31 downto 0);
    signal EXTERNAL_WRITE_REQ     : std_logic := '0';
    
    signal SENSOR_WRITE_ADDRESS : std_logic_vector(7 downto 0);
    signal SENSOR_WRITE_DATA    : std_logic_vector (31 downto 0);
    signal SENSOR_WRITE_REQ     : std_logic := '0';
    
    signal RES_PITCH, RES_ROLL, RES_YAW, RES_ALTITUDE : float32 := to_float(0.0);
    signal PWM_internal: std_logic_vector (3 downto 0);
begin

INTERNAL_READY_FLAG <= memory(setupReg)(1);
-- emergency_stop shall be pulled up, when connected to GND the emergency stop is activated.
PWM <= (others => '0') when not emergency_stop = '1' else PWM_internal; 
    
    MEMORY_WRITE: process (CLK) begin
        if (falling_edge(CLK)) then 
            -- write to memory on falling-edge as values are set to write on rising-edge  
            memory(setupReg)(1) <= calibrationPwmFinish;
            if (calibrationPwmFinish = '0') then 
                -- only set calibration pwm values when calibrating
                -- i.e when not finished calibration
                memory(PWMOut)(7 downto 0)   <= calibrationPwmOut;
                memory(PWMOut)(15 downto 8)  <= calibrationPwmOut;
                memory(PWMOut)(23 downto 16) <= calibrationPwmOut;
                memory(PWMOut)(31 downto 24) <= calibrationPwmOut;
            else
                -- only set pwm values after calibration
                -- i.e when finished calibration
                memory(PWMOut)(7 downto 0)   <= resCh0;
                memory(PWMOut)(15 downto 8)  <= resCh1;
                memory(PWMOut)(23 downto 16) <= resCh2;
                memory(PWMOut)(31 downto 24) <= resCh3;
            end if;
            
            if (EXTERNAL_WRITE_REQ = '1') then -- write recieved data from mcu
                memory(to_integer(unsigned(EXTERNAL_WRITE_ADDRESS))) <= EXTERNAL_WRITE_DATA;
            end if;

            if (SENSOR_WRITE_REQ = '1') then -- write recieved data from mcu
                memory(to_integer(unsigned(SENSOR_WRITE_ADDRESS))) <= SENSOR_WRITE_DATA;
            end if;
        end if;
    end process;

    pwmCal: createCalibration
    port map (
        CLK    => CLK,
        ready  => memory(setupReg)(0), -- "EXTERNAL READY"
        finish => calibrationPwmFinish,
        output => calibrationPwmOut
    );

    pwmGen: PwmModule
    port map (
        PercentCh0 => memory(PWMOut)(7 downto 0),
        PercentCh1 => memory(PWMOut)(15 downto 8),
        PercentCh2 => memory(PWMOut)(23 downto 16),
        PercentCh3 => memory(PWMOut)(31 downto 24),
        clock      => CLK,
        PWM        => PWM_internal
    );

    i2cExternal: I2C_EXTERNAL_ACCESS
    generic map (deviceAddress => x"08")
    port map(
        MCLK          => CLK,
        nRST          => '1', -- this module shall never reset
        SCL           => scl_slave,
        SDA           => sda_slave,
        MEMORY_READ   => memory,
        
        WRITE_ADDRESS => EXTERNAL_WRITE_ADDRESS,
        WRITE_DATA    => EXTERNAL_WRITE_DATA,
        WRITE_REQ     => EXTERNAL_WRITE_REQ
    );
    
--    readSensor: change_sensor
--    port map(
--        clk         => CLK,
--        scl         => scl_master,
--        sda         => sda_master,
--        EN          => INTERNAL_READY_FLAG,
--        WriteMemBus => SENSOR_WRITE_DATA,
--        ADDRMemBus  => SENSOR_WRITE_ADDRESS,
--        MemWrite    => SENSOR_WRITE_REQ,
--        ReadMem     => memory
--    );
    
    pidBlock: PID
    port  map (
        MCLK         => CLK,
        MEMORY       => memory,      
        RES_PITCH    => RES_PITCH,
        RES_ROLL     => RES_ROLL,
        RES_YAW      => RES_YAW,
        RES_ALTITUDE => RES_ALTITUDE
    );
    
    DIST_MATRIX: topBrain
    port map ( 
        CLK      => CLK,
        cha0     => resCh0,
        cha1     => resCh1,
        cha2     => resCh2,
        cha3     => resCh3,
              
--        pitchPid => to_float(memory(pitchWanted)),
--        rollPid  => to_float(memory(rollWanted)),
--        yawPid   => to_float(memory(yawWanted)),
--        latPid   => to_float(unsigned(memory(altitudeWanted)))

        pitchPid => RES_PITCH,
        rollPid  => RES_ROLL,
        yawPid   => RES_YAW,
        latPid   => RES_ALTITUDE       
    );
end Behavioral;
