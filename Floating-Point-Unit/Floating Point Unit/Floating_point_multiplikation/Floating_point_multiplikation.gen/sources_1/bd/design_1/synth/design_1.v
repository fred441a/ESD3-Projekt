//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
//Date        : Wed May  3 09:23:07 2023
//Host        : LAPTOP-U9E9QN8R running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (aclk_0,
    m_axis_result_tdata_0,
    s_axis_a_tdata_0,
    s_axis_b_tdata_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK_0, CLK_DOMAIN design_1_aclk_0, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input aclk_0;
  output [31:0]m_axis_result_tdata_0;
  input [31:0]s_axis_a_tdata_0;
  input [31:0]s_axis_b_tdata_0;

  wire aclk_0_1;
  wire [31:0]floating_point_0_m_axis_result_tdata;
  wire [31:0]s_axis_a_tdata_0_1;
  wire [31:0]s_axis_b_tdata_0_1;

  assign aclk_0_1 = aclk_0;
  assign m_axis_result_tdata_0[31:0] = floating_point_0_m_axis_result_tdata;
  assign s_axis_a_tdata_0_1 = s_axis_a_tdata_0[31:0];
  assign s_axis_b_tdata_0_1 = s_axis_b_tdata_0[31:0];
  design_1_floating_point_0_0 floating_point_0
       (.aclk(aclk_0_1),
        .m_axis_result_tdata(floating_point_0_m_axis_result_tdata),
        .m_axis_result_tready(1'b1),
        .s_axis_a_tdata(s_axis_a_tdata_0_1),
        .s_axis_a_tvalid(1'b0),
        .s_axis_b_tdata(s_axis_b_tdata_0_1),
        .s_axis_b_tvalid(1'b0));
endmodule
