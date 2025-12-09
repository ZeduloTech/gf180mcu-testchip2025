// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Generic synchronous fifo for use in a variety of devices.

// `include "prim_assert.sv"
// `include "prim_fifo_assert.svh"

module prim_fifo_sync #(
  parameter int unsigned Width       = 16,
  parameter bit Pass                 = 1'b1, // if == 1 allow requests to pass through empty FIFO
  parameter int unsigned Depth       = 4,
  parameter bit OutputZeroIfEmpty    = 1'b1, // if == 1 always output 0 when FIFO is empty
  parameter bit NeverClears          = 1'b0, // if set, the clr_i port is never high
  parameter bit Secure               = 1'b0  // use prim count for pointers
) (
  input                   clk_i,
  input                   rst_ni,
  // synchronous clear / flush port
  input                   clr_i,
  // write port
  input                   wvalid_i,
  output                  wready_o,
  input   [Width-1:0]     wdata_i,
  // read port
  output                  rvalid_o,
  input                   rready_i,
   output                  full_o,
  output  [Width-1:0]     rdata_o,
  // occupancy — compute width expression directly so it's valid in the port list
  output  logic [prim_util_pkg_u::vbits(Depth+1)-1:0] depth_o,
  output                  err_o
);

  // internal derived parameter
  localparam int DepthW = prim_util_pkg_u::vbits(Depth+1);

  // FIFO is in complete passthrough mode
  generate
    if (Depth == 0) begin : gen_passthru_fifo
      // `ASSERT_INIT(paramCheckPass, Pass == 1)

      // depth_o is vector sized via port expression above
      assign depth_o  = '0;
      assign rvalid_o = wvalid_i;
      assign rdata_o  = wdata_i;
      assign wready_o = rready_i;
      assign full_o   = 1'b1;

      // avoid lint warnings
      logic unused_clr;
      assign unused_clr = clr_i;

      assign err_o = 1'b0;

    // FIFO has space for a single element (singleton)
    end else if (Depth == 1) begin : gen_singleton_fifo
      logic full_d, full_q;

      assign full_o   = full_q;
      assign depth_o  = full_q;
      assign wready_o = ~full_q;
      assign rvalid_o = full_q || (Pass && wvalid_i);

      assign full_d = (rvalid_o ? !rready_i : wvalid_i) && !clr_i;

      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) full_q <= 1'b0;
        else         full_q <= full_d;
      end

      logic [Width-1:0] storage;
      always_ff @(posedge clk_i) begin
        if (wvalid_i && wready_o) storage <= wdata_i;
      end

      logic [Width-1:0] rdata_int_single;
      assign rdata_int_single = (full_q || Pass == 1'b0) ? storage : wdata_i;
      assign rdata_o   = (OutputZeroIfEmpty && !rvalid_o) ? '0 : rdata_int_single;

      if (!Secure) begin : gen_not_secure
        assign err_o = 1'b0;
      end else begin : gen_secure
        logic inv_full;
        prim_flop #(
          .Width(1),
          .ResetValue(1'b1)
        ) u_inv_full (
          .clk_i,
          .rst_ni,
          .d_i(~full_d),
          .q_o(inv_full)
        );

        logic err_d, err_q;
        assign err_d = ~(full_q ^ inv_full);

        always_ff @(posedge clk_i or negedge rst_ni) begin
          if (!rst_ni) err_q <= 1'b0;
          else         err_q <= err_d;
        end
        assign err_o = err_q;
      end

    // Normal FIFO construction (Depth >= 2)
    end else begin : gen_normal_fifo
      localparam int PtrW = prim_util_pkg_u::vbits(Depth);

      logic [PtrW-1:0] fifo_wptr, fifo_rptr;
      logic            fifo_incr_wptr, fifo_incr_rptr, fifo_empty;

      // module under reset flag
      logic under_rst;
      always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)       under_rst <= 1'b1;
        else if (under_rst) under_rst <= 1'b0;
      end

      logic empty;

      assign wready_o = ~full_o & ~under_rst;

      prim_fifo_sync_cnt #(
        .Depth(Depth),
        .Secure(Secure),
        .NeverClears(NeverClears)
      ) u_fifo_cnt (
        .clk_i,
        .rst_ni,
        .clr_i,
        .incr_wptr_i(fifo_incr_wptr),
        .incr_rptr_i(fifo_incr_rptr),
        .wptr_o(fifo_wptr),
        .rptr_o(fifo_rptr),
        .full_o(full_o),
        .empty_o(fifo_empty),
        .depth_o(depth_o),
        .err_o(err_o)
      );

      assign fifo_incr_wptr = wvalid_i & wready_o;
      assign fifo_incr_rptr = rvalid_o & rready_i & ~under_rst;

      // storage as an unpacked array: storage[index] is Width bits
      logic [Width-1:0] storage [Depth-1:0];

      // rdata intermediate and storage read data
      logic [Width-1:0] storage_rdata;
      logic [Width-1:0] rdata_int;

      // safe read from storage
      assign storage_rdata = storage[fifo_rptr];

      // write into storage
      always_ff @(posedge clk_i) begin
        if (fifo_incr_wptr) storage[fifo_wptr] <= wdata_i;
      end

      if (Pass) begin : gen_pass
        assign rdata_int = (fifo_empty && wvalid_i) ? wdata_i : storage_rdata;
        assign empty     = fifo_empty & ~wvalid_i;
        assign rvalid_o  = ~empty & ~under_rst;
      end else begin : gen_nopass
        assign rdata_int = storage_rdata;
        assign empty     = fifo_empty;
        assign rvalid_o  = ~empty;
      end

      if (OutputZeroIfEmpty) begin : gen_output_zero
        assign rdata_o = empty ? '0 : rdata_int;
      end else begin : gen_no_output_zero
        assign rdata_o = rdata_int;
      end

      // `ASSERT(depthShallNotExceedParamDepth,
      //         (!empty) |-> (depth_o <= DepthW'(Depth)),
      //         `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)

      // `ASSERT(OnlyRvalidWhenNotUnderRst_A,
      //         rvalid_o |-> ~under_rst,
      //         `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)

    end
  endgenerate

  // generate
  //   if (NeverClears) begin : gen_never_clears
  //     `ASSERT(NeverClears_A, !clr_i, `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)
  //   end
  // endgenerate

  //////////////////////
  // Known Assertions //
  //////////////////////
//   `ASSERT_KNOWN_IF(DataKnown_A,  rdata_o,  rvalid_o, `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)
//   `ASSERT_KNOWN(DepthKnown_A,    depth_o,             `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)
//   `ASSERT_KNOWN(RvalidKnown_A,   rvalid_o,            `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)
//   `ASSERT_KNOWN(WreadyKnown_A,   wready_o,            `ASSERT_DEFAULT_CLK, `ASSERT_DEFAULT_RST)

// `ifdef INC_ASSERT
//   logic unused_assert_connected;
//   generate
//     if (Depth == 1 && Secure) begin : gen_secure_singleton
//       `ASSERT_INIT_NET(AssertConnected_A, unused_assert_connected === 1'b1)
//     end
//   endgenerate
// `endif

endmodule
