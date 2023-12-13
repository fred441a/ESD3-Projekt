library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.shared_types.all;

entity TEST_HARNESS is
port(
		MCLK		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic
	);
end TEST_HARNESS;

architecture Behavioral of TEST_HARNESS is

component I2C_EXTERNAL_ACCESS
    generic (deviceAddress : std_logic_vector(7 downto 0));
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic;
		MEMORY      : inout ram_type
	);
end component;

signal ram : ram_type := (others => (OTHERS => '0'));

begin

    II : I2C_EXTERNAL_ACCESS
        generic map (deviceAddress => x"08")
        port map (
            MCLK => MCLK,
            nRST  => '1',
            SCL  => SCL,
            SDA	 => SDA,
            MEMORY  => ram
        );

end Behavioral;
