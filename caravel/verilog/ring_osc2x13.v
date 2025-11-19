// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
`timescale 1 ns / 1 ps
// Tunable ring oscillator---synthesizable (physical) version.
//
// NOTE:  This netlist cannot be simulated correctly due to lack
// of accurate timing in the digital cell verilog models.

// Changes for waferspace version: added trim latches for glitch avoidance

module delay_stage(in, trim, out, prev_in, nreset);
    input in;
    input [1:0] trim;
    output out;
    input prev_in;
    input nreset;

    wire d0, d1, d2, ts;

    wire not_edge, out_del;
    wire [1:0] ltrim;
    wire [1:0] ldtrim;
    wire [1:0] lddtrim;
    wire [1:0] ldotrim;
    wire [1:0] ltrimb;
    wire [1:0] ltrimbd;
    wire [1:0] ltrimbdd;

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__inv_1 trim0bar (
	.I(ltrim[0]),
	.ZN(ltrimb[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__inv_1 trim1bar (
	.I(ltrim[1]),
	.ZN(ltrimb[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 trim0bar_del0 (
	.I(ltrimb[0]),
	.Z(ltrimbd[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 trim0bar_del1 (
	.I(ltrimbd[0]),
	.Z(ltrimbdd[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 trim1bar_del0 (
	.I(ltrimb[1]),
	.Z(ltrimbd[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 trim1bar_del1 (
	.I(ltrimbd[1]),
	.Z(ltrimbdd[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 delaybuf0 (
	.I(in),
	.Z(ts)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 delaybuf1 (
	.I(ts),
	.Z(d0)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_2 delayen1 (
	.I(d0),
	.EN(ldotrim[1]),
	.ZN(d1)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_4 delayenb1 (
	.I(ts),
	.EN(ltrimbdd[1]),
	.ZN(d1)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkinv_2 delayint0 (
	.I(d1),
	.ZN(d2)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_2 delayen0 (
	.I(d2),
	.EN(ldotrim[0]),
	.ZN(out)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_8 delayenb0 (
	.I(ts),
	.EN(ltrimbdd[0]),
	.ZN(out)
    );

    // Latch trim values, inhibit change near edges
    // and ensure EN signals always overlap to remove glitches & Z's
    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 deglitch_buf (
	.I(out),
	.Z(out_del)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__xor2_1 trim_inhibit (
    .A1(prev_in),
    .A2(out_del),
    .Z(not_edge)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 t0l_delay (
    .I(ltrim[0]),
    .Z(ldtrim[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 t1l_delay (
    .I(ltrim[1]),
    .Z(ldtrim[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 t0l_delay2 (
    .I(ldtrim[0]),
    .Z(lddtrim[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 t1l_delay2 (
    .I(ldtrim[1]),
    .Z(lddtrim[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__or2_2 t0ld_or (
    .A1(lddtrim[0]),
    .A2(ltrim[0]),
    .Z(ldotrim[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__or2_2 t1ld_or (
    .A1(lddtrim[1]),
    .A2(ltrim[1]),
    .Z(ldotrim[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__latrnq_1 t0_latch (
    .RN(nreset),
    .D(trim[0]),
    .E(not_edge),
    .Q(ltrim[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__latrnq_1 t1_latch (
    .RN(nreset),
    .D(trim[1]),
    .E(not_edge),
    .Q(ltrim[1])
    );
    

endmodule

module start_stage(in, trim, reset, out, prev_in, nreset);
    input in;
    input [1:0] trim;
    input reset;
    output out;
    input prev_in;
    input nreset;

    wire d0, d1, d2, ctrl0b, one, zero;
    wire trim1b;
    
    wire not_edge, nreset_del, out_del, out_precg;
    wire [1:0] ltrim;

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__inv_2 trim1bar (
	.I(ltrim[1]),
	.ZN(trim1b)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_1 delaybuf0 (
	.I(in),
	.Z(d0)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_2 delayen1 (
	.I(d0),
	.EN(ltrim[1]),
	.ZN(d1)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_4 delayenb1 (
	.I(in),
	.EN(trim1b),
	.ZN(d1)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkinv_1 delayint0 (
	.I(d1),
	.ZN(d2)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_2 delayen0 (
	.I(d2),
	.EN(ltrim[0]),
	.ZN(out_precg)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_8 delayenb0 (
	.I(in),
	.EN(ctrl0b),
	.ZN(out_precg)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__invz_1 reseten0 (
	.I(one),
	.EN(reset),
	.ZN(out_precg)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__nor2_2 ctrlen0 (
	.A1(reset),
	.A2(ltrim[0]),
	.ZN(ctrl0b)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__tieh const1 (
	.Z(one)
    );

    // latch trim and inhibit change near the edge to remove glitches
    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkbuf_2 deglitch_buf (
	.I(out),
	.Z(out_del)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__xor2_1 trim_inhibit (
    .A1(prev_in),
    .A2(out_del),
    .Z(not_edge)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__latrnq_1 t0_latch (
    .RN(nreset),
    .D(trim[0]),
    .E(not_edge),
    .Q(ltrim[0])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__latrnq_1 t1_latch (
    .RN(nreset),
    .D(trim[1]),
    .E(not_edge),
    .Q(ltrim[1])
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__dlyb_1 nreset_delay (
    .I(nreset),
    .Z(nreset_del)
    );

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__and2_2 cg_and (
    .A1(out_precg),
    .A2(nreset_del),
    .Z(out)
    );

endmodule

// Ring oscillator with 13 stages, each with two trim bits delay
// (see above).  Trim is not binary:  For trim[1:0], lower bit
// trim[0] is primary trim and must be applied first;  upper
// bit trim[1] is secondary trim and should only be applied
// after the primary trim is applied, or it has no effect.
//
// Total effective number of inverter stages in this oscillator
// ranges from 13 at trim 0 to 65 at trim 24.  The intention is
// to cover a range greater than 2x so that the midrange can be
// reached over all PVT conditions.
//
// Frequency of this ring oscillator under SPICE simulations at
// nominal PVT is maximum 73.3 MHz (trim 0), minimum 32.7 MHz (trim 24).

module ring_osc2x13(reset, trim, clockp);
    input reset;
    input [25:0] trim;
    output[1:0] clockp;

`ifdef FUNCTIONAL	// i.e., behavioral model below

    reg [1:0] clockp;
    reg hiclock;
    integer i;
    real delay;
    wire [5:0] bcount;

    assign bcount = trim[0] + trim[1] + trim[2]
		+ trim[3] + trim[4] + trim[5] + trim[6] + trim[7]
		+ trim[8] + trim[9] + trim[10] + trim[11] + trim[12]
		+ trim[13] + trim[14] + trim[15] + trim[16] + trim[17]
		+ trim[18] + trim[19] + trim[20] + trim[21] + trim[22]
		+ trim[23] + trim[24] + trim[25];

    initial begin
	hiclock <= 1'b0;
	delay = 3.0;
    end

    // Fastest operation at tt is 53.5 MHz = 18.7ns, slowest - 25.5 MHz = 39.3ns
    // Delay per trim is 0.7923
    // Run "hiclock" at 2x this rate, then use positive and negative
    // edges to derive the 0 and 90 degree phase clocks.

    always #delay begin
	hiclock <= (hiclock === 1'b0);
    end

    always @(bcount) begin
    	// Implement trim as a variable delay, one delay per trim bit
	delay = 4.675 + 0.198 * $itor(bcount);
    end

    always @(posedge hiclock or posedge reset) begin
	if (reset == 1'b1) begin
	    clockp[0] <= 1'b0;
	end else begin
	    clockp[0] <= (clockp[0] === 1'b0);
	end
    end

    always @(negedge hiclock or posedge reset) begin
	if (reset == 1'b1) begin
	    clockp[1] <= 1'b0;
	end else begin
	    clockp[1] <= (clockp[1] === 1'b0);
	end
    end

`else 			// !FUNCTIONAL;  i.e., gate level netlist below

    wire [1:0] clockp;
    wire [12:0] d;
    wire [1:0] c;

    // Main oscillator loop stages

    delay_stage id0 (
    .in(d[0]),
    .trim({trim[13], trim[0]}),
    .out(d[1]),
    .prev_in(d[11]),
    .nreset(~reset)
    );

    delay_stage id1 (
    .in(d[1]),
    .trim({trim[14], trim[1]}),
    .out(d[2]),
    .prev_in(d[12]),
    .nreset(~reset)
    );
 
    genvar i;
    generate
	for (i = 2; i < 12; i = i + 1) begin : dstage
	    delay_stage id (
		.in(d[i]),
		.trim({trim[i+13], trim[i]}),
		.out(d[i+1]),
		.prev_in(d[i-2]),
        .nreset(~reset)
	    );
	end
    endgenerate

    // Reset/startup stage
 
    start_stage iss (
	.in(d[12]),
	.trim({trim[25], trim[12]}),
	.reset(reset),
	.out(d[0]),
	.prev_in(d[10]),
    .nreset(~reset)
    );

    // Buffered outputs at 0 and 90 degrees phase (approximately)

    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkinv_2 ibufp00 (
	.I(d[0]),
	.ZN(c[0])
    );
    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkinv_8 ibufp01 (
	.I(c[0]),
	.ZN(clockp[0])
    );
    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkinv_2 ibufp10 (
	.I(d[6]),
	.ZN(c[1])
    );
    (* keep, dont_touch *)
    gf180mcu_fd_sc_mcu7t5v0__clkinv_8 ibufp11 (
	.I(c[1]),
	.ZN(clockp[1])
    );

`endif // !FUNCTIONAL

endmodule
`default_nettype wire
