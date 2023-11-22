----------------------------------------------------------------------------------
-- Company:  Gruppe310
-- Engineer: Frederik Hansen
-- 
-- Create Date: 11/02/2023 10:18:55 AM
-- Design Name: 
-- Module Name: Read_Bit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Read_Byte is
    Port ( 
           clk : in STD_LOGIC;
           scl : inout STD_LOGIC;
           sda : inout STD_LOGIC;
           enable: in STD_LOGIC;   
           BusyOut: out STD_LOGIC;
           I2C_ADDR: in STD_LOGIC_VECTOR(6 downto 0);
           I2C_REG: in STD_LOGIC_VECTOR(7 downto 0);
           DATA: out STD_LOGIC_VECTOR(7 downto 0)
           
           );
end Read_Byte;


architecture Behavioral of Read_Byte is
  
  TYPE MainState IS (Ready, WriteAdress, ReadWait, ReadData, OUTPUT);
  
  SIGNAL STATE:MainState := Ready;
  SIGNAL BufferSTATE:MainState;

  SIGNAL WaitClock:integer := 0;

  -- I2C module signals
  SIGNAL reset_n: std_logic := '1';
  SIGNAL begin_transaction: std_logic := '0';
  SIGNAL rw: std_logic;
  SIGNAL busy: std_logic;
  SIGNAL data_rd: std_logic_vector(7 downto 0);
  SIGNAL ack_error: std_logic;
  
  TYPE PulseState IS (Pulsing,PulseDone);
  SIGNAL PulseMachine: PulseState := Pulsing;

begin

  I2C_Master : entity work.i2c_master
    port map (
      scl       => scl,      --serial clock output of i2c bus
      sda       => sda,      --serial data output
      clk       => clk,      --system clock

      reset_n   => reset_n,  --active low reset
      ena       => begin_transaction,      --latch in command
      addr      => I2C_ADDR,     --address of target slave
      rw        => rw,       --'0' is write, '1' is read
      data_wr   => I2C_REG,  --data to write to slave
      busy      => busy,     --indicates transaction in progress
      data_rd   => DATA,  --data read from slave
      ack_error => ack_error --flag if improper acknowledge from slave
    );



  process(clk)
  begin
    if(rising_edge(clk))then

      CASE STATE IS
        WHEN Ready =>
            BusyOut <= '0';
          if(enable = '1') then
            STATE <= WriteAdress;
          end if;
        WHEN WriteAdress =>
            BusyOut <= '1';
            rw <= '0';
            CASE PulseMachine IS
            WHEN Pulsing =>
                begin_transaction <='1';
                PulseMachine <= PulseDone;
            WHEN PulseDone =>
                if( busy = '1') then
                    begin_transaction <= '0';
                end if;

                if ( busy = '0' and begin_transaction = '0' ) then
                    PulseMachine <= Pulsing;
                    STATE <= ReadWait;
                end if;
            WHEN OTHERS => PulseMachine <= Pulsing;
            END CASE;
        WHEN ReadWait =>
            if(WaitClock > 1200)then
                WaitClock <= 0;
                STATE <= ReadData;
            else
                WaitClock <= WaitClock + 1;
            end if;
        WHEN ReadData => 
            rw <= '1';
            CASE PulseMachine IS
            WHEN Pulsing =>
                begin_transaction <='1';
                PulseMachine <= PulseDone;
            WHEN PulseDone =>
                if ( busy = '1') then
                    begin_transaction <= '0';
                end if;
                if ( busy = '0' and begin_transaction = '0' ) then
                    PulseMachine <= Pulsing;
                    STATE <= Ready;
                end if;
            WHEN OTHERS => PulseMachine <= Pulsing;
            END CASE;
        WHEN OTHERS => NULL;
      END CASE;

    end if;

  end process;


end Behavioral;
   
