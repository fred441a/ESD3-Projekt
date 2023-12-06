-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.1.1 (lin64) Build 3900603 Fri Jun 16 19:30:25 MDT 2023
-- Date        : Sat Nov 25 21:56:47 2023
-- Host        : Mikkel-laptop running 64-bit Debian GNU/Linux 12 (bookworm)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               /home/mikkel/repoes/ESD3/ESD3-Projekt/PID/real_test/real_test.sim/sim_1/impl/func/xsim/RealTest_func_impl.vhd
-- Design      : RealTest
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity RealTest is
  port (
    ena : in STD_LOGIC;
    a : in STD_LOGIC_VECTOR ( 31 downto 0 );
    result : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of RealTest : entity is true;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ of RealTest : entity is std.standard.true;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ of RealTest : entity is std.standard.true;
  attribute ECO_CHECKSUM : string;
  attribute ECO_CHECKSUM of RealTest : entity is "3f0b8090";
end RealTest;

architecture STRUCTURE of RealTest is
  signal a_IBUF : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ena_IBUF : STD_LOGIC;
  signal ena_IBUF_BUFG : STD_LOGIC;
  signal float32ToInteger : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal float32ToInteger0 : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal float32ToInteger1 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \float32ToInteger1__0\ : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal float32ToInteger20_in : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal result_OBUF : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \result_reg[0]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_11_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_12_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_8_n_0\ : STD_LOGIC;
  signal \result_reg[0]_i_9_n_0\ : STD_LOGIC;
  signal \result_reg[11]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[11]_i_11_n_0\ : STD_LOGIC;
  signal \result_reg[11]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[11]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[11]_i_8_n_0\ : STD_LOGIC;
  signal \result_reg[11]_i_9_n_0\ : STD_LOGIC;
  signal \result_reg[12]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[12]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[12]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[12]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[12]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[15]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[15]_i_11_n_0\ : STD_LOGIC;
  signal \result_reg[15]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[15]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[15]_i_8_n_0\ : STD_LOGIC;
  signal \result_reg[15]_i_9_n_0\ : STD_LOGIC;
  signal \result_reg[16]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[16]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[16]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[16]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[16]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_11_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_12_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_13_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_14_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_15_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_16_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_17_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_18_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_19_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_8_n_0\ : STD_LOGIC;
  signal \result_reg[19]_i_9_n_0\ : STD_LOGIC;
  signal \result_reg[20]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[20]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[20]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[20]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[20]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_11_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_12_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_13_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_14_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_15_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_16_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_8_n_0\ : STD_LOGIC;
  signal \result_reg[23]_i_9_n_0\ : STD_LOGIC;
  signal \result_reg[24]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[24]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[24]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[24]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[24]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[27]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[28]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[28]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[28]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[28]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[28]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[31]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[31]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[31]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[31]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[4]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[4]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[4]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[4]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[4]_i_6_n_0\ : STD_LOGIC;
  signal \result_reg[4]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[7]_i_10_n_0\ : STD_LOGIC;
  signal \result_reg[7]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[7]_i_7_n_0\ : STD_LOGIC;
  signal \result_reg[7]_i_8_n_0\ : STD_LOGIC;
  signal \result_reg[7]_i_9_n_0\ : STD_LOGIC;
  signal \result_reg[8]_i_2_n_0\ : STD_LOGIC;
  signal \result_reg[8]_i_3_n_0\ : STD_LOGIC;
  signal \result_reg[8]_i_4_n_0\ : STD_LOGIC;
  signal \result_reg[8]_i_5_n_0\ : STD_LOGIC;
  signal \result_reg[8]_i_6_n_0\ : STD_LOGIC;
  signal \NLW_result_reg[0]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[11]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[12]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[15]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[16]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[19]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[20]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[23]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[24]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[27]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[28]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[31]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_result_reg[31]_i_2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_result_reg[31]_i_3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[31]_i_3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_result_reg[4]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[7]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_result_reg[8]_i_2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \result_reg[0]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[0]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \result_reg[0]_i_10\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \result_reg[0]_i_11\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \result_reg[0]_i_12\ : label is "soft_lutpair0";
  attribute XILINX_LEGACY_PRIM of \result_reg[10]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[10]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[10]_i_1\ : label is "soft_lutpair17";
  attribute XILINX_LEGACY_PRIM of \result_reg[11]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[11]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[11]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \result_reg[11]_i_11\ : label is "soft_lutpair22";
  attribute XILINX_LEGACY_PRIM of \result_reg[12]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[12]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[12]_i_1\ : label is "soft_lutpair16";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \result_reg[12]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[13]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[13]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[13]_i_1\ : label is "soft_lutpair16";
  attribute XILINX_LEGACY_PRIM of \result_reg[14]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[14]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[14]_i_1\ : label is "soft_lutpair15";
  attribute XILINX_LEGACY_PRIM of \result_reg[15]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[15]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[15]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \result_reg[15]_i_11\ : label is "soft_lutpair5";
  attribute XILINX_LEGACY_PRIM of \result_reg[16]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[16]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[16]_i_1\ : label is "soft_lutpair14";
  attribute ADDER_THRESHOLD of \result_reg[16]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[17]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[17]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[17]_i_1\ : label is "soft_lutpair14";
  attribute XILINX_LEGACY_PRIM of \result_reg[18]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[18]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[18]_i_1\ : label is "soft_lutpair13";
  attribute XILINX_LEGACY_PRIM of \result_reg[19]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[19]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[19]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \result_reg[19]_i_12\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \result_reg[19]_i_16\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \result_reg[19]_i_17\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \result_reg[19]_i_18\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \result_reg[19]_i_19\ : label is "soft_lutpair22";
  attribute XILINX_LEGACY_PRIM of \result_reg[1]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[1]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \result_reg[20]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[20]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[20]_i_1\ : label is "soft_lutpair12";
  attribute ADDER_THRESHOLD of \result_reg[20]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[21]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[21]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[21]_i_1\ : label is "soft_lutpair12";
  attribute XILINX_LEGACY_PRIM of \result_reg[22]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[22]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[22]_i_1\ : label is "soft_lutpair11";
  attribute XILINX_LEGACY_PRIM of \result_reg[23]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[23]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[23]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \result_reg[23]_i_10\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \result_reg[23]_i_11\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \result_reg[23]_i_12\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \result_reg[23]_i_14\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \result_reg[23]_i_15\ : label is "soft_lutpair3";
  attribute XILINX_LEGACY_PRIM of \result_reg[24]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[24]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[24]_i_1\ : label is "soft_lutpair10";
  attribute ADDER_THRESHOLD of \result_reg[24]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[25]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[25]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[25]_i_1\ : label is "soft_lutpair10";
  attribute XILINX_LEGACY_PRIM of \result_reg[26]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[26]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[26]_i_1\ : label is "soft_lutpair9";
  attribute XILINX_LEGACY_PRIM of \result_reg[27]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[27]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[27]_i_1\ : label is "soft_lutpair9";
  attribute XILINX_LEGACY_PRIM of \result_reg[28]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[28]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[28]_i_1\ : label is "soft_lutpair8";
  attribute ADDER_THRESHOLD of \result_reg[28]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[29]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[29]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[29]_i_1\ : label is "soft_lutpair8";
  attribute XILINX_LEGACY_PRIM of \result_reg[2]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[2]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[2]_i_1\ : label is "soft_lutpair21";
  attribute XILINX_LEGACY_PRIM of \result_reg[30]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[30]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[30]_i_1\ : label is "soft_lutpair7";
  attribute XILINX_LEGACY_PRIM of \result_reg[31]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[31]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[31]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \result_reg[31]_i_10\ : label is "soft_lutpair0";
  attribute ADDER_THRESHOLD of \result_reg[31]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[3]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[3]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[3]_i_1\ : label is "soft_lutpair21";
  attribute XILINX_LEGACY_PRIM of \result_reg[4]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[4]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[4]_i_1\ : label is "soft_lutpair20";
  attribute ADDER_THRESHOLD of \result_reg[4]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[5]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[5]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[5]_i_1\ : label is "soft_lutpair20";
  attribute XILINX_LEGACY_PRIM of \result_reg[6]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[6]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[6]_i_1\ : label is "soft_lutpair19";
  attribute XILINX_LEGACY_PRIM of \result_reg[7]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[7]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[7]_i_1\ : label is "soft_lutpair19";
  attribute XILINX_LEGACY_PRIM of \result_reg[8]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[8]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[8]_i_1\ : label is "soft_lutpair18";
  attribute ADDER_THRESHOLD of \result_reg[8]_i_2\ : label is 35;
  attribute XILINX_LEGACY_PRIM of \result_reg[9]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \result_reg[9]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \result_reg[9]_i_1\ : label is "soft_lutpair18";
begin
\a_IBUF[0]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(0),
      O => a_IBUF(0)
    );
