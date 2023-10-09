----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/06/2023 07:17:04 AM
-- Design Name: 
-- Module Name: Teset_Harness - Behavioral
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

entity Teset_Harness is
Port (
    clk: in std_logic;
    scl: out std_logic;
    sda: inout std_logic;
    
    begin_transaction: in std_logic;
    busy: out std_logic;
    ack_error: buffer std_logic;
    clk_out: out std_logic
);
end Teset_Harness;


            
architecture Behavioral of Teset_Harness is
   signal reset_n   : STD_LOGIC := '1';                      --active low reset
   -- signal ena       : STD_LOGIC;                             --latch in command
   signal addr      : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0001000"; --address of target slave
   signal rw        : STD_LOGIC := '0';                      --'0' is write, '1' is read
   signal data_wr   : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"f2"; --data to write to slave
   -- signal busy      : STD_LOGIC;                          --indicates transaction in progress
   signal data_rd   : STD_LOGIC_VECTOR(7 DOWNTO 0);          --data read from slave
   -- signal ack_error : STD_LOGIC;                          --flag if improper acknowledge from 
begin

-- ena <= not begin_transaction;
clk_out <= clk;

I2C_Master : entity work.i2c_master
port map (
    scl       => scl,      --serial clock output of i2c bus
    sda       => sda,      --serial data output
    clk       => clk,      --system clock

    reset_n   => reset_n,  --active low reset
    ena       => begin_transaction,      --latch in command
    addr      => addr,     --address of target slave
    rw        => rw,       --'0' is write, '1' is read
    data_wr   => data_wr,  --data to write to slave
    busy      => busy,     --indicates transaction in progress
    data_rd   => data_rd,  --data read from slave
    ack_error => ack_error --flag if improper acknowledge from slave
);

end Behavioral;
