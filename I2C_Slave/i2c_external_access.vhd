library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.shared_types.all;

entity I2C_EXTERNAL_ACCESS is
GENERIC (deviceAddress : std_logic_vector(7 downto 0) := x"08");
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic;
		RAM         : inout ram_type
	);
end I2C_EXTERNAL_ACCESS;

architecture rtl of I2C_EXTERNAL_ACCESS is

-- COMPONENTS --
	component I2CSLAVE
		generic(DEVICE: std_logic_vector(7 downto 0));
		port(
			MCLK		  : in	std_logic;
			nRST		  : in	std_logic;
			SDA_IN		  : in	std_logic;
			SCL_IN		  : in	std_logic;
			SDA_OUT		  : out	std_logic;
			SCL_OUT		  : out	std_logic;
			ADDRESS		  : out	std_logic_vector(7 downto 0);
			DATA_OUT	  : out	std_logic_vector(7 downto 0);
			DATA_IN		  : in	std_logic_vector(7 downto 0);
			WR			  : out	std_logic;
			RD			  : out	std_logic;
			ADDRESS_READY : out std_logic
		);
	end component;
	
	
	-- SIGNALS --
	signal SDA_IN		 : std_logic;
	signal SCL_IN		 : std_logic;
	signal SDA_OUT		 : std_logic;
	signal SCL_OUT		 : std_logic;
	signal ADDRESS		 : std_logic_vector(7 downto 0);
	signal DATA_OUT		 : std_logic_vector(7 downto 0);
	signal DATA_IN		 : std_logic_vector(7 downto 0);
	signal WR			 : std_logic;
	signal RD			 : std_logic;
	signal ADDRESS_READY : std_logic;
    
    signal BUFFER_32     : std_logic_vector(31 DOWNTO 0);
    signal BUFFER_8      : std_logic_vector(7 DOWNTO 0);
    signal bytePos       : integer range 0 to 3 := 3; -- used to indecate each byte in 32bit word
    
    signal WRq			 : std_logic;
    signal WRqq			 : std_logic;
	signal RDq			 : std_logic;
	signal RDqq			 : std_logic;
	signal ADDq			 : std_logic;
	signal ADDqq		 : std_logic;
begin

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
			RD			=> RD,
			ADDRESS_READY => ADDRESS_READY
		);
	
	READ_WRITE : process(MCLK)
	begin
	   if (rising_edge(MCLK)) then
           WRqq <= WRq;
           WRq <= WR;
           
           RDqq <= RDq;
           RDq <= RD;
           
           ADDqq <= ADDq;
           ADDq <= ADDRESS_READY; 
           	   
           if (ADDqq = '0' and ADDq = '1') then -- rising edge
               BUFFER_8 <= ADDRESS;               
               BUFFER_32 <= (others => '0');
               bytePos <= 3; -- reset
           elsif (RDqq = '0' and RDq = '1') then -- rising edge
               case bytePos is
                when 3 =>                
                    BUFFER_32 <= RAM(to_integer(unsigned(BUFFER_8)));
                    DATA_IN <= RAM(to_integer(unsigned(BUFFER_8)))(31 DOWNTO 24); --MSB
                    bytePos <= bytePos - 1;
                when 2 =>
                    DATA_IN <= BUFFER_32(23 DOWNTO 16);
                    bytePos <= bytePos - 1;
                when 1 =>
                    DATA_IN <= BUFFER_32(15 DOWNTO 8);
                    bytePos <= bytePos - 1;
                when 0 =>
                    DATA_IN <= BUFFER_32(7 DOWNTO 0); --LSB
                    bytePos <= 3; -- reset
                    BUFFER_8 <= (others => '0');                    
               end case;
           elsif (WRqq = '0' and WRq = '1') then -- rising edge
               case bytePos is
                 when 3 =>
                    BUFFER_32(31 DOWNTO 24) <= DATA_OUT; --MSB
                    bytePos <= bytePos - 1;
                when 2 =>
                    BUFFER_32(23 DOWNTO 16) <= DATA_OUT;
                    bytePos <= bytePos - 1;
                when 1 =>
                    BUFFER_32(15 DOWNTO 8) <= DATA_OUT;
                    bytePos <= bytePos - 1;
                when 0 =>
                    BUFFER_32(7 DOWNTO 0) <= DATA_OUT; --LSB
                    --ram(to_integer(unsigned(BUFFER_8))) <= BUFFER_32;
                    --ram(to_integer(unsigned(BUFFER_8)))(7 downto 0) <= DATA_OUT; --LSB
                    --bytePos <= 3; -- reset
                    --BUFFER_8 <= (others => '0');
               end case;
           elsif (bytePos = 0 and WRqq = '1' and WRq = '1') then
               bytePos <= 3; -- reset
               CASE BUFFER_8 IS
                  WHEN x"01" =>
                    -- overwrite "internal ready" flag with current value
                    BUFFER_32(1) <= ram(to_integer(unsigned(BUFFER_8)))(1); 
                  WHEN x"15" | x"18" | x"1B" | x"1D" | x"1F" | x"24" | x"26" | x"29" | x"2B" | x"2D" => 
                    -- on external write access to readonly registers - overwrite buffer with current reg value
                    BUFFER_32 <= RAM(to_integer(unsigned(BUFFER_8))); 
               END CASE;
               RAM(to_integer(unsigned(BUFFER_8))) <= BUFFER_32;
               BUFFER_8 <= (others => '0');
           end if;
       end if;
	end process READ_WRITE;
	
	--  open drain PAD pull up 1.5K needed
	SCL <= 'Z' when SCL_OUT='1' else '0';
	SCL_IN <= to_UX01(SCL);
	SDA <= 'Z' when SDA_OUT='1' else '0';
	SDA_IN <= to_UX01(SDA);

end rtl;