\a_IBUF[10]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(10),
      O => a_IBUF(10)
    );
\a_IBUF[11]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(11),
      O => a_IBUF(11)
    );
\a_IBUF[12]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(12),
      O => a_IBUF(12)
    );
\a_IBUF[13]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(13),
      O => a_IBUF(13)
    );
\a_IBUF[14]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(14),
      O => a_IBUF(14)
    );
\a_IBUF[15]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(15),
      O => a_IBUF(15)
    );
\a_IBUF[16]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(16),
      O => a_IBUF(16)
    );
\a_IBUF[17]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(17),
      O => a_IBUF(17)
    );
\a_IBUF[18]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(18),
      O => a_IBUF(18)
    );
\a_IBUF[19]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(19),
      O => a_IBUF(19)
    );
\a_IBUF[1]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(1),
      O => a_IBUF(1)
    );
\a_IBUF[20]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(20),
      O => a_IBUF(20)
    );
\a_IBUF[21]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(21),
      O => a_IBUF(21)
    );
\a_IBUF[22]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(22),
      O => a_IBUF(22)
    );
\a_IBUF[23]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(23),
      O => a_IBUF(23)
    );
\a_IBUF[24]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(24),
      O => a_IBUF(24)
    );
\a_IBUF[25]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(25),
      O => a_IBUF(25)
    );
\a_IBUF[26]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(26),
      O => a_IBUF(26)
    );
\a_IBUF[27]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(27),
      O => a_IBUF(27)
    );
\a_IBUF[28]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(28),
      O => a_IBUF(28)
    );
\a_IBUF[29]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(29),
      O => a_IBUF(29)
    );
\a_IBUF[2]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(2),
      O => a_IBUF(2)
    );
\a_IBUF[30]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(30),
      O => a_IBUF(30)
    );
\a_IBUF[31]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(31),
      O => a_IBUF(31)
    );
\a_IBUF[3]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(3),
      O => a_IBUF(3)
    );
\a_IBUF[4]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(4),
      O => a_IBUF(4)
    );
\a_IBUF[5]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(5),
      O => a_IBUF(5)
    );
\a_IBUF[6]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(6),
      O => a_IBUF(6)
    );
\a_IBUF[7]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(7),
      O => a_IBUF(7)
    );
\a_IBUF[8]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(8),
      O => a_IBUF(8)
    );
\a_IBUF[9]_inst\: unisim.vcomponents.IBUF
     port map (
      I => a(9),
      O => a_IBUF(9)
    );
ena_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => ena_IBUF,
      O => ena_IBUF_BUFG
    );
ena_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => ena,
      O => ena_IBUF
    );
\result_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(0),
      O => result(0)
    );
\result_OBUF[10]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(10),
      O => result(10)
    );
\result_OBUF[11]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(11),
      O => result(11)
    );
