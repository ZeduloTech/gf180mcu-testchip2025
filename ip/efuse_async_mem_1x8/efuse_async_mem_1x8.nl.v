module efuse_async_mem_1x8 (ready,
    reset_n,
    out,
    prog);
 output ready;
 input reset_n;
 output [7:0] out;
 input [7:0] prog;

 wire \col_prog_n[0] ;
 wire \col_prog_n[1] ;
 wire \col_prog_n[2] ;
 wire \col_prog_n[3] ;
 wire \col_prog_n[4] ;
 wire \col_prog_n[5] ;
 wire \col_prog_n[6] ;
 wire \col_prog_n[7] ;
 wire \out_prebuf[0] ;
 wire \out_prebuf[1] ;
 wire \out_prebuf[2] ;
 wire \out_prebuf[3] ;
 wire \out_prebuf[4] ;
 wire \out_prebuf[5] ;
 wire \out_prebuf[6] ;
 wire \out_prebuf[7] ;
 wire preset_n;
 wire net1;
 wire reset;
 wire \reset_del[0] ;
 wire \reset_del[1] ;
 wire \reset_del[2] ;
 wire \reset_n_del[0] ;
 wire \reset_n_del[1] ;
 wire sense;
 wire sense_predel;
 wire net2;

 gf180mcu_fd_sc_mcu7t5v0__nor2_4 _0_ (.A1(net2),
    .A2(sense),
    .ZN(net1));
 gf180mcu_fd_sc_mcu7t5v0__and2_2 and_sense_cell (.A1(\reset_n_del[1] ),
    .A2(\reset_del[2] ),
    .Z(sense_predel));
 gf180mcu_fd_sc_mcu7t5v0__dlyd_4 del_res0_cell (.I(\reset_del[0] ),
    .Z(\reset_del[1] ));
 gf180mcu_fd_sc_mcu7t5v0__dlyd_4 del_res1_cell (.I(\reset_del[1] ),
    .Z(\reset_del[2] ));
 gf180mcu_fd_sc_mcu7t5v0__dlyd_4 del_resn0_cell (.I(reset_n),
    .Z(\reset_n_del[0] ));
 gf180mcu_fd_sc_mcu7t5v0__dlyd_4 del_resn1_cell (.I(\reset_n_del[0] ),
    .Z(\reset_n_del[1] ));
 gf180mcu_fd_sc_mcu7t5v0__dlyd_4 del_sense_cell (.I(sense_predel),
    .Z(sense));
 efuse_array_async_1x8 efuse_array (.PRESET_N(preset_n),
    .SENSE(sense),
    .COL_PROG_N({\col_prog_n[7] ,
    \col_prog_n[6] ,
    \col_prog_n[5] ,
    \col_prog_n[4] ,
    \col_prog_n[3] ,
    \col_prog_n[2] ,
    \col_prog_n[1] ,
    \col_prog_n[0] }),
    .OUT({\out_prebuf[7] ,
    \out_prebuf[6] ,
    \out_prebuf[5] ,
    \out_prebuf[4] ,
    \out_prebuf[3] ,
    \out_prebuf[2] ,
    \out_prebuf[1] ,
    \out_prebuf[0] }));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[0].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[0]),
    .ZN(\col_prog_n[0] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[0].out_buf_cell  (.I(\out_prebuf[0] ),
    .Z(out[0]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[1].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[1]),
    .ZN(\col_prog_n[1] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[1].out_buf_cell  (.I(\out_prebuf[1] ),
    .Z(out[1]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[2].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[2]),
    .ZN(\col_prog_n[2] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[2].out_buf_cell  (.I(\out_prebuf[2] ),
    .Z(out[2]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[3].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[3]),
    .ZN(\col_prog_n[3] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[3].out_buf_cell  (.I(\out_prebuf[3] ),
    .Z(out[3]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[4].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[4]),
    .ZN(\col_prog_n[4] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[4].out_buf_cell  (.I(\out_prebuf[4] ),
    .Z(out[4]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[5].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[5]),
    .ZN(\col_prog_n[5] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[5].out_buf_cell  (.I(\out_prebuf[5] ),
    .Z(out[5]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[6].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[6]),
    .ZN(\col_prog_n[6] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[6].out_buf_cell  (.I(\out_prebuf[6] ),
    .Z(out[6]));
 gf180mcu_fd_sc_mcu7t5v0__nand2_2 \genblk1[7].nand_wrinhibit_cell  (.A1(reset_n),
    .A2(prog[7]),
    .ZN(\col_prog_n[7] ));
 gf180mcu_fd_sc_mcu7t5v0__buf_4 \genblk1[7].out_buf_cell  (.I(\out_prebuf[7] ),
    .Z(out[7]));
 gf180mcu_fd_sc_mcu7t5v0__inv_2 inv_res_cell (.I(reset_n),
    .ZN(reset));
 gf180mcu_fd_sc_mcu7t5v0__inv_2 inv_resnd_cell (.I(\reset_n_del[1] ),
    .ZN(\reset_del[0] ));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 or_preset_cell (.A1(reset),
    .A2(\reset_n_del[1] ),
    .Z(preset_n));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_2_Right_0 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_2_Right_1 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_2_Right_2 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_2_Right_3 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_2_Right_4 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_2_Right_5 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_2_Right_6 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_2_Right_7 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_2_Right_8 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_2_Right_9 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_2_Right_10 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_12_2_Right_11 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_13_2_Right_12 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_14_2_Right_13 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_2_Right_14 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_2_Left_15 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_2_Left_16 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_2_Left_17 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_2_Left_18 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_2_Left_19 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_2_Left_20 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_2_Left_21 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_2_Left_22 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_2_Left_23 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_2_Left_24 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_2_Left_25 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_12_2_Left_26 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_13_2_Left_27 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_14_2_Left_28 ();
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_2_Left_29 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_2_30 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_2_31 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_2_32 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_2_33 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_2_34 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_2_35 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_2_36 ();
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_2_37 ();
 gf180mcu_fd_sc_mcu7t5v0__buf_8 output1 (.I(net1),
    .Z(ready));
 gf180mcu_fd_sc_mcu7t5v0__buf_2 rebuffer2 (.I(\reset_del[2] ),
    .Z(net2));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[0].nand_wrinhibit_cell_A2  (.I(prog[0]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[1].nand_wrinhibit_cell_A2  (.I(prog[1]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[2].nand_wrinhibit_cell_A2  (.I(prog[2]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[3].nand_wrinhibit_cell_A2  (.I(prog[3]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[4].nand_wrinhibit_cell_A2  (.I(prog[4]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[5].nand_wrinhibit_cell_A2  (.I(prog[5]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[6].nand_wrinhibit_cell_A2  (.I(prog[6]));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[7].nand_wrinhibit_cell_A2  (.I(prog[7]));
 gf180mcu_fd_sc_mcu7t5v0__antenna ANTENNA_inv_res_cell_I (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[7].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[6].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[5].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[4].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[3].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[2].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[1].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_genblk1[0].nand_wrinhibit_cell_A1  (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__antenna ANTENNA_del_resn0_cell_I (.I(reset_n));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_0_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_0_91 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_0_121 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_1_127 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_2_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_2_91 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_2_116 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_3_93 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_4_130 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_134 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_5_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_91 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_5_132 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_134 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_6_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_91 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_7_129 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_8_97 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_8_105 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_8_109 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_10_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_10_91 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_10_93 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_10_108 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_10_116 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_11_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_11_103 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_11_111 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_11_115 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_11_117 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_11_132 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_11_134 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_12_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_12_119 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_13_101 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_13_117 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_13_132 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_13_134 ();
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_14_87 ();
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_14_134 ();
endmodule
