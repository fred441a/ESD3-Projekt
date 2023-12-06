//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Wed May  3 09:23:07 2023
//Host        : LAPTOP-U9E9QN8R running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (aclk_0,
    m_axis_result_tdata_0,
    s_axis_a_tdata_0,
    s_axis_b_tdata_0);
  input aclk_0;
  output [31:0]m_axis_result_tdata_0;
  input [31:0]s_axis_a_tdata_0;
  input [31:0]s_axis_b_tdata_0;

  wire aclk_0;
  wire [31:0]m_axis_result_tdata_0;
  wire [31:0]s_axis_a_tdata_0;
  wire [31:0]s_axis_b_tdata_0;

  design_1 design_1_i
       (.aclk_0(aclk_0),
        .m_axis_result_tdata_0(m_axis_result_tdata_0),
        .s_axis_a_tdata_0(s_axis_a_tdata_0),
        .s_axis_b_tdata_0(s_axis_b_tdata_0));
endmodule