\result_OBUF[12]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(12),
      O => result(12)
    );
\result_OBUF[13]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(13),
      O => result(13)
    );
\result_OBUF[14]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(14),
      O => result(14)
    );
\result_OBUF[15]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(15),
      O => result(15)
    );
\result_OBUF[16]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(16),
      O => result(16)
    );
\result_OBUF[17]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(17),
      O => result(17)
    );
\result_OBUF[18]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(18),
      O => result(18)
    );
\result_OBUF[19]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(19),
      O => result(19)
    );
\result_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(1),
      O => result(1)
    );
\result_OBUF[20]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(20),
      O => result(20)
    );
\result_OBUF[21]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(21),
      O => result(21)
    );
\result_OBUF[22]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(22),
      O => result(22)
    );
\result_OBUF[23]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(23),
      O => result(23)
    );
\result_OBUF[24]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(24),
      O => result(24)
    );
\result_OBUF[25]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(25),
      O => result(25)
    );
\result_OBUF[26]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(26),
      O => result(26)
    );
\result_OBUF[27]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(27),
      O => result(27)
    );
\result_OBUF[28]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(28),
      O => result(28)
    );
\result_OBUF[29]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(29),
      O => result(29)
    );
\result_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(2),
      O => result(2)
    );
\result_OBUF[30]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(30),
      O => result(30)
    );
\result_OBUF[31]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(31),
      O => result(31)
    );
\result_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(3),
      O => result(3)
    );
\result_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(4),
      O => result(4)
    );
\result_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(5),
      O => result(5)
    );
\result_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(6),
      O => result(6)
    );
\result_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(7),
      O => result(7)
    );
\result_OBUF[8]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(8),
      O => result(8)
    );
\result_OBUF[9]_inst\: unisim.vcomponents.OBUF
     port map (
      I => result_OBUF(9),
      O => result(9)
    );
\result_reg[0]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger1(0),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(0)
    );
\result_reg[0]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \result_reg[0]_i_1_n_0\,
      CO(2 downto 0) => \NLW_result_reg[0]_i_1_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => float32ToInteger20_in(3 downto 0),
      O(3 downto 1) => \float32ToInteger1__0\(3 downto 1),
      O(0) => float32ToInteger1(0),
      S(3) => \result_reg[0]_i_6_n_0\,
      S(2) => \result_reg[0]_i_7_n_0\,
      S(1) => \result_reg[0]_i_8_n_0\,
      S(0) => \result_reg[0]_i_9_n_0\
    );
\result_reg[0]_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => a_IBUF(30),
      I1 => a_IBUF(28),
      I2 => a_IBUF(29),
      I3 => a_IBUF(26),
      O => \result_reg[0]_i_10_n_0\
    );
\result_reg[0]_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      O => \result_reg[0]_i_11_n_0\
    );
\result_reg[0]_i_12\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000000"
    )
        port map (
      I0 => a_IBUF(26),
      I1 => a_IBUF(29),
      I2 => a_IBUF(28),
      I3 => a_IBUF(30),
      I4 => a_IBUF(27),
      O => \result_reg[0]_i_12_n_0\
    );
\result_reg[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00040000"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      I3 => a_IBUF(27),
      I4 => \result_reg[0]_i_10_n_0\,
      O => float32ToInteger20_in(3)
    );
\result_reg[0]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00100000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => a_IBUF(27),
      I4 => \result_reg[0]_i_10_n_0\,
      O => float32ToInteger20_in(2)
    );
\result_reg[0]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000004"
    )
        port map (
      I0 => a_IBUF(27),
      I1 => \result_reg[0]_i_10_n_0\,
      I2 => a_IBUF(23),
      I3 => a_IBUF(24),
      I4 => a_IBUF(25),
      O => float32ToInteger20_in(1)
    );
\result_reg[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000008000000"
    )
        port map (
      I0 => a_IBUF(26),
      I1 => a_IBUF(27),
      I2 => a_IBUF(30),
      I3 => a_IBUF(29),
      I4 => a_IBUF(28),
      I5 => \result_reg[0]_i_11_n_0\,
      O => float32ToInteger20_in(0)
    );
\result_reg[0]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0882808000020000"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(27),
      I2 => a_IBUF(25),
      I3 => a_IBUF(23),
      I4 => a_IBUF(24),
      I5 => a_IBUF(3),
      O => \result_reg[0]_i_6_n_0\
    );
\result_reg[0]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000820280008000"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(27),
      I2 => a_IBUF(25),
      I3 => a_IBUF(2),
      I4 => a_IBUF(24),
      I5 => a_IBUF(23),
      O => \result_reg[0]_i_7_n_0\
    );
\result_reg[0]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0080800200000002"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(27),
      I2 => a_IBUF(25),
      I3 => a_IBUF(23),
      I4 => a_IBUF(24),
      I5 => a_IBUF(1),
      O => \result_reg[0]_i_8_n_0\
    );
\result_reg[0]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A6AAAAAAAAAAAAAA"
    )
        port map (
      I0 => float32ToInteger20_in(0),
      I1 => \result_reg[0]_i_12_n_0\,
      I2 => a_IBUF(23),
      I3 => a_IBUF(24),
      I4 => a_IBUF(25),
      I5 => a_IBUF(0),
      O => \result_reg[0]_i_9_n_0\
    );
\result_reg[10]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(10),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(10)
    );
\result_reg[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(10),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(10),
      O => float32ToInteger(10)
    );
\result_reg[11]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(11),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(11)
    );
\result_reg[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(11),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(11),
      O => float32ToInteger(11)
    );
\result_reg[11]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AA20202020DF2020"
    )
        port map (
      I0 => a_IBUF(8),
      I1 => \result_reg[11]_i_11_n_0\,
      I2 => \result_reg[23]_i_14_n_0\,
      I3 => \result_reg[0]_i_11_n_0\,
      I4 => \result_reg[0]_i_10_n_0\,
      I5 => a_IBUF(27),
      O => \result_reg[11]_i_10_n_0\
    );
