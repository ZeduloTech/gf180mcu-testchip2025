module ring_osc2x13 (reset,
    VDD,
    VSS,
    clockp,
    trim);
 input reset;
 inout VDD;
 inout VSS;
 output [1:0] clockp;
 input [25:0] trim;

 wire \c[0] ;
 wire \c[1] ;
 wire \dstage[10].id.d0 ;
 wire \dstage[10].id.d1 ;
 wire \dstage[10].id.d2 ;
 wire \dstage[10].id.in ;
 wire \dstage[10].id.lddtrim[0] ;
 wire \dstage[10].id.lddtrim[1] ;
 wire \dstage[10].id.ldotrim[0] ;
 wire \dstage[10].id.ldotrim[1] ;
 wire \dstage[10].id.ldtrim[0] ;
 wire \dstage[10].id.ldtrim[1] ;
 wire \dstage[10].id.ltrim[0] ;
 wire \dstage[10].id.ltrim[1] ;
 wire \dstage[10].id.ltrimb[0] ;
 wire \dstage[10].id.ltrimb[1] ;
 wire \dstage[10].id.ltrimbd[0] ;
 wire \dstage[10].id.ltrimbd[1] ;
 wire \dstage[10].id.ltrimbdd[0] ;
 wire \dstage[10].id.ltrimbdd[1] ;
 wire \dstage[10].id.not_edge ;
 wire \dstage[10].id.nreset ;
 wire \dstage[10].id.out ;
 wire \dstage[10].id.out_del ;
 wire \dstage[10].id.prev_in ;
 wire \dstage[10].id.ts ;
 wire \dstage[11].id.d0 ;
 wire \dstage[11].id.d1 ;
 wire \dstage[11].id.d2 ;
 wire \dstage[11].id.lddtrim[0] ;
 wire \dstage[11].id.lddtrim[1] ;
 wire \dstage[11].id.ldotrim[0] ;
 wire \dstage[11].id.ldotrim[1] ;
 wire \dstage[11].id.ldtrim[0] ;
 wire \dstage[11].id.ldtrim[1] ;
 wire \dstage[11].id.ltrim[0] ;
 wire \dstage[11].id.ltrim[1] ;
 wire \dstage[11].id.ltrimb[0] ;
 wire \dstage[11].id.ltrimb[1] ;
 wire \dstage[11].id.ltrimbd[0] ;
 wire \dstage[11].id.ltrimbd[1] ;
 wire \dstage[11].id.ltrimbdd[0] ;
 wire \dstage[11].id.ltrimbdd[1] ;
 wire \dstage[11].id.not_edge ;
 wire \dstage[11].id.out ;
 wire \dstage[11].id.out_del ;
 wire \dstage[11].id.prev_in ;
 wire \dstage[11].id.ts ;
 wire \dstage[2].id.d0 ;
 wire \dstage[2].id.d1 ;
 wire \dstage[2].id.d2 ;
 wire \dstage[2].id.in ;
 wire \dstage[2].id.lddtrim[0] ;
 wire \dstage[2].id.lddtrim[1] ;
 wire \dstage[2].id.ldotrim[0] ;
 wire \dstage[2].id.ldotrim[1] ;
 wire \dstage[2].id.ldtrim[0] ;
 wire \dstage[2].id.ldtrim[1] ;
 wire \dstage[2].id.ltrim[0] ;
 wire \dstage[2].id.ltrim[1] ;
 wire \dstage[2].id.ltrimb[0] ;
 wire \dstage[2].id.ltrimb[1] ;
 wire \dstage[2].id.ltrimbd[0] ;
 wire \dstage[2].id.ltrimbd[1] ;
 wire \dstage[2].id.ltrimbdd[0] ;
 wire \dstage[2].id.ltrimbdd[1] ;
 wire \dstage[2].id.not_edge ;
 wire \dstage[2].id.out ;
 wire \dstage[2].id.out_del ;
 wire \dstage[2].id.prev_in ;
 wire \dstage[2].id.ts ;
 wire \dstage[3].id.d0 ;
 wire \dstage[3].id.d1 ;
 wire \dstage[3].id.d2 ;
 wire \dstage[3].id.lddtrim[0] ;
 wire \dstage[3].id.lddtrim[1] ;
 wire \dstage[3].id.ldotrim[0] ;
 wire \dstage[3].id.ldotrim[1] ;
 wire \dstage[3].id.ldtrim[0] ;
 wire \dstage[3].id.ldtrim[1] ;
 wire \dstage[3].id.ltrim[0] ;
 wire \dstage[3].id.ltrim[1] ;
 wire \dstage[3].id.ltrimb[0] ;
 wire \dstage[3].id.ltrimb[1] ;
 wire \dstage[3].id.ltrimbd[0] ;
 wire \dstage[3].id.ltrimbd[1] ;
 wire \dstage[3].id.ltrimbdd[0] ;
 wire \dstage[3].id.ltrimbdd[1] ;
 wire \dstage[3].id.not_edge ;
 wire \dstage[3].id.out ;
 wire \dstage[3].id.out_del ;
 wire \dstage[3].id.prev_in ;
 wire \dstage[3].id.ts ;
 wire \dstage[4].id.d0 ;
 wire \dstage[4].id.d1 ;
 wire \dstage[4].id.d2 ;
 wire \dstage[4].id.lddtrim[0] ;
 wire \dstage[4].id.lddtrim[1] ;
 wire \dstage[4].id.ldotrim[0] ;
 wire \dstage[4].id.ldotrim[1] ;
 wire \dstage[4].id.ldtrim[0] ;
 wire \dstage[4].id.ldtrim[1] ;
 wire \dstage[4].id.ltrim[0] ;
 wire \dstage[4].id.ltrim[1] ;
 wire \dstage[4].id.ltrimb[0] ;
 wire \dstage[4].id.ltrimb[1] ;
 wire \dstage[4].id.ltrimbd[0] ;
 wire \dstage[4].id.ltrimbd[1] ;
 wire \dstage[4].id.ltrimbdd[0] ;
 wire \dstage[4].id.ltrimbdd[1] ;
 wire \dstage[4].id.not_edge ;
 wire \dstage[4].id.out ;
 wire \dstage[4].id.out_del ;
 wire \dstage[4].id.ts ;
 wire \dstage[5].id.d0 ;
 wire \dstage[5].id.d1 ;
 wire \dstage[5].id.d2 ;
 wire \dstage[5].id.lddtrim[0] ;
 wire \dstage[5].id.lddtrim[1] ;
 wire \dstage[5].id.ldotrim[0] ;
 wire \dstage[5].id.ldotrim[1] ;
 wire \dstage[5].id.ldtrim[0] ;
 wire \dstage[5].id.ldtrim[1] ;
 wire \dstage[5].id.ltrim[0] ;
 wire \dstage[5].id.ltrim[1] ;
 wire \dstage[5].id.ltrimb[0] ;
 wire \dstage[5].id.ltrimb[1] ;
 wire \dstage[5].id.ltrimbd[0] ;
 wire \dstage[5].id.ltrimbd[1] ;
 wire \dstage[5].id.ltrimbdd[0] ;
 wire \dstage[5].id.ltrimbdd[1] ;
 wire \dstage[5].id.not_edge ;
 wire \dstage[5].id.out ;
 wire \dstage[5].id.out_del ;
 wire \dstage[5].id.ts ;
 wire \dstage[6].id.d0 ;
 wire \dstage[6].id.d1 ;
 wire \dstage[6].id.d2 ;
 wire \dstage[6].id.lddtrim[0] ;
 wire \dstage[6].id.lddtrim[1] ;
 wire \dstage[6].id.ldotrim[0] ;
 wire \dstage[6].id.ldotrim[1] ;
 wire \dstage[6].id.ldtrim[0] ;
 wire \dstage[6].id.ldtrim[1] ;
 wire \dstage[6].id.ltrim[0] ;
 wire \dstage[6].id.ltrim[1] ;
 wire \dstage[6].id.ltrimb[0] ;
 wire \dstage[6].id.ltrimb[1] ;
 wire \dstage[6].id.ltrimbd[0] ;
 wire \dstage[6].id.ltrimbd[1] ;
 wire \dstage[6].id.ltrimbdd[0] ;
 wire \dstage[6].id.ltrimbdd[1] ;
 wire \dstage[6].id.not_edge ;
 wire \dstage[6].id.out ;
 wire \dstage[6].id.out_del ;
 wire \dstage[6].id.ts ;
 wire \dstage[7].id.d0 ;
 wire \dstage[7].id.d1 ;
 wire \dstage[7].id.d2 ;
 wire \dstage[7].id.lddtrim[0] ;
 wire \dstage[7].id.lddtrim[1] ;
 wire \dstage[7].id.ldotrim[0] ;
 wire \dstage[7].id.ldotrim[1] ;
 wire \dstage[7].id.ldtrim[0] ;
 wire \dstage[7].id.ldtrim[1] ;
 wire \dstage[7].id.ltrim[0] ;
 wire \dstage[7].id.ltrim[1] ;
 wire \dstage[7].id.ltrimb[0] ;
 wire \dstage[7].id.ltrimb[1] ;
 wire \dstage[7].id.ltrimbd[0] ;
 wire \dstage[7].id.ltrimbd[1] ;
 wire \dstage[7].id.ltrimbdd[0] ;
 wire \dstage[7].id.ltrimbdd[1] ;
 wire \dstage[7].id.not_edge ;
 wire \dstage[7].id.out_del ;
 wire \dstage[7].id.ts ;
 wire \dstage[8].id.d0 ;
 wire \dstage[8].id.d1 ;
 wire \dstage[8].id.d2 ;
 wire \dstage[8].id.lddtrim[0] ;
 wire \dstage[8].id.lddtrim[1] ;
 wire \dstage[8].id.ldotrim[0] ;
 wire \dstage[8].id.ldotrim[1] ;
 wire \dstage[8].id.ldtrim[0] ;
 wire \dstage[8].id.ldtrim[1] ;
 wire \dstage[8].id.ltrim[0] ;
 wire \dstage[8].id.ltrim[1] ;
 wire \dstage[8].id.ltrimb[0] ;
 wire \dstage[8].id.ltrimb[1] ;
 wire \dstage[8].id.ltrimbd[0] ;
 wire \dstage[8].id.ltrimbd[1] ;
 wire \dstage[8].id.ltrimbdd[0] ;
 wire \dstage[8].id.ltrimbdd[1] ;
 wire \dstage[8].id.not_edge ;
 wire \dstage[8].id.out_del ;
 wire \dstage[8].id.ts ;
 wire \dstage[9].id.d0 ;
 wire \dstage[9].id.d1 ;
 wire \dstage[9].id.d2 ;
 wire \dstage[9].id.lddtrim[0] ;
 wire \dstage[9].id.lddtrim[1] ;
 wire \dstage[9].id.ldotrim[0] ;
 wire \dstage[9].id.ldotrim[1] ;
 wire \dstage[9].id.ldtrim[0] ;
 wire \dstage[9].id.ldtrim[1] ;
 wire \dstage[9].id.ltrim[0] ;
 wire \dstage[9].id.ltrim[1] ;
 wire \dstage[9].id.ltrimb[0] ;
 wire \dstage[9].id.ltrimb[1] ;
 wire \dstage[9].id.ltrimbd[0] ;
 wire \dstage[9].id.ltrimbd[1] ;
 wire \dstage[9].id.ltrimbdd[0] ;
 wire \dstage[9].id.ltrimbdd[1] ;
 wire \dstage[9].id.not_edge ;
 wire \dstage[9].id.out_del ;
 wire \dstage[9].id.ts ;
 wire \id0.d0 ;
 wire \id0.d1 ;
 wire \id0.d2 ;
 wire \id0.lddtrim[0] ;
 wire \id0.lddtrim[1] ;
 wire \id0.ldotrim[0] ;
 wire \id0.ldotrim[1] ;
 wire \id0.ldtrim[0] ;
 wire \id0.ldtrim[1] ;
 wire \id0.ltrim[0] ;
 wire \id0.ltrim[1] ;
 wire \id0.ltrimb[0] ;
 wire \id0.ltrimb[1] ;
 wire \id0.ltrimbd[0] ;
 wire \id0.ltrimbd[1] ;
 wire \id0.ltrimbdd[0] ;
 wire \id0.ltrimbdd[1] ;
 wire \id0.not_edge ;
 wire \id0.out_del ;
 wire \id0.ts ;
 wire \id1.d0 ;
 wire \id1.d1 ;
 wire \id1.d2 ;
 wire \id1.lddtrim[0] ;
 wire \id1.lddtrim[1] ;
 wire \id1.ldotrim[0] ;
 wire \id1.ldotrim[1] ;
 wire \id1.ldtrim[0] ;
 wire \id1.ldtrim[1] ;
 wire \id1.ltrim[0] ;
 wire \id1.ltrim[1] ;
 wire \id1.ltrimb[0] ;
 wire \id1.ltrimb[1] ;
 wire \id1.ltrimbd[0] ;
 wire \id1.ltrimbd[1] ;
 wire \id1.ltrimbdd[0] ;
 wire \id1.ltrimbdd[1] ;
 wire \id1.not_edge ;
 wire \id1.out_del ;
 wire \id1.ts ;
 wire \iss.ctrl0b ;
 wire \iss.d0 ;
 wire \iss.d1 ;
 wire \iss.d2 ;
 wire \iss.ltrim[0] ;
 wire \iss.ltrim[1] ;
 wire \iss.not_edge ;
 wire \iss.nreset_del ;
 wire \iss.out_del ;
 wire \iss.out_precg ;
 wire \iss.trim1b ;
 wire net;

 gf180mcu_fd_sc_mcu7t5v0__clkinv_1 _0_ (.I(reset),
    .ZN(\dstage[10].id.nreset ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[10].id.deglitch_buf  (.I(\dstage[10].id.out ),
    .Z(\dstage[10].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[10].id.delaybuf0  (.I(\dstage[10].id.in ),
    .Z(\dstage[10].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.delaybuf1  (.I(\dstage[10].id.ts ),
    .Z(\dstage[10].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[10].id.delayen0  (.EN(\dstage[10].id.ldotrim[0] ),
    .I(\dstage[10].id.d2 ),
    .ZN(\dstage[10].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[10].id.delayen1  (.EN(\dstage[10].id.ldotrim[1] ),
    .I(\dstage[10].id.d0 ),
    .ZN(\dstage[10].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[10].id.delayenb0  (.EN(\dstage[10].id.ltrimbdd[0] ),
    .I(\dstage[10].id.ts ),
    .ZN(\dstage[10].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[10].id.delayenb1  (.EN(\dstage[10].id.ltrimbdd[1] ),
    .I(\dstage[10].id.ts ),
    .ZN(\dstage[10].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[10].id.delayint0  (.I(\dstage[10].id.d1 ),
    .ZN(\dstage[10].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[10].id.t0_latch  (.D(trim[10]),
    .E(\dstage[10].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[10].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.t0l_delay  (.I(\dstage[10].id.ltrim[0] ),
    .Z(\dstage[10].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.t0l_delay2  (.I(\dstage[10].id.ldtrim[0] ),
    .Z(\dstage[10].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[10].id.t0ld_or  (.A1(\dstage[10].id.lddtrim[0] ),
    .A2(\dstage[10].id.ltrim[0] ),
    .Z(\dstage[10].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[10].id.t1_latch  (.D(trim[23]),
    .E(\dstage[10].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[10].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.t1l_delay  (.I(\dstage[10].id.ltrim[1] ),
    .Z(\dstage[10].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.t1l_delay2  (.I(\dstage[10].id.ldtrim[1] ),
    .Z(\dstage[10].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[10].id.t1ld_or  (.A1(\dstage[10].id.lddtrim[1] ),
    .A2(\dstage[10].id.ltrim[1] ),
    .Z(\dstage[10].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[10].id.trim0bar  (.I(\dstage[10].id.ltrim[0] ),
    .ZN(\dstage[10].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.trim0bar_del0  (.I(\dstage[10].id.ltrimb[0] ),
    .Z(\dstage[10].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.trim0bar_del1  (.I(\dstage[10].id.ltrimbd[0] ),
    .Z(\dstage[10].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[10].id.trim1bar  (.I(\dstage[10].id.ltrim[1] ),
    .ZN(\dstage[10].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.trim1bar_del0  (.I(\dstage[10].id.ltrimb[1] ),
    .Z(\dstage[10].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[10].id.trim1bar_del1  (.I(\dstage[10].id.ltrimbd[1] ),
    .Z(\dstage[10].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[10].id.trim_inhibit  (.A1(\dstage[10].id.prev_in ),
    .A2(\dstage[10].id.out_del ),
    .Z(\dstage[10].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[11].id.deglitch_buf  (.I(\dstage[11].id.out ),
    .Z(\dstage[11].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[11].id.delaybuf0  (.I(\dstage[10].id.out ),
    .Z(\dstage[11].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.delaybuf1  (.I(\dstage[11].id.ts ),
    .Z(\dstage[11].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[11].id.delayen0  (.EN(\dstage[11].id.ldotrim[0] ),
    .I(\dstage[11].id.d2 ),
    .ZN(\dstage[11].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[11].id.delayen1  (.EN(\dstage[11].id.ldotrim[1] ),
    .I(\dstage[11].id.d0 ),
    .ZN(\dstage[11].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[11].id.delayenb0  (.EN(\dstage[11].id.ltrimbdd[0] ),
    .I(\dstage[11].id.ts ),
    .ZN(\dstage[11].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[11].id.delayenb1  (.EN(\dstage[11].id.ltrimbdd[1] ),
    .I(\dstage[11].id.ts ),
    .ZN(\dstage[11].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[11].id.delayint0  (.I(\dstage[11].id.d1 ),
    .ZN(\dstage[11].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[11].id.t0_latch  (.D(trim[11]),
    .E(\dstage[11].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[11].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.t0l_delay  (.I(\dstage[11].id.ltrim[0] ),
    .Z(\dstage[11].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.t0l_delay2  (.I(\dstage[11].id.ldtrim[0] ),
    .Z(\dstage[11].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[11].id.t0ld_or  (.A1(\dstage[11].id.lddtrim[0] ),
    .A2(\dstage[11].id.ltrim[0] ),
    .Z(\dstage[11].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[11].id.t1_latch  (.D(trim[24]),
    .E(\dstage[11].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[11].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.t1l_delay  (.I(\dstage[11].id.ltrim[1] ),
    .Z(\dstage[11].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.t1l_delay2  (.I(\dstage[11].id.ldtrim[1] ),
    .Z(\dstage[11].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[11].id.t1ld_or  (.A1(\dstage[11].id.lddtrim[1] ),
    .A2(\dstage[11].id.ltrim[1] ),
    .Z(\dstage[11].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[11].id.trim0bar  (.I(\dstage[11].id.ltrim[0] ),
    .ZN(\dstage[11].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.trim0bar_del0  (.I(\dstage[11].id.ltrimb[0] ),
    .Z(\dstage[11].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.trim0bar_del1  (.I(\dstage[11].id.ltrimbd[0] ),
    .Z(\dstage[11].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[11].id.trim1bar  (.I(\dstage[11].id.ltrim[1] ),
    .ZN(\dstage[11].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.trim1bar_del0  (.I(\dstage[11].id.ltrimb[1] ),
    .Z(\dstage[11].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[11].id.trim1bar_del1  (.I(\dstage[11].id.ltrimbd[1] ),
    .Z(\dstage[11].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[11].id.trim_inhibit  (.A1(\dstage[11].id.prev_in ),
    .A2(\dstage[11].id.out_del ),
    .Z(\dstage[11].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[2].id.deglitch_buf  (.I(\dstage[2].id.out ),
    .Z(\dstage[2].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[2].id.delaybuf0  (.I(\dstage[2].id.in ),
    .Z(\dstage[2].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.delaybuf1  (.I(\dstage[2].id.ts ),
    .Z(\dstage[2].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[2].id.delayen0  (.EN(\dstage[2].id.ldotrim[0] ),
    .I(\dstage[2].id.d2 ),
    .ZN(\dstage[2].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[2].id.delayen1  (.EN(\dstage[2].id.ldotrim[1] ),
    .I(\dstage[2].id.d0 ),
    .ZN(\dstage[2].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[2].id.delayenb0  (.EN(\dstage[2].id.ltrimbdd[0] ),
    .I(\dstage[2].id.ts ),
    .ZN(\dstage[2].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[2].id.delayenb1  (.EN(\dstage[2].id.ltrimbdd[1] ),
    .I(\dstage[2].id.ts ),
    .ZN(\dstage[2].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[2].id.delayint0  (.I(\dstage[2].id.d1 ),
    .ZN(\dstage[2].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[2].id.t0_latch  (.D(trim[2]),
    .E(\dstage[2].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[2].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.t0l_delay  (.I(\dstage[2].id.ltrim[0] ),
    .Z(\dstage[2].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.t0l_delay2  (.I(\dstage[2].id.ldtrim[0] ),
    .Z(\dstage[2].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[2].id.t0ld_or  (.A1(\dstage[2].id.lddtrim[0] ),
    .A2(\dstage[2].id.ltrim[0] ),
    .Z(\dstage[2].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[2].id.t1_latch  (.D(trim[15]),
    .E(\dstage[2].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[2].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.t1l_delay  (.I(\dstage[2].id.ltrim[1] ),
    .Z(\dstage[2].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.t1l_delay2  (.I(\dstage[2].id.ldtrim[1] ),
    .Z(\dstage[2].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[2].id.t1ld_or  (.A1(\dstage[2].id.lddtrim[1] ),
    .A2(\dstage[2].id.ltrim[1] ),
    .Z(\dstage[2].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[2].id.trim0bar  (.I(\dstage[2].id.ltrim[0] ),
    .ZN(\dstage[2].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.trim0bar_del0  (.I(\dstage[2].id.ltrimb[0] ),
    .Z(\dstage[2].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.trim0bar_del1  (.I(\dstage[2].id.ltrimbd[0] ),
    .Z(\dstage[2].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[2].id.trim1bar  (.I(\dstage[2].id.ltrim[1] ),
    .ZN(\dstage[2].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.trim1bar_del0  (.I(\dstage[2].id.ltrimb[1] ),
    .Z(\dstage[2].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[2].id.trim1bar_del1  (.I(\dstage[2].id.ltrimbd[1] ),
    .Z(\dstage[2].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[2].id.trim_inhibit  (.A1(\dstage[2].id.prev_in ),
    .A2(\dstage[2].id.out_del ),
    .Z(\dstage[2].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[3].id.deglitch_buf  (.I(\dstage[3].id.out ),
    .Z(\dstage[3].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[3].id.delaybuf0  (.I(\dstage[2].id.out ),
    .Z(\dstage[3].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.delaybuf1  (.I(\dstage[3].id.ts ),
    .Z(\dstage[3].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[3].id.delayen0  (.EN(\dstage[3].id.ldotrim[0] ),
    .I(\dstage[3].id.d2 ),
    .ZN(\dstage[3].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[3].id.delayen1  (.EN(\dstage[3].id.ldotrim[1] ),
    .I(\dstage[3].id.d0 ),
    .ZN(\dstage[3].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[3].id.delayenb0  (.EN(\dstage[3].id.ltrimbdd[0] ),
    .I(\dstage[3].id.ts ),
    .ZN(\dstage[3].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[3].id.delayenb1  (.EN(\dstage[3].id.ltrimbdd[1] ),
    .I(\dstage[3].id.ts ),
    .ZN(\dstage[3].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[3].id.delayint0  (.I(\dstage[3].id.d1 ),
    .ZN(\dstage[3].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[3].id.t0_latch  (.D(trim[3]),
    .E(\dstage[3].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[3].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.t0l_delay  (.I(\dstage[3].id.ltrim[0] ),
    .Z(\dstage[3].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.t0l_delay2  (.I(\dstage[3].id.ldtrim[0] ),
    .Z(\dstage[3].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[3].id.t0ld_or  (.A1(\dstage[3].id.lddtrim[0] ),
    .A2(\dstage[3].id.ltrim[0] ),
    .Z(\dstage[3].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[3].id.t1_latch  (.D(trim[16]),
    .E(\dstage[3].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[3].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.t1l_delay  (.I(\dstage[3].id.ltrim[1] ),
    .Z(\dstage[3].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.t1l_delay2  (.I(\dstage[3].id.ldtrim[1] ),
    .Z(\dstage[3].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[3].id.t1ld_or  (.A1(\dstage[3].id.lddtrim[1] ),
    .A2(\dstage[3].id.ltrim[1] ),
    .Z(\dstage[3].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[3].id.trim0bar  (.I(\dstage[3].id.ltrim[0] ),
    .ZN(\dstage[3].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.trim0bar_del0  (.I(\dstage[3].id.ltrimb[0] ),
    .Z(\dstage[3].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.trim0bar_del1  (.I(\dstage[3].id.ltrimbd[0] ),
    .Z(\dstage[3].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[3].id.trim1bar  (.I(\dstage[3].id.ltrim[1] ),
    .ZN(\dstage[3].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.trim1bar_del0  (.I(\dstage[3].id.ltrimb[1] ),
    .Z(\dstage[3].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[3].id.trim1bar_del1  (.I(\dstage[3].id.ltrimbd[1] ),
    .Z(\dstage[3].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[3].id.trim_inhibit  (.A1(\dstage[3].id.prev_in ),
    .A2(\dstage[3].id.out_del ),
    .Z(\dstage[3].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[4].id.deglitch_buf  (.I(\dstage[4].id.out ),
    .Z(\dstage[4].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[4].id.delaybuf0  (.I(\dstage[3].id.out ),
    .Z(\dstage[4].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.delaybuf1  (.I(\dstage[4].id.ts ),
    .Z(\dstage[4].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[4].id.delayen0  (.EN(\dstage[4].id.ldotrim[0] ),
    .I(\dstage[4].id.d2 ),
    .ZN(\dstage[4].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[4].id.delayen1  (.EN(\dstage[4].id.ldotrim[1] ),
    .I(\dstage[4].id.d0 ),
    .ZN(\dstage[4].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[4].id.delayenb0  (.EN(\dstage[4].id.ltrimbdd[0] ),
    .I(\dstage[4].id.ts ),
    .ZN(\dstage[4].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[4].id.delayenb1  (.EN(\dstage[4].id.ltrimbdd[1] ),
    .I(\dstage[4].id.ts ),
    .ZN(\dstage[4].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[4].id.delayint0  (.I(\dstage[4].id.d1 ),
    .ZN(\dstage[4].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[4].id.t0_latch  (.D(trim[4]),
    .E(\dstage[4].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[4].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.t0l_delay  (.I(\dstage[4].id.ltrim[0] ),
    .Z(\dstage[4].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.t0l_delay2  (.I(\dstage[4].id.ldtrim[0] ),
    .Z(\dstage[4].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[4].id.t0ld_or  (.A1(\dstage[4].id.lddtrim[0] ),
    .A2(\dstage[4].id.ltrim[0] ),
    .Z(\dstage[4].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[4].id.t1_latch  (.D(trim[17]),
    .E(\dstage[4].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[4].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.t1l_delay  (.I(\dstage[4].id.ltrim[1] ),
    .Z(\dstage[4].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.t1l_delay2  (.I(\dstage[4].id.ldtrim[1] ),
    .Z(\dstage[4].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[4].id.t1ld_or  (.A1(\dstage[4].id.lddtrim[1] ),
    .A2(\dstage[4].id.ltrim[1] ),
    .Z(\dstage[4].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[4].id.trim0bar  (.I(\dstage[4].id.ltrim[0] ),
    .ZN(\dstage[4].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.trim0bar_del0  (.I(\dstage[4].id.ltrimb[0] ),
    .Z(\dstage[4].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.trim0bar_del1  (.I(\dstage[4].id.ltrimbd[0] ),
    .Z(\dstage[4].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[4].id.trim1bar  (.I(\dstage[4].id.ltrim[1] ),
    .ZN(\dstage[4].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.trim1bar_del0  (.I(\dstage[4].id.ltrimb[1] ),
    .Z(\dstage[4].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[4].id.trim1bar_del1  (.I(\dstage[4].id.ltrimbd[1] ),
    .Z(\dstage[4].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[4].id.trim_inhibit  (.A1(\dstage[2].id.in ),
    .A2(\dstage[4].id.out_del ),
    .Z(\dstage[4].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[5].id.deglitch_buf  (.I(\dstage[5].id.out ),
    .Z(\dstage[5].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[5].id.delaybuf0  (.I(\dstage[4].id.out ),
    .Z(\dstage[5].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.delaybuf1  (.I(\dstage[5].id.ts ),
    .Z(\dstage[5].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[5].id.delayen0  (.EN(\dstage[5].id.ldotrim[0] ),
    .I(\dstage[5].id.d2 ),
    .ZN(\dstage[5].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[5].id.delayen1  (.EN(\dstage[5].id.ldotrim[1] ),
    .I(\dstage[5].id.d0 ),
    .ZN(\dstage[5].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[5].id.delayenb0  (.EN(\dstage[5].id.ltrimbdd[0] ),
    .I(\dstage[5].id.ts ),
    .ZN(\dstage[5].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[5].id.delayenb1  (.EN(\dstage[5].id.ltrimbdd[1] ),
    .I(\dstage[5].id.ts ),
    .ZN(\dstage[5].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[5].id.delayint0  (.I(\dstage[5].id.d1 ),
    .ZN(\dstage[5].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[5].id.t0_latch  (.D(trim[5]),
    .E(\dstage[5].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[5].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.t0l_delay  (.I(\dstage[5].id.ltrim[0] ),
    .Z(\dstage[5].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.t0l_delay2  (.I(\dstage[5].id.ldtrim[0] ),
    .Z(\dstage[5].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[5].id.t0ld_or  (.A1(\dstage[5].id.lddtrim[0] ),
    .A2(\dstage[5].id.ltrim[0] ),
    .Z(\dstage[5].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[5].id.t1_latch  (.D(trim[18]),
    .E(\dstage[5].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[5].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.t1l_delay  (.I(\dstage[5].id.ltrim[1] ),
    .Z(\dstage[5].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.t1l_delay2  (.I(\dstage[5].id.ldtrim[1] ),
    .Z(\dstage[5].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[5].id.t1ld_or  (.A1(\dstage[5].id.lddtrim[1] ),
    .A2(\dstage[5].id.ltrim[1] ),
    .Z(\dstage[5].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[5].id.trim0bar  (.I(\dstage[5].id.ltrim[0] ),
    .ZN(\dstage[5].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.trim0bar_del0  (.I(\dstage[5].id.ltrimb[0] ),
    .Z(\dstage[5].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.trim0bar_del1  (.I(\dstage[5].id.ltrimbd[0] ),
    .Z(\dstage[5].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[5].id.trim1bar  (.I(\dstage[5].id.ltrim[1] ),
    .ZN(\dstage[5].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.trim1bar_del0  (.I(\dstage[5].id.ltrimb[1] ),
    .Z(\dstage[5].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[5].id.trim1bar_del1  (.I(\dstage[5].id.ltrimbd[1] ),
    .Z(\dstage[5].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[5].id.trim_inhibit  (.A1(\dstage[2].id.out ),
    .A2(\dstage[5].id.out_del ),
    .Z(\dstage[5].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[6].id.deglitch_buf  (.I(\dstage[6].id.out ),
    .Z(\dstage[6].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[6].id.delaybuf0  (.I(\dstage[5].id.out ),
    .Z(\dstage[6].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.delaybuf1  (.I(\dstage[6].id.ts ),
    .Z(\dstage[6].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[6].id.delayen0  (.EN(\dstage[6].id.ldotrim[0] ),
    .I(\dstage[6].id.d2 ),
    .ZN(\dstage[6].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[6].id.delayen1  (.EN(\dstage[6].id.ldotrim[1] ),
    .I(\dstage[6].id.d0 ),
    .ZN(\dstage[6].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[6].id.delayenb0  (.EN(\dstage[6].id.ltrimbdd[0] ),
    .I(\dstage[6].id.ts ),
    .ZN(\dstage[6].id.out ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[6].id.delayenb1  (.EN(\dstage[6].id.ltrimbdd[1] ),
    .I(\dstage[6].id.ts ),
    .ZN(\dstage[6].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[6].id.delayint0  (.I(\dstage[6].id.d1 ),
    .ZN(\dstage[6].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[6].id.t0_latch  (.D(trim[6]),
    .E(\dstage[6].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[6].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.t0l_delay  (.I(\dstage[6].id.ltrim[0] ),
    .Z(\dstage[6].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.t0l_delay2  (.I(\dstage[6].id.ldtrim[0] ),
    .Z(\dstage[6].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[6].id.t0ld_or  (.A1(\dstage[6].id.lddtrim[0] ),
    .A2(\dstage[6].id.ltrim[0] ),
    .Z(\dstage[6].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[6].id.t1_latch  (.D(trim[19]),
    .E(\dstage[6].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[6].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.t1l_delay  (.I(\dstage[6].id.ltrim[1] ),
    .Z(\dstage[6].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.t1l_delay2  (.I(\dstage[6].id.ldtrim[1] ),
    .Z(\dstage[6].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[6].id.t1ld_or  (.A1(\dstage[6].id.lddtrim[1] ),
    .A2(\dstage[6].id.ltrim[1] ),
    .Z(\dstage[6].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[6].id.trim0bar  (.I(\dstage[6].id.ltrim[0] ),
    .ZN(\dstage[6].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.trim0bar_del0  (.I(\dstage[6].id.ltrimb[0] ),
    .Z(\dstage[6].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.trim0bar_del1  (.I(\dstage[6].id.ltrimbd[0] ),
    .Z(\dstage[6].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[6].id.trim1bar  (.I(\dstage[6].id.ltrim[1] ),
    .ZN(\dstage[6].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.trim1bar_del0  (.I(\dstage[6].id.ltrimb[1] ),
    .Z(\dstage[6].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[6].id.trim1bar_del1  (.I(\dstage[6].id.ltrimbd[1] ),
    .Z(\dstage[6].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[6].id.trim_inhibit  (.A1(\dstage[3].id.out ),
    .A2(\dstage[6].id.out_del ),
    .Z(\dstage[6].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[7].id.deglitch_buf  (.I(\dstage[10].id.prev_in ),
    .Z(\dstage[7].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[7].id.delaybuf0  (.I(\dstage[6].id.out ),
    .Z(\dstage[7].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.delaybuf1  (.I(\dstage[7].id.ts ),
    .Z(\dstage[7].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[7].id.delayen0  (.EN(\dstage[7].id.ldotrim[0] ),
    .I(\dstage[7].id.d2 ),
    .ZN(\dstage[10].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[7].id.delayen1  (.EN(\dstage[7].id.ldotrim[1] ),
    .I(\dstage[7].id.d0 ),
    .ZN(\dstage[7].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[7].id.delayenb0  (.EN(\dstage[7].id.ltrimbdd[0] ),
    .I(\dstage[7].id.ts ),
    .ZN(\dstage[10].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[7].id.delayenb1  (.EN(\dstage[7].id.ltrimbdd[1] ),
    .I(\dstage[7].id.ts ),
    .ZN(\dstage[7].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[7].id.delayint0  (.I(\dstage[7].id.d1 ),
    .ZN(\dstage[7].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[7].id.t0_latch  (.D(trim[7]),
    .E(\dstage[7].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[7].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.t0l_delay  (.I(\dstage[7].id.ltrim[0] ),
    .Z(\dstage[7].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.t0l_delay2  (.I(\dstage[7].id.ldtrim[0] ),
    .Z(\dstage[7].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[7].id.t0ld_or  (.A1(\dstage[7].id.lddtrim[0] ),
    .A2(\dstage[7].id.ltrim[0] ),
    .Z(\dstage[7].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[7].id.t1_latch  (.D(trim[20]),
    .E(\dstage[7].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[7].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.t1l_delay  (.I(\dstage[7].id.ltrim[1] ),
    .Z(\dstage[7].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.t1l_delay2  (.I(\dstage[7].id.ldtrim[1] ),
    .Z(\dstage[7].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[7].id.t1ld_or  (.A1(\dstage[7].id.lddtrim[1] ),
    .A2(\dstage[7].id.ltrim[1] ),
    .Z(\dstage[7].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[7].id.trim0bar  (.I(\dstage[7].id.ltrim[0] ),
    .ZN(\dstage[7].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.trim0bar_del0  (.I(\dstage[7].id.ltrimb[0] ),
    .Z(\dstage[7].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.trim0bar_del1  (.I(\dstage[7].id.ltrimbd[0] ),
    .Z(\dstage[7].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[7].id.trim1bar  (.I(\dstage[7].id.ltrim[1] ),
    .ZN(\dstage[7].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.trim1bar_del0  (.I(\dstage[7].id.ltrimb[1] ),
    .Z(\dstage[7].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[7].id.trim1bar_del1  (.I(\dstage[7].id.ltrimbd[1] ),
    .Z(\dstage[7].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[7].id.trim_inhibit  (.A1(\dstage[4].id.out ),
    .A2(\dstage[7].id.out_del ),
    .Z(\dstage[7].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[8].id.deglitch_buf  (.I(\dstage[11].id.prev_in ),
    .Z(\dstage[8].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[8].id.delaybuf0  (.I(\dstage[10].id.prev_in ),
    .Z(\dstage[8].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.delaybuf1  (.I(\dstage[8].id.ts ),
    .Z(\dstage[8].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[8].id.delayen0  (.EN(\dstage[8].id.ldotrim[0] ),
    .I(\dstage[8].id.d2 ),
    .ZN(\dstage[11].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[8].id.delayen1  (.EN(\dstage[8].id.ldotrim[1] ),
    .I(\dstage[8].id.d0 ),
    .ZN(\dstage[8].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[8].id.delayenb0  (.EN(\dstage[8].id.ltrimbdd[0] ),
    .I(\dstage[8].id.ts ),
    .ZN(\dstage[11].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[8].id.delayenb1  (.EN(\dstage[8].id.ltrimbdd[1] ),
    .I(\dstage[8].id.ts ),
    .ZN(\dstage[8].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[8].id.delayint0  (.I(\dstage[8].id.d1 ),
    .ZN(\dstage[8].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[8].id.t0_latch  (.D(trim[8]),
    .E(\dstage[8].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[8].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.t0l_delay  (.I(\dstage[8].id.ltrim[0] ),
    .Z(\dstage[8].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.t0l_delay2  (.I(\dstage[8].id.ldtrim[0] ),
    .Z(\dstage[8].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[8].id.t0ld_or  (.A1(\dstage[8].id.lddtrim[0] ),
    .A2(\dstage[8].id.ltrim[0] ),
    .Z(\dstage[8].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[8].id.t1_latch  (.D(trim[21]),
    .E(\dstage[8].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[8].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.t1l_delay  (.I(\dstage[8].id.ltrim[1] ),
    .Z(\dstage[8].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.t1l_delay2  (.I(\dstage[8].id.ldtrim[1] ),
    .Z(\dstage[8].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[8].id.t1ld_or  (.A1(\dstage[8].id.lddtrim[1] ),
    .A2(\dstage[8].id.ltrim[1] ),
    .Z(\dstage[8].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[8].id.trim0bar  (.I(\dstage[8].id.ltrim[0] ),
    .ZN(\dstage[8].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.trim0bar_del0  (.I(\dstage[8].id.ltrimb[0] ),
    .Z(\dstage[8].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.trim0bar_del1  (.I(\dstage[8].id.ltrimbd[0] ),
    .Z(\dstage[8].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[8].id.trim1bar  (.I(\dstage[8].id.ltrim[1] ),
    .ZN(\dstage[8].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.trim1bar_del0  (.I(\dstage[8].id.ltrimb[1] ),
    .Z(\dstage[8].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[8].id.trim1bar_del1  (.I(\dstage[8].id.ltrimbd[1] ),
    .Z(\dstage[8].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[8].id.trim_inhibit  (.A1(\dstage[5].id.out ),
    .A2(\dstage[8].id.out_del ),
    .Z(\dstage[8].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[9].id.deglitch_buf  (.I(\dstage[10].id.in ),
    .Z(\dstage[9].id.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \dstage[9].id.delaybuf0  (.I(\dstage[11].id.prev_in ),
    .Z(\dstage[9].id.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.delaybuf1  (.I(\dstage[9].id.ts ),
    .Z(\dstage[9].id.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[9].id.delayen0  (.EN(\dstage[9].id.ldotrim[0] ),
    .I(\dstage[9].id.d2 ),
    .ZN(\dstage[10].id.in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \dstage[9].id.delayen1  (.EN(\dstage[9].id.ldotrim[1] ),
    .I(\dstage[9].id.d0 ),
    .ZN(\dstage[9].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \dstage[9].id.delayenb0  (.EN(\dstage[9].id.ltrimbdd[0] ),
    .I(\dstage[9].id.ts ),
    .ZN(\dstage[10].id.in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \dstage[9].id.delayenb1  (.EN(\dstage[9].id.ltrimbdd[1] ),
    .I(\dstage[9].id.ts ),
    .ZN(\dstage[9].id.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \dstage[9].id.delayint0  (.I(\dstage[9].id.d1 ),
    .ZN(\dstage[9].id.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[9].id.t0_latch  (.D(trim[9]),
    .E(\dstage[9].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[9].id.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.t0l_delay  (.I(\dstage[9].id.ltrim[0] ),
    .Z(\dstage[9].id.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.t0l_delay2  (.I(\dstage[9].id.ldtrim[0] ),
    .Z(\dstage[9].id.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[9].id.t0ld_or  (.A1(\dstage[9].id.lddtrim[0] ),
    .A2(\dstage[9].id.ltrim[0] ),
    .Z(\dstage[9].id.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \dstage[9].id.t1_latch  (.D(trim[22]),
    .E(\dstage[9].id.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\dstage[9].id.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.t1l_delay  (.I(\dstage[9].id.ltrim[1] ),
    .Z(\dstage[9].id.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.t1l_delay2  (.I(\dstage[9].id.ldtrim[1] ),
    .Z(\dstage[9].id.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \dstage[9].id.t1ld_or  (.A1(\dstage[9].id.lddtrim[1] ),
    .A2(\dstage[9].id.ltrim[1] ),
    .Z(\dstage[9].id.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[9].id.trim0bar  (.I(\dstage[9].id.ltrim[0] ),
    .ZN(\dstage[9].id.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.trim0bar_del0  (.I(\dstage[9].id.ltrimb[0] ),
    .Z(\dstage[9].id.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.trim0bar_del1  (.I(\dstage[9].id.ltrimbd[0] ),
    .Z(\dstage[9].id.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \dstage[9].id.trim1bar  (.I(\dstage[9].id.ltrim[1] ),
    .ZN(\dstage[9].id.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.trim1bar_del0  (.I(\dstage[9].id.ltrimb[1] ),
    .Z(\dstage[9].id.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \dstage[9].id.trim1bar_del1  (.I(\dstage[9].id.ltrimbd[1] ),
    .Z(\dstage[9].id.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \dstage[9].id.trim_inhibit  (.A1(\dstage[6].id.out ),
    .A2(\dstage[9].id.out_del ),
    .Z(\dstage[9].id.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 ibufp00 (.I(\dstage[2].id.prev_in ),
    .ZN(\c[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_8 ibufp01 (.I(\c[0] ),
    .ZN(clockp[0]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 ibufp10 (.I(\dstage[5].id.out ),
    .ZN(\c[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_8 ibufp11 (.I(\c[1] ),
    .ZN(clockp[1]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \id0.deglitch_buf  (.I(\dstage[3].id.prev_in ),
    .Z(\id0.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \id0.delaybuf0  (.I(\dstage[2].id.prev_in ),
    .Z(\id0.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.delaybuf1  (.I(\id0.ts ),
    .Z(\id0.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \id0.delayen0  (.EN(\id0.ldotrim[0] ),
    .I(\id0.d2 ),
    .ZN(\dstage[3].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \id0.delayen1  (.EN(\id0.ldotrim[1] ),
    .I(\id0.d0 ),
    .ZN(\id0.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \id0.delayenb0  (.EN(\id0.ltrimbdd[0] ),
    .I(\id0.ts ),
    .ZN(\dstage[3].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \id0.delayenb1  (.EN(\id0.ltrimbdd[1] ),
    .I(\id0.ts ),
    .ZN(\id0.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \id0.delayint0  (.I(\id0.d1 ),
    .ZN(\id0.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \id0.t0_latch  (.D(trim[0]),
    .E(\id0.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\id0.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.t0l_delay  (.I(\id0.ltrim[0] ),
    .Z(\id0.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.t0l_delay2  (.I(\id0.ldtrim[0] ),
    .Z(\id0.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \id0.t0ld_or  (.A1(\id0.lddtrim[0] ),
    .A2(\id0.ltrim[0] ),
    .Z(\id0.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \id0.t1_latch  (.D(trim[13]),
    .E(\id0.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\id0.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.t1l_delay  (.I(\id0.ltrim[1] ),
    .Z(\id0.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.t1l_delay2  (.I(\id0.ldtrim[1] ),
    .Z(\id0.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \id0.t1ld_or  (.A1(\id0.lddtrim[1] ),
    .A2(\id0.ltrim[1] ),
    .Z(\id0.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \id0.trim0bar  (.I(\id0.ltrim[0] ),
    .ZN(\id0.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.trim0bar_del0  (.I(\id0.ltrimb[0] ),
    .Z(\id0.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.trim0bar_del1  (.I(\id0.ltrimbd[0] ),
    .Z(\id0.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \id0.trim1bar  (.I(\id0.ltrim[1] ),
    .ZN(\id0.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.trim1bar_del0  (.I(\id0.ltrimb[1] ),
    .Z(\id0.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id0.trim1bar_del1  (.I(\id0.ltrimbd[1] ),
    .Z(\id0.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \id0.trim_inhibit  (.A1(\dstage[10].id.out ),
    .A2(\id0.out_del ),
    .Z(\id0.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \id1.deglitch_buf  (.I(\dstage[2].id.in ),
    .Z(\id1.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \id1.delaybuf0  (.I(\dstage[3].id.prev_in ),
    .Z(\id1.ts ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.delaybuf1  (.I(\id1.ts ),
    .Z(\id1.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \id1.delayen0  (.EN(\id1.ldotrim[0] ),
    .I(\id1.d2 ),
    .ZN(\dstage[2].id.in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \id1.delayen1  (.EN(\id1.ldotrim[1] ),
    .I(\id1.d0 ),
    .ZN(\id1.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \id1.delayenb0  (.EN(\id1.ltrimbdd[0] ),
    .I(\id1.ts ),
    .ZN(\dstage[2].id.in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \id1.delayenb1  (.EN(\id1.ltrimbdd[1] ),
    .I(\id1.ts ),
    .ZN(\id1.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_2 \id1.delayint0  (.I(\id1.d1 ),
    .ZN(\id1.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \id1.t0_latch  (.D(trim[1]),
    .E(\id1.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\id1.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.t0l_delay  (.I(\id1.ltrim[0] ),
    .Z(\id1.ldtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.t0l_delay2  (.I(\id1.ldtrim[0] ),
    .Z(\id1.lddtrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \id1.t0ld_or  (.A1(\id1.lddtrim[0] ),
    .A2(\id1.ltrim[0] ),
    .Z(\id1.ldotrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \id1.t1_latch  (.D(trim[14]),
    .E(\id1.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\id1.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.t1l_delay  (.I(\id1.ltrim[1] ),
    .Z(\id1.ldtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.t1l_delay2  (.I(\id1.ldtrim[1] ),
    .Z(\id1.lddtrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__or2_2 \id1.t1ld_or  (.A1(\id1.lddtrim[1] ),
    .A2(\id1.ltrim[1] ),
    .Z(\id1.ldotrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \id1.trim0bar  (.I(\id1.ltrim[0] ),
    .ZN(\id1.ltrimb[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.trim0bar_del0  (.I(\id1.ltrimb[0] ),
    .Z(\id1.ltrimbd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.trim0bar_del1  (.I(\id1.ltrimbd[0] ),
    .Z(\id1.ltrimbdd[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_1 \id1.trim1bar  (.I(\id1.ltrim[1] ),
    .ZN(\id1.ltrimb[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.trim1bar_del0  (.I(\id1.ltrimb[1] ),
    .Z(\id1.ltrimbd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \id1.trim1bar_del1  (.I(\id1.ltrimbd[1] ),
    .Z(\id1.ltrimbdd[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \id1.trim_inhibit  (.A1(\dstage[11].id.out ),
    .A2(\id1.out_del ),
    .Z(\id1.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__and2_2 \iss.cg_and  (.A1(\iss.out_precg ),
    .A2(\iss.nreset_del ),
    .Z(\dstage[2].id.prev_in ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_iss.reseten0_EN  (.I(reset),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__nor2_2 \iss.ctrlen0  (.A1(reset),
    .A2(\iss.ltrim[0] ),
    .ZN(\iss.ctrl0b ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 \iss.deglitch_buf  (.I(\dstage[2].id.prev_in ),
    .Z(\iss.out_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 \iss.delaybuf0  (.I(\dstage[11].id.out ),
    .Z(\iss.d0 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \iss.delayen0  (.EN(\iss.ltrim[0] ),
    .I(\iss.d2 ),
    .ZN(\iss.out_precg ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_2 \iss.delayen1  (.EN(\iss.ltrim[1] ),
    .I(\iss.d0 ),
    .ZN(\iss.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_8 \iss.delayenb0  (.EN(\iss.ctrl0b ),
    .I(\dstage[11].id.out ),
    .ZN(\iss.out_precg ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_4 \iss.delayenb1  (.EN(\iss.trim1b ),
    .I(\dstage[11].id.out ),
    .ZN(\iss.d1 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__clkinv_1 \iss.delayint0  (.I(\iss.d1 ),
    .ZN(\iss.d2 ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__dlyb_1 \iss.nreset_delay  (.I(\dstage[10].id.nreset ),
    .Z(\iss.nreset_del ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__invz_1 \iss.reseten0  (.EN(reset),
    .I(net),
    .ZN(\iss.out_precg ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \iss.t0_latch  (.D(trim[12]),
    .E(\iss.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\iss.ltrim[0] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__latrnq_1 \iss.t1_latch  (.D(trim[25]),
    .E(\iss.not_edge ),
    .RN(\dstage[10].id.nreset ),
    .Q(\iss.ltrim[1] ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__inv_2 \iss.trim1bar  (.I(\iss.ltrim[1] ),
    .ZN(\iss.trim1b ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__xor2_1 \iss.trim_inhibit  (.A1(\dstage[10].id.in ),
    .A2(\iss.out_del ),
    .Z(\iss.not_edge ),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_Right_0 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_Right_1 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_Right_2 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_Right_3 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_Right_4 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_Right_5 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_Right_6 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_Right_7 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_Right_8 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_Right_9 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_Right_10 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_Right_11 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_12_Right_12 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_13_Right_13 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_14_Right_14 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_15_Right_15 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_16_Right_16 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_17_Right_17 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_18_Right_18 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_19_Right_19 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_20_Right_20 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_21_Right_21 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_22_Right_22 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_23_Right_23 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_0_Left_24 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_1_Left_25 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_2_Left_26 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_3_Left_27 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_4_Left_28 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_5_Left_29 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_6_Left_30 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_7_Left_31 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_8_Left_32 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_9_Left_33 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_10_Left_34 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_11_Left_35 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_12_Left_36 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_13_Left_37 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_14_Left_38 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_15_Left_39 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_16_Left_40 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_17_Left_41 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_18_Left_42 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_19_Left_43 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_20_Left_44 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_21_Left_45 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_22_Left_46 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__endcap PHY_EDGE_ROW_23_Left_47 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_48 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_49 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_50 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_0_51 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_52 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_1_53 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_54 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_2_55 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_56 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_3_57 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_58 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_4_59 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_60 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_5_61 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_62 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_6_63 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_64 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_7_65 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_66 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_8_67 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_68 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_9_69 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_70 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_10_71 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_72 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_11_73 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_74 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_12_75 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_13_76 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_13_77 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_78 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_14_79 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_15_80 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_15_81 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_82 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_16_83 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_17_84 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_17_85 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_18_86 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_18_87 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_19_88 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_19_89 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_20_90 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_20_91 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_21_92 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_21_93 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_22_94 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_22_95 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_23_96 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_23_97 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_23_98 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__filltie TAP_TAPCELL_ROW_23_99 (.VDD(VDD),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__tieh \iss.reseten0_1  (.Z(net),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_iss.ctrlen0_A1  (.I(reset),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna ANTENNA__0__I (.I(reset),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_id0.t0_latch_D  (.I(trim[0]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[10].id.t0_latch_D  (.I(trim[10]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[11].id.t0_latch_D  (.I(trim[11]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_iss.t0_latch_D  (.I(trim[12]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_id0.t1_latch_D  (.I(trim[13]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_id1.t1_latch_D  (.I(trim[14]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[2].id.t1_latch_D  (.I(trim[15]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[3].id.t1_latch_D  (.I(trim[16]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[4].id.t1_latch_D  (.I(trim[17]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[5].id.t1_latch_D  (.I(trim[18]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[6].id.t1_latch_D  (.I(trim[19]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_id1.t0_latch_D  (.I(trim[1]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[7].id.t1_latch_D  (.I(trim[20]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[8].id.t1_latch_D  (.I(trim[21]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[9].id.t1_latch_D  (.I(trim[22]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[10].id.t1_latch_D  (.I(trim[23]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[11].id.t1_latch_D  (.I(trim[24]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_iss.t1_latch_D  (.I(trim[25]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[2].id.t0_latch_D  (.I(trim[2]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[3].id.t0_latch_D  (.I(trim[3]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[4].id.t0_latch_D  (.I(trim[4]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[5].id.t0_latch_D  (.I(trim[5]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[6].id.t0_latch_D  (.I(trim[6]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[7].id.t0_latch_D  (.I(trim[7]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[8].id.t0_latch_D  (.I(trim[8]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__antenna \ANTENNA_dstage[9].id.t0_latch_D  (.I(trim[9]),
    .VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_0_4 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_0_95 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_0_104 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_0_131 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_0_135 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_0_162 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_0_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_0_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_1_63 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_1_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_1_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_2_28 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_2_103 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_2_113 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_2_164 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_2_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_3_4 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_3_69 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_3_72 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_3_122 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_3_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_3_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_24 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_4_115 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_4_117 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_4_157 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_4_165 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_2 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_69 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_84 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_5_109 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_111 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_5_154 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_5_162 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_5_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_5_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_24 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_98 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_107 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_124 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_6_164 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_6_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_7_68 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_7_98 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_7_115 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_7_154 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_7_162 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_7_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_7_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_24 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_62 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_80 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_8_107 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_125 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_8_156 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_8_164 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_8_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_9_69 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_9_111 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_9_122 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_9_150 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_9_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_9_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_10_34 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_10_63 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_10_79 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_10_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_11_4 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_11_62 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_11_95 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_11_118 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_11_154 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_11_162 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_11_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_11_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_12_28 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_12_37 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_12_56 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_12_88 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_12_131 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_12_156 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_12_164 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_12_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_13_4 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_13_45 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_13_67 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_13_139 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_13_159 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_13_167 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_14_45 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_14_119 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_14_160 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_14_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_15_6 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_15_148 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_15_164 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_15_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_16_34 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_16_107 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_16_109 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_16_122 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_16_153 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_17_2 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_17_42 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_17_46 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_17_67 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_17_69 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_17_89 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_17_112 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_17_114 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_17_137 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_17_139 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_17_154 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_17_162 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_17_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_17_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_18_2 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_18_43 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_18_95 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_18_102 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_18_104 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_18_117 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_18_124 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_18_152 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_18_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_19_47 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_19_49 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_19_72 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_19_91 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_19_137 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_19_139 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_19_148 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_4 FILLER_19_164 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_19_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_20_4 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_20_37 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_20_93 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_20_107 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_32 FILLER_20_137 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_21_26 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_21_142 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_21_158 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_21_166 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_21_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_22_24 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_22_47 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_22_87 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_22_102 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_22_104 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_22_119 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_22_121 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_22_152 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_22_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_23_36 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_23_67 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_23_70 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_23_72 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_23_81 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_23_95 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_23_127 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_2 FILLER_23_134 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_16 FILLER_23_144 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fillcap_8 FILLER_23_160 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
 gf180mcu_fd_sc_mcu7t5v0__fill_1 FILLER_23_168 (.VDD(VDD),
    .VNW(VDD),
    .VPW(VSS),
    .VSS(VSS));
endmodule
