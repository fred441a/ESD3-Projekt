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
  scl_master:           inout std_logic;
  sda_master:           inout std_logic;
  -- emergency_stop:    in std_logic;
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
    
    component change_sensor is
        port (
        clk : in STD_LOGIC;
        scl : inout STD_LOGIC;
        sda : inout STD_LOGIC;

        EN : IN STD_LOGIC;

        WriteMemBus : inout STD_LOGIC_VECTOR( 31 downto 0 );
        ADDRMemBus : inout STD_LOGIC_VECTOR( 7 downto 0 );
        MemWrite : INOUT STD_LOGIC;
        ReadMem : IN ram_type    
        );   
    end component;
    
     -- Write internal signals here:
    signal calibrationPwmOut    : std_logic_vector(7 downto 0);
    signal calibrationPwmFinish : std_logic;

    signal sda_master_buffer : std_logic ;
    signal scl_master_buffer : std_logic ;
    
    signal EXTERNAL_WRITE_ADDRESS : std_logic_vector(7 downto 0);
    signal EXTERNAL_WRITE_DATA    : std_logic_vector(31 downto 0);
    signal EXTERNAL_WRITE_REQ     : std_logic := '0';
    
    signal SENSOR_WRITE_ADDRESS : std_logic_vector(7 downto 0);
    signal SENSOR_WRITE_DATA : std_logic_vector (31 downto 0);
    signal SENSOR_WRITE_REQ : std_logic := '0';

	
begin
    
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
            end if;
            
            if (EXTERNAL_WRITE_REQ = '1') then -- write recieved data from mcu
                memory(to_integer(unsigned(EXTERNAL_WRITE_ADDRESS))) <= EXTERNAL_WRITE_DATA;
            end if;

            if (SENSOR_WRITE_REQ = '1') then -- write recieved data from mcu
                memory(to_integer(unsigned(SENSOR_WRITE_ADDRESS))) <= SENSOR_WRITE_DATA;
            end if;
            
            -- \/ this seems wrong...
--            if (INTERNAL_READY_FLAG = '1') then -- write recieved data from mcu
--                memory(to_integer(unsigned(EXTERNAL_WRITE_ADDRESS))) <= EXTERNAL_WRITE_DATA;
--            end if;
        end if;
    end process;

    Slave2MasterConnect : process (CLK)
    begin
        CASE INTERNAL_READY_FLAG IS
            WHEN '1' =>
                sda_master_buffer <= sda_master;
                scl_master_buffer <= scl_master;
            WHEN '0' =>
                sda_master_buffer <= '1';
                scl_master_buffer <= '1';
                sda_master <= sda_master or sda_slave;
                scl_master <= scl_master or scl_slave;
                sda_slave <= sda_master or sda_slave;
                scl_slave <= scl_master or scl_slave;

        END CASE;

    end process;


    pwmCal: createCalibration
    port map (
        CLK => CLK,
        ready => memory(setupReg)(0), -- "EXTERNAL READY"
        finish => calibrationPwmFinish,
        output => calibrationPwmOut
    );

    pwmGen: PwmModule
    port map (
        PercentCh0 => memory(PWMOut)(7 downto 0),
        PercentCh1 => memory(PWMOut)(15 downto 8),
        PercentCh2 => memory(PWMOut)(23 downto 16),
        PercentCh3 => memory(PWMOut)(31 downto 24),
        clock => CLK,
        PWM => PWM
    );

    i2cExternal: I2C_EXTERNAL_ACCESS
    generic map (deviceAddress => x"08")
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
    
    readSensor: change_sensor
    port map(
        clk => CLK,
        scl => scl_master_buffer,
        sda => sda_master_buffer,
        EN => INTERNAL_READY_FLAG,
        WriteMemBus => SENSOR_WRITE_DATA,
        ADDRMemBus => SENSOR_WRITE_ADDRESS,
        MemWrite => SENSOR_WRITE_REQ,
        ReadMem => memory
    );
end Behavioral;