\result_reg[11]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(25),
      O => \result_reg[11]_i_11_n_0\
    );
\result_reg[11]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[7]_i_2_n_0\,
      CO(3) => \result_reg[11]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[11]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => float32ToInteger20_in(11 downto 8),
      O(3 downto 0) => \float32ToInteger1__0\(11 downto 8),
      S(3) => \result_reg[11]_i_7_n_0\,
      S(2) => \result_reg[11]_i_8_n_0\,
      S(1) => \result_reg[11]_i_9_n_0\,
      S(0) => \result_reg[11]_i_10_n_0\
    );
\result_reg[11]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0400"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      I3 => \result_reg[23]_i_14_n_0\,
      O => float32ToInteger20_in(11)
    );
\result_reg[11]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => \result_reg[23]_i_14_n_0\,
      O => float32ToInteger20_in(10)
    );
\result_reg[11]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \result_reg[23]_i_14_n_0\,
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => a_IBUF(25),
      O => float32ToInteger20_in(9)
    );
\result_reg[11]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"40000000"
    )
        port map (
      I0 => a_IBUF(27),
      I1 => \result_reg[0]_i_10_n_0\,
      I2 => a_IBUF(25),
      I3 => a_IBUF(23),
      I4 => a_IBUF(24),
      O => float32ToInteger20_in(8)
    );
\result_reg[11]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FDEE2AAA03000000"
    )
        port map (
      I0 => \result_reg[0]_i_12_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => a_IBUF(24),
      I4 => \result_reg[23]_i_14_n_0\,
      I5 => a_IBUF(11),
      O => \result_reg[11]_i_7_n_0\
    );
\result_reg[11]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8AAAA6AA88880C00"
    )
        port map (
      I0 => a_IBUF(10),
      I1 => \result_reg[23]_i_14_n_0\,
      I2 => a_IBUF(24),
      I3 => a_IBUF(23),
      I4 => a_IBUF(25),
      I5 => \result_reg[0]_i_12_n_0\,
      O => \result_reg[11]_i_8_n_0\
    );
\result_reg[11]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEE92AAA00030000"
    )
        port map (
      I0 => \result_reg[0]_i_12_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => a_IBUF(24),
      I4 => \result_reg[23]_i_14_n_0\,
      I5 => a_IBUF(9),
      O => \result_reg[11]_i_9_n_0\
    );
\result_reg[12]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(12),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(12)
    );
\result_reg[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(12),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(12),
      O => float32ToInteger(12)
    );
\result_reg[12]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[8]_i_2_n_0\,
      CO(3) => \result_reg[12]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[12]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(12 downto 9),
      S(3) => \result_reg[12]_i_3_n_0\,
      S(2) => \result_reg[12]_i_4_n_0\,
      S(1) => \result_reg[12]_i_5_n_0\,
      S(0) => \result_reg[12]_i_6_n_0\
    );
\result_reg[12]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(12),
      O => \result_reg[12]_i_3_n_0\
    );
\result_reg[12]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(11),
      O => \result_reg[12]_i_4_n_0\
    );
\result_reg[12]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(10),
      O => \result_reg[12]_i_5_n_0\
    );
\result_reg[12]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(9),
      O => \result_reg[12]_i_6_n_0\
    );
\result_reg[13]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(13),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(13)
    );
\result_reg[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(13),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(13),
      O => float32ToInteger(13)
    );
\result_reg[14]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(14),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(14)
    );
\result_reg[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(14),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(14),
      O => float32ToInteger(14)
    );
\result_reg[15]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(15),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(15)
    );
\result_reg[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(15),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(15),
      O => float32ToInteger(15)
    );
\result_reg[15]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A62AAAAAA400A800"
    )
        port map (
      I0 => a_IBUF(12),
      I1 => a_IBUF(24),
      I2 => a_IBUF(25),
      I3 => \result_reg[23]_i_14_n_0\,
      I4 => a_IBUF(23),
      I5 => \result_reg[0]_i_12_n_0\,
      O => \result_reg[15]_i_10_n_0\
    );
\result_reg[15]_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      O => \result_reg[15]_i_11_n_0\
    );
\result_reg[15]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[11]_i_2_n_0\,
      CO(3) => \result_reg[15]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[15]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => float32ToInteger20_in(15 downto 12),
      O(3 downto 0) => \float32ToInteger1__0\(15 downto 12),
      S(3) => \result_reg[15]_i_7_n_0\,
      S(2) => \result_reg[15]_i_8_n_0\,
      S(1) => \result_reg[15]_i_9_n_0\,
      S(0) => \result_reg[15]_i_10_n_0\
    );
\result_reg[15]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(23),
      I1 => a_IBUF(24),
      I2 => a_IBUF(25),
      I3 => \result_reg[23]_i_14_n_0\,
      O => float32ToInteger20_in(15)
    );
\result_reg[15]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      I3 => \result_reg[23]_i_14_n_0\,
      O => float32ToInteger20_in(14)
    );
\result_reg[15]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => \result_reg[23]_i_14_n_0\,
      O => float32ToInteger20_in(13)
    );
\result_reg[15]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => \result_reg[23]_i_14_n_0\,
      O => float32ToInteger20_in(12)
    );
\result_reg[15]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F404C4C80808080"
    )
        port map (
      I0 => \result_reg[15]_i_11_n_0\,
      I1 => \result_reg[23]_i_11_n_0\,
      I2 => a_IBUF(26),
      I3 => \result_reg[0]_i_12_n_0\,
      I4 => \result_reg[0]_i_11_n_0\,
      I5 => a_IBUF(15),
      O => \result_reg[15]_i_7_n_0\
    );
