--###############################
--# Project Name : I2C Slave
--# File         : i2cdemo.vhd
--# Project      : ic2 slave + Single port RAM 256 * 8 (ALTERA compatible)
--# Engineer     : Philippe THIRION
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity I2CDEMO is
GENERIC (
    wordSize : INTEGER := 32;
    wordCount : INTEGER := 45; --0x2D
    
    deviceAddress : std_logic_vector(7 downto 0) := x"7F"
  );
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic
	);
end I2CDEMO;

architecture rtl of I2CDEMO is
TYPE ram_type IS ARRAY (natural range 0 to wordCount-1) OF std_logic_vector (wordSize - 1 DOWNTO 0);
signal ram : ram_type := (others => (OTHERS => '0'));

-- COMPONENTS --
	component I2CSLAVE
		generic( DEVICE: std_logic_vector(7 downto 0));
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SDA_IN		: in	std_logic;
			SCL_IN		: in	std_logic;
			SDA_OUT		: out	std_logic;
			SCL_OUT		: out	std_logic;
			ADDRESS		: out	std_logic_vector(7 downto 0);
			DATA_OUT	: out	std_logic_vector(7 downto 0);
			DATA_IN		: in	std_logic_vector(7 downto 0);
			WR			: out	std_logic;
			RD			: out	std_logic
		);
	end component;
	
	
	-- SIGNALS --
	signal SDA_IN		: std_logic;
	signal SCL_IN		: std_logic;
	signal SDA_OUT		: std_logic;
	signal SCL_OUT		: std_logic;
	signal ADDRESS		: std_logic_vector(7 downto 0);
	signal DATA_OUT		: std_logic_vector(7 downto 0);
	signal DATA_IN		: std_logic_vector(7 downto 0);
	signal WR			: std_logic;
	signal RD			: std_logic;
    
    signal BUFFER_32 : std_logic_vector(wordSize-1 DOWNTO 0);
    signal BUFFER_8 : std_logic_vector(7 DOWNTO 0);
    signal bytePos : integer range 0 to 3 := 3; -- used to indecate each byte in 32bit word
begin
    ram(23) <= x"33323130";

	I_I2CITF : I2CSLAVE
		generic map (DEVICE => deviceAddress)
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SDA_IN		=> SDA_IN,
			SCL_IN		=> SCL_IN,
			SDA_OUT		=> SDA_OUT,
			SCL_OUT		=> SCL_OUT,
			ADDRESS		=> ADDRESS,
			DATA_OUT	=> DATA_OUT,
			DATA_IN		=> DATA_IN,
			WR			=> WR,
			RD			=> RD
		);
	
	B8 : process(RD,WR)
	begin
	   if (rising_edge(RD)) then
	       case bytePos is
            when 3 =>
                BUFFER_8 <= ADDRESS;
                BUFFER_32 <= ram(to_integer(unsigned(BUFFER_8)));
                DATA_IN <= BUFFER_32(31 DOWNTO 24);
                bytePos <= bytePos - 1;
            when 2 =>
                DATA_IN <= BUFFER_32(23 DOWNTO 16);
                bytePos <= bytePos - 1;
            when 1 =>
                DATA_IN <= BUFFER_32(15 DOWNTO 8);
                bytePos <= bytePos - 1;
            when 0 =>
                DATA_IN <= BUFFER_32(7 DOWNTO 0);
                bytePos <= 3; -- reset
                BUFFER_8 <= (others => '0');
           end case;
        elsif (rising_edge(WR)) then
            case bytePos is
             when 3 =>
                BUFFER_8 <= ADDRESS;
                BUFFER_32(31 DOWNTO 24) <= DATA_OUT;
                bytePos <= bytePos - 1;
            when 2 =>
                BUFFER_32(23 DOWNTO 16) <= DATA_OUT;
                bytePos <= bytePos - 1;
            when 1 =>
                BUFFER_32(15 DOWNTO 8) <= DATA_OUT;
                bytePos <= bytePos - 1;
            when 0 =>
                BUFFER_32(7 DOWNTO 0) <= DATA_OUT;
                ram(to_integer(unsigned(BUFFER_8))) <= BUFFER_32;
                bytePos <= 3; -- reset
                BUFFER_8 <= (others => '0');
           end case;
        end if;
	end process B8;
	
	--  open drain PAD pull up 1.5K needed
	SCL <= 'Z' when SCL_OUT='1' else '0';
	SCL_IN <= to_UX01(SCL);
	SDA <= 'Z' when SDA_OUT='1' else '0';
	SDA_IN <= to_UX01(SDA);

end rtl;