\result_reg[15]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9AAA9AAA2AAA0000"
    )
        port map (
      I0 => a_IBUF(14),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      I3 => a_IBUF(25),
      I4 => \result_reg[0]_i_12_n_0\,
      I5 => \result_reg[23]_i_14_n_0\,
      O => \result_reg[15]_i_8_n_0\
    );
\result_reg[15]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA62AAAAAA40000"
    )
        port map (
      I0 => a_IBUF(13),
      I1 => a_IBUF(25),
      I2 => a_IBUF(24),
      I3 => a_IBUF(23),
      I4 => \result_reg[23]_i_14_n_0\,
      I5 => \result_reg[0]_i_12_n_0\,
      O => \result_reg[15]_i_9_n_0\
    );
\result_reg[16]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(16),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(16)
    );
\result_reg[16]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(16),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(16),
      O => float32ToInteger(16)
    );
\result_reg[16]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[12]_i_2_n_0\,
      CO(3) => \result_reg[16]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[16]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(16 downto 13),
      S(3) => \result_reg[16]_i_3_n_0\,
      S(2) => \result_reg[16]_i_4_n_0\,
      S(1) => \result_reg[16]_i_5_n_0\,
      S(0) => \result_reg[16]_i_6_n_0\
    );
\result_reg[16]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(16),
      O => \result_reg[16]_i_3_n_0\
    );
\result_reg[16]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(15),
      O => \result_reg[16]_i_4_n_0\
    );
\result_reg[16]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(14),
      O => \result_reg[16]_i_5_n_0\
    );
\result_reg[16]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(13),
      O => \result_reg[16]_i_6_n_0\
    );
\result_reg[17]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(17),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(17)
    );
\result_reg[17]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(17),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(17),
      O => float32ToInteger(17)
    );
\result_reg[18]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(18),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(18)
    );
\result_reg[18]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(18),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(18),
      O => float32ToInteger(18)
    );
\result_reg[19]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(19),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(19)
    );
\result_reg[19]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(19),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(19),
      O => float32ToInteger(19)
    );
\result_reg[19]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F7FFF007F80FF00"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      I3 => \result_reg[19]_i_15_n_0\,
      I4 => \result_reg[23]_i_14_n_0\,
      I5 => a_IBUF(16),
      O => \result_reg[19]_i_10_n_0\
    );
\result_reg[19]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0A008A000A00A200"
    )
        port map (
      I0 => a_IBUF(19),
      I1 => \result_reg[19]_i_16_n_0\,
      I2 => a_IBUF(27),
      I3 => \result_reg[19]_i_17_n_0\,
      I4 => a_IBUF(26),
      I5 => a_IBUF(25),
      O => \result_reg[19]_i_11_n_0\
    );
\result_reg[19]_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => a_IBUF(23),
      I1 => a_IBUF(25),
      I2 => a_IBUF(24),
      O => \result_reg[19]_i_12_n_0\
    );
\result_reg[19]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000002F00000000"
    )
        port map (
      I0 => \result_reg[19]_i_16_n_0\,
      I1 => a_IBUF(26),
      I2 => a_IBUF(27),
      I3 => a_IBUF(29),
      I4 => a_IBUF(28),
      I5 => a_IBUF(30),
      O => \result_reg[19]_i_13_n_0\
    );
\result_reg[19]_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0808888008008888"
    )
        port map (
      I0 => a_IBUF(17),
      I1 => \result_reg[19]_i_17_n_0\,
      I2 => a_IBUF(26),
      I3 => \result_reg[19]_i_18_n_0\,
      I4 => a_IBUF(27),
      I5 => \result_reg[19]_i_19_n_0\,
      O => \result_reg[19]_i_14_n_0\
    );
\result_reg[19]_i_15\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F000BABA00000000"
    )
        port map (
      I0 => \result_reg[23]_i_11_n_0\,
      I1 => a_IBUF(23),
      I2 => \result_reg[0]_i_10_n_0\,
      I3 => a_IBUF(27),
      I4 => \result_reg[11]_i_11_n_0\,
      I5 => a_IBUF(16),
      O => \result_reg[19]_i_15_n_0\
    );
\result_reg[19]_i_16\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => a_IBUF(23),
      I1 => a_IBUF(24),
      O => \result_reg[19]_i_16_n_0\
    );
\result_reg[19]_i_17\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => a_IBUF(29),
      I1 => a_IBUF(28),
      I2 => a_IBUF(30),
      O => \result_reg[19]_i_17_n_0\
    );
\result_reg[19]_i_18\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"60"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      O => \result_reg[19]_i_18_n_0\
    );
\result_reg[19]_i_19\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => a_IBUF(23),
      I1 => a_IBUF(25),
      O => \result_reg[19]_i_19_n_0\
    );
\result_reg[19]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[15]_i_2_n_0\,
      CO(3) => \result_reg[19]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[19]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => float32ToInteger20_in(19 downto 16),
      O(3 downto 0) => \float32ToInteger1__0\(19 downto 16),
      S(3) => \result_reg[19]_i_7_n_0\,
      S(2) => \result_reg[19]_i_8_n_0\,
      S(1) => \result_reg[19]_i_9_n_0\,
      S(0) => \result_reg[19]_i_10_n_0\
    );
\result_reg[19]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0400"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      I3 => \result_reg[0]_i_12_n_0\,
      O => float32ToInteger20_in(19)
    );
\result_reg[19]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => \result_reg[0]_i_12_n_0\,
      O => float32ToInteger20_in(18)
    );
\result_reg[19]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \result_reg[0]_i_12_n_0\,
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => a_IBUF(25),
      O => float32ToInteger20_in(17)
    );
\result_reg[19]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \result_reg[23]_i_14_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => a_IBUF(24),
      O => float32ToInteger20_in(16)
    );
\result_reg[19]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFDF0020"
    )
        port map (
      I0 => \result_reg[0]_i_12_n_0\,
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => a_IBUF(25),
      I4 => \result_reg[19]_i_11_n_0\,
      O => \result_reg[19]_i_7_n_0\
    );
\result_reg[19]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5A5AF0F05A9AC000"
    )
        port map (
      I0 => \result_reg[19]_i_12_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(18),
      I3 => \result_reg[19]_i_13_n_0\,
      I4 => \result_reg[0]_i_12_n_0\,
      I5 => \result_reg[23]_i_14_n_0\,
      O => \result_reg[19]_i_8_n_0\
    );
\result_reg[19]_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FEFF0100"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      I3 => \result_reg[0]_i_12_n_0\,
      I4 => \result_reg[19]_i_14_n_0\,
      O => \result_reg[19]_i_9_n_0\
    );
\result_reg[1]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(1),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(1)
    );
\result_reg[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(1),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(1),
      O => float32ToInteger(1)
    );
\result_reg[20]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(20),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(20)
    );
\result_reg[20]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(20),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(20),
      O => float32ToInteger(20)
    );
\result_reg[20]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[16]_i_2_n_0\,
      CO(3) => \result_reg[20]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[20]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(20 downto 17),
      S(3) => \result_reg[20]_i_3_n_0\,
      S(2) => \result_reg[20]_i_4_n_0\,
      S(1) => \result_reg[20]_i_5_n_0\,
      S(0) => \result_reg[20]_i_6_n_0\
    );
\result_reg[20]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(20),
      O => \result_reg[20]_i_3_n_0\
    );
\result_reg[20]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(19),
      O => \result_reg[20]_i_4_n_0\
    );
\result_reg[20]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(18),
      O => \result_reg[20]_i_5_n_0\
    );
\result_reg[20]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(17),
      O => \result_reg[20]_i_6_n_0\
    );
\result_reg[21]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(21),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(21)
    );
\result_reg[21]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(21),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(21),
      O => float32ToInteger(21)
    );
\result_reg[22]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(22),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(22)
    );
\result_reg[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(22),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(22),
      O => float32ToInteger(22)
    );
\result_reg[23]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(23),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(23)
    );
\result_reg[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(23),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(23),
      O => float32ToInteger(23)
    );
\result_reg[23]_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      O => \result_reg[23]_i_10_n_0\
    );
\result_reg[23]_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => a_IBUF(30),
      I1 => a_IBUF(28),
      I2 => a_IBUF(29),
      I3 => a_IBUF(27),
      O => \result_reg[23]_i_11_n_0\
    );
\result_reg[23]_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"10"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      O => \result_reg[23]_i_12_n_0\
    );
\result_reg[23]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF2A0000A8A80000"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(24),
      I3 => \result_reg[23]_i_11_n_0\,
      I4 => a_IBUF(21),
      I5 => a_IBUF(23),
      O => \result_reg[23]_i_13_n_0\
    );
\result_reg[23]_i_14\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"01000000"
    )
        port map (
      I0 => a_IBUF(27),
      I1 => a_IBUF(29),
      I2 => a_IBUF(28),
      I3 => a_IBUF(30),
      I4 => a_IBUF(26),
      O => \result_reg[23]_i_14_n_0\
    );
\result_reg[23]_i_15\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      O => \result_reg[23]_i_15_n_0\
    );
\result_reg[23]_i_16\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF2A000088880000"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => \result_reg[23]_i_11_n_0\,
      I4 => a_IBUF(20),
      I5 => a_IBUF(24),
      O => \result_reg[23]_i_16_n_0\
    );
\result_reg[23]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[19]_i_2_n_0\,
      CO(3) => \result_reg[23]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[23]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => float32ToInteger20_in(22 downto 20),
      O(3 downto 0) => \float32ToInteger1__0\(23 downto 20),
      S(3) => float32ToInteger20_in(23),
      S(2) => \result_reg[23]_i_7_n_0\,
      S(1) => \result_reg[23]_i_8_n_0\,
      S(0) => \result_reg[23]_i_9_n_0\
    );
\result_reg[23]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      I3 => \result_reg[0]_i_12_n_0\,
      O => float32ToInteger20_in(22)
    );
\result_reg[23]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => \result_reg[0]_i_12_n_0\,
      O => float32ToInteger20_in(21)
    );
\result_reg[23]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => \result_reg[0]_i_12_n_0\,
      O => float32ToInteger20_in(20)
    );
\result_reg[23]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(23),
      I1 => a_IBUF(24),
      I2 => a_IBUF(25),
      I3 => \result_reg[0]_i_12_n_0\,
      O => float32ToInteger20_in(23)
    );
\result_reg[23]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"77887888F000F000"
    )
        port map (
      I0 => a_IBUF(27),
      I1 => \result_reg[23]_i_10_n_0\,
      I2 => \result_reg[23]_i_11_n_0\,
      I3 => a_IBUF(22),
      I4 => \result_reg[0]_i_11_n_0\,
      I5 => \result_reg[0]_i_10_n_0\,
      O => \result_reg[23]_i_7_n_0\
    );
\result_reg[23]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5F6C5F6C6C6C5C6C"
    )
        port map (
      I0 => \result_reg[23]_i_12_n_0\,
      I1 => \result_reg[23]_i_13_n_0\,
      I2 => \result_reg[0]_i_12_n_0\,
      I3 => a_IBUF(21),
      I4 => a_IBUF(23),
      I5 => \result_reg[23]_i_14_n_0\,
      O => \result_reg[23]_i_8_n_0\
    );
\result_reg[23]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5F6C5F6C6C6C5C6C"
    )
        port map (
      I0 => \result_reg[23]_i_15_n_0\,
      I1 => \result_reg[23]_i_16_n_0\,
      I2 => \result_reg[0]_i_12_n_0\,
      I3 => a_IBUF(20),
      I4 => a_IBUF(24),
      I5 => \result_reg[23]_i_14_n_0\,
      O => \result_reg[23]_i_9_n_0\
    );
\result_reg[24]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(24),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(24)
    );
\result_reg[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(24),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(24),
      O => float32ToInteger(24)
    );
\result_reg[24]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[20]_i_2_n_0\,
      CO(3) => \result_reg[24]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[24]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(24 downto 21),
      S(3) => \result_reg[24]_i_3_n_0\,
      S(2) => \result_reg[24]_i_4_n_0\,
      S(1) => \result_reg[24]_i_5_n_0\,
      S(0) => \result_reg[24]_i_6_n_0\
    );
\result_reg[24]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(24),
      O => \result_reg[24]_i_3_n_0\
    );
\result_reg[24]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(23),
      O => \result_reg[24]_i_4_n_0\
    );
\result_reg[24]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(22),
      O => \result_reg[24]_i_5_n_0\
    );
\result_reg[24]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(21),
      O => \result_reg[24]_i_6_n_0\
    );
\result_reg[25]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(25),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(25)
    );
\result_reg[25]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(25),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(25),
      O => float32ToInteger(25)
    );
\result_reg[26]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(26),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(26)
    );
\result_reg[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(26),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(26),
      O => float32ToInteger(26)
    );
\result_reg[27]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(27),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(27)
    );
\result_reg[27]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(27),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(27),
      O => float32ToInteger(27)
    );
\result_reg[27]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[23]_i_2_n_0\,
      CO(3) => \result_reg[27]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[27]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \float32ToInteger1__0\(27 downto 24),
      S(3 downto 0) => float32ToInteger20_in(27 downto 24)
    );
\result_reg[27]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0400"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(24),
      I2 => a_IBUF(23),
      I3 => \result_reg[31]_i_10_n_0\,
      O => float32ToInteger20_in(27)
    );
\result_reg[27]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => \result_reg[31]_i_10_n_0\,
      O => float32ToInteger20_in(26)
    );
\result_reg[27]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \result_reg[31]_i_10_n_0\,
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => a_IBUF(25),
      O => float32ToInteger20_in(25)
    );
\result_reg[27]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \result_reg[0]_i_12_n_0\,
      I1 => a_IBUF(25),
      I2 => a_IBUF(23),
      I3 => a_IBUF(24),
      O => float32ToInteger20_in(24)
    );
\result_reg[28]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(28),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(28)
    );
\result_reg[28]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(28),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(28),
      O => float32ToInteger(28)
    );
\result_reg[28]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[24]_i_2_n_0\,
      CO(3) => \result_reg[28]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[28]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(28 downto 25),
      S(3) => \result_reg[28]_i_3_n_0\,
      S(2) => \result_reg[28]_i_4_n_0\,
      S(1) => \result_reg[28]_i_5_n_0\,
      S(0) => \result_reg[28]_i_6_n_0\
    );
\result_reg[28]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(28),
      O => \result_reg[28]_i_3_n_0\
    );
\result_reg[28]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(27),
      O => \result_reg[28]_i_4_n_0\
    );
\result_reg[28]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(26),
      O => \result_reg[28]_i_5_n_0\
    );
\result_reg[28]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(25),
      O => \result_reg[28]_i_6_n_0\
    );
\result_reg[29]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(29),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(29)
    );
\result_reg[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(29),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(29),
      O => float32ToInteger(29)
    );
\result_reg[2]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(2),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(2)
    );
\result_reg[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(2),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(2),
      O => float32ToInteger(2)
    );
\result_reg[30]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(30),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(30)
    );
\result_reg[30]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(30),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(30),
      O => float32ToInteger(30)
    );
\result_reg[31]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '1'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(31),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(31)
    );
\result_reg[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(31),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(31),
      O => float32ToInteger(31)
    );
\result_reg[31]_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000080"
    )
        port map (
      I0 => a_IBUF(27),
      I1 => a_IBUF(26),
      I2 => a_IBUF(30),
      I3 => a_IBUF(28),
      I4 => a_IBUF(29),
      O => \result_reg[31]_i_10_n_0\
    );
\result_reg[31]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[28]_i_2_n_0\,
      CO(3 downto 0) => \NLW_result_reg[31]_i_2_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_result_reg[31]_i_2_O_UNCONNECTED\(3),
      O(2 downto 0) => float32ToInteger0(31 downto 29),
      S(3) => '0',
      S(2) => \result_reg[31]_i_4_n_0\,
      S(1) => \result_reg[31]_i_5_n_0\,
      S(0) => \result_reg[31]_i_6_n_0\
    );
\result_reg[31]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[27]_i_2_n_0\,
      CO(3) => \float32ToInteger1__0\(31),
      CO(2 downto 0) => \NLW_result_reg[31]_i_3_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_result_reg[31]_i_3_O_UNCONNECTED\(3),
      O(2 downto 0) => \float32ToInteger1__0\(30 downto 28),
      S(3) => '1',
      S(2 downto 0) => float32ToInteger20_in(30 downto 28)
    );
\result_reg[31]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(31),
      O => \result_reg[31]_i_4_n_0\
    );
\result_reg[31]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(30),
      O => \result_reg[31]_i_5_n_0\
    );
\result_reg[31]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(29),
      O => \result_reg[31]_i_6_n_0\
    );
\result_reg[31]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      I3 => \result_reg[31]_i_10_n_0\,
      O => float32ToInteger20_in(30)
    );
\result_reg[31]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => \result_reg[31]_i_10_n_0\,
      O => float32ToInteger20_in(29)
    );
\result_reg[31]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => \result_reg[31]_i_10_n_0\,
      O => float32ToInteger20_in(28)
    );
\result_reg[3]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(3),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(3)
    );
\result_reg[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(3),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(3),
      O => float32ToInteger(3)
    );
\result_reg[4]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(4),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(4)
    );
\result_reg[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(4),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(4),
      O => float32ToInteger(4)
    );
\result_reg[4]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \result_reg[4]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[4]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => \result_reg[4]_i_3_n_0\,
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(4 downto 1),
      S(3) => \result_reg[4]_i_4_n_0\,
      S(2) => \result_reg[4]_i_5_n_0\,
      S(1) => \result_reg[4]_i_6_n_0\,
      S(0) => \result_reg[4]_i_7_n_0\
    );
\result_reg[4]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => float32ToInteger1(0),
      O => \result_reg[4]_i_3_n_0\
    );
\result_reg[4]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(4),
      O => \result_reg[4]_i_4_n_0\
    );
\result_reg[4]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(3),
      O => \result_reg[4]_i_5_n_0\
    );
\result_reg[4]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(2),
      O => \result_reg[4]_i_6_n_0\
    );
\result_reg[4]_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(1),
      O => \result_reg[4]_i_7_n_0\
    );
\result_reg[5]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(5),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(5)
    );
\result_reg[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(5),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(5),
      O => float32ToInteger(5)
    );
\result_reg[6]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(6),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(6)
    );
\result_reg[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(6),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(6),
      O => float32ToInteger(6)
    );
\result_reg[7]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(7),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(7)
    );
\result_reg[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(7),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(7),
      O => float32ToInteger(7)
    );
\result_reg[7]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0A80888002000000"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(27),
      I2 => a_IBUF(25),
      I3 => a_IBUF(24),
      I4 => a_IBUF(23),
      I5 => a_IBUF(4),
      O => \result_reg[7]_i_10_n_0\
    );
\result_reg[7]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[0]_i_1_n_0\,
      CO(3) => \result_reg[7]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[7]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => float32ToInteger20_in(7 downto 4),
      O(3 downto 0) => \float32ToInteger1__0\(7 downto 4),
      S(3) => \result_reg[7]_i_7_n_0\,
      S(2) => \result_reg[7]_i_8_n_0\,
      S(1) => \result_reg[7]_i_9_n_0\,
      S(0) => \result_reg[7]_i_10_n_0\
    );
\result_reg[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00400000"
    )
        port map (
      I0 => a_IBUF(23),
      I1 => a_IBUF(24),
      I2 => a_IBUF(25),
      I3 => a_IBUF(27),
      I4 => \result_reg[0]_i_10_n_0\,
      O => float32ToInteger20_in(7)
    );
\result_reg[7]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00400000"
    )
        port map (
      I0 => a_IBUF(24),
      I1 => a_IBUF(23),
      I2 => a_IBUF(25),
      I3 => a_IBUF(27),
      I4 => \result_reg[0]_i_10_n_0\,
      O => float32ToInteger20_in(6)
    );
\result_reg[7]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00020000"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => a_IBUF(27),
      I4 => \result_reg[0]_i_10_n_0\,
      O => float32ToInteger20_in(5)
    );
\result_reg[7]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00400000"
    )
        port map (
      I0 => a_IBUF(25),
      I1 => a_IBUF(23),
      I2 => a_IBUF(24),
      I3 => a_IBUF(27),
      I4 => \result_reg[0]_i_10_n_0\,
      O => float32ToInteger20_in(4)
    );
\result_reg[7]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0C030009AAA3000"
    )
        port map (
      I0 => \result_reg[15]_i_11_n_0\,
      I1 => \result_reg[0]_i_11_n_0\,
      I2 => a_IBUF(7),
      I3 => \result_reg[23]_i_14_n_0\,
      I4 => \result_reg[0]_i_10_n_0\,
      I5 => a_IBUF(27),
      O => \result_reg[7]_i_7_n_0\
    );
\result_reg[7]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00808080B0808080"
    )
        port map (
      I0 => a_IBUF(6),
      I1 => a_IBUF(27),
      I2 => \result_reg[0]_i_10_n_0\,
      I3 => a_IBUF(25),
      I4 => a_IBUF(23),
      I5 => a_IBUF(24),
      O => \result_reg[7]_i_8_n_0\
    );
\result_reg[7]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"088888A000000020"
    )
        port map (
      I0 => \result_reg[0]_i_10_n_0\,
      I1 => a_IBUF(27),
      I2 => a_IBUF(25),
      I3 => a_IBUF(24),
      I4 => a_IBUF(23),
      I5 => a_IBUF(5),
      O => \result_reg[7]_i_9_n_0\
    );
\result_reg[8]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(8),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(8)
    );
\result_reg[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(8),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(8),
      O => float32ToInteger(8)
    );
\result_reg[8]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \result_reg[4]_i_2_n_0\,
      CO(3) => \result_reg[8]_i_2_n_0\,
      CO(2 downto 0) => \NLW_result_reg[8]_i_2_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => float32ToInteger0(8 downto 5),
      S(3) => \result_reg[8]_i_3_n_0\,
      S(2) => \result_reg[8]_i_4_n_0\,
      S(1) => \result_reg[8]_i_5_n_0\,
      S(0) => \result_reg[8]_i_6_n_0\
    );
\result_reg[8]_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(8),
      O => \result_reg[8]_i_3_n_0\
    );
\result_reg[8]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(7),
      O => \result_reg[8]_i_4_n_0\
    );
\result_reg[8]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(6),
      O => \result_reg[8]_i_5_n_0\
    );
\result_reg[8]_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \float32ToInteger1__0\(5),
      O => \result_reg[8]_i_6_n_0\
    );
\result_reg[9]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => float32ToInteger(9),
      G => ena_IBUF_BUFG,
      GE => '1',
      Q => result_OBUF(9)
    );
\result_reg[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => float32ToInteger0(9),
      I1 => a_IBUF(31),
      I2 => \float32ToInteger1__0\(9),
      O => float32ToInteger(9)
    );
end STRUCTURE;
