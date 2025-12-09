// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Generic synchronous fifo for use in a variety of devices.

// EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// // EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// EDIT END

// This adapter module allows using a single-port SRAM like a FIFO.  It has been written for I2C,
// but it could later be generalized into a prim.

`timescale 1ns / 1ps


module i2c_fifo_sync_sram_adapter #(
    // Width of each entry (in bits)
    // parameter int unsigned Width = 1,
    //    Total depth of the FIFO (in number of entries), including the output buffer in this module.
    // // Must be at least 3.
    // parameter int unsigned Depth = 3,
    //    Address width of the SRAM
    // parameter int unsigned SramAw = 1,
    //    Base address of the FIFO in the SRAM
    // parameter logic [SramAw-1:0] SramBaseAddr = '0,
    //    Derived parameters; don't override!
    // parameter int unsigned DepthW = prim_util_pkg::vbits(Depth + 1)
    parameter int WIDTH = 13,
    parameter int DEPTH = 8,  // Reduced from 64 for better synthesis
    parameter int ADDR_WIDTH = $clog2(DEPTH)
) (
    input  logic                clk_i,
    input  logic                rst_ni,
    input  logic                fifo_clr_i,
    
    // Write interface
    input  logic                fifo_wvalid_i,
    output logic                fifo_wready_o,
    input  logic [WIDTH-1:0]    fifo_wdata_i,
    
    // Read interface
    output logic                fifo_rvalid_o,
    input  logic                fifo_rready_i,
    output logic [WIDTH-1:0]    fifo_rdata_o,
    
    // Status
    output logic [ADDR_WIDTH:0] fifo_depth_o
);

  // Depth of the input buffer.
  // localparam int unsigned InpBufDepth = 2;

  // Depth of the output buffer.  To support a read in the cycle after N consecutive cycles in which
  // this module simultaneously got written and read, the depth needs to be N + 1 (one entry extra
  // to cover the single-cycle latency of SRAM reads).  We currently support this for 1 cycle.
  // localparam int unsigned OupBufDepth = 2;

  // Depth of the SRAM-stored FIFO; simply the entries that don't fit into the output buffer.
  // localparam int SramFifoDepth = Depth - OupBufDepth;

  // While it would theoretically be possible that the output buffer is as deep as the entire FIFO,
  // the current implementation doesn't support this.
//  `ASSERT_INIT(MinimalSramFifoDepth_A, SramFifoDepth >= 1)

  // localparam int unsigned InpBufDepthW = prim_util_pkg::vbits(InpBufDepth + 1);
  // localparam int unsigned OupBufDepthW = prim_util_pkg::vbits(OupBufDepth + 1);
  // localparam int unsigned SramPtrW = prim_util_pkg::vbits(SramFifoDepth);
  // localparam int unsigned SramDepthW = prim_util_pkg::vbits(SramFifoDepth + 1);

//  `ASSERT_INIT(MinimalSramAw_A, SramAw >= SramPtrW)

    // localparam int unsigned SramAddrLeadingZeros = SramAw - SramPtrW;

    // // Input buffer
    // logic                    inp_buf_wvalid, inp_buf_wready,
    //                          inp_buf_rvalid, inp_buf_rready,
    //                          inp_buf_err;
    // logic [Width-1:0]        inp_buf_rdata;
    // logic [InpBufDepthW-1:0] inp_buf_depth;
    // prim_fifo_sync #(
    //   .Width(Width),
    //   .Pass (1'b1),
    //   .Depth(InpBufDepth)
    // ) u_inp_buf (
    //   .clk_i,
    //   .rst_ni,
    //   .fifo_clr_i,
    //   .fifo_wvalid_i(inp_buf_wvalid),
    //   .fifo_wready_o(inp_buf_wready),
    //   .fifo_wdata_i (fifo_wdata_i),
    //   .fifo_rvalid_o(inp_buf_rvalid),
    //   .fifo_rready_i(inp_buf_rready),
    //   .fifo_rdata_o (inp_buf_rdata),
    //   .full_o  (/* unused */),
    //   .fifo_depth_o (inp_buf_depth),
    //   .err_o   (inp_buf_err)
    // );

    // CRITICAL: Use (* ram_style = "block" *) to force block RAM inference
    (* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
    logic [ADDR_WIDTH:0]   count;
    
    logic full, empty;
    logic do_write, do_read;
    
    // Initialize memory to zero (prevents X values)
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            mem[i] = '0;
        end
    end
    
    
    // Full/Empty logic
    assign full  = (count == DEPTH);
    assign empty = (count == 0);
    
    // Ready/Valid signals
    assign fifo_wready_o = !full;
    assign fifo_rvalid_o = !empty;
    
    // Direct write (no registration) - FSM doesn't check wready
    assign do_write = fifo_wvalid_i && fifo_wready_o;
    assign do_read  = fifo_rvalid_o && fifo_rready_i;
    
    // Status output
    assign fifo_depth_o = count;
    
    // Write pointer and data (direct write, no pipeline)
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            wr_ptr <= '0;
            // Initialize all memory on reset
            // for (int j = 0; j < DEPTH; j++) begin
            //     mem[j] <= '0;
            // end
        end else if (fifo_clr_i) begin
            wr_ptr <= '0;
            // Clear memory on explicit clear
            // for (int j = 0; j < DEPTH; j++) begin
            //     mem[j] <= '0;
            // end
        end else if (do_write) begin
            mem[wr_ptr] <= fifo_wdata_i;
            if (wr_ptr == DEPTH-1) 
                wr_ptr <= '0;
            else
                wr_ptr <= wr_ptr + 1'b1;
        end
    end
    
    // Read pointer
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            rd_ptr <= '0;
        end else if (fifo_clr_i) begin
            rd_ptr <= '0;
        end else if (do_read) begin
            if (rd_ptr == DEPTH-1) 
                rd_ptr <= '0;
            else
                rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Control logic for FIFO interface wready, output buffer writes, and SRAM requests
    // logic state_err;
    // always_comb begin
    //   inp_buf_rready = 1'b0;
    //   oup_buf_wvalid = 1'b0;
    //   oup_buf_wdata = inp_buf_rdata;
    //   sram_req_o = 1'b0;
    //   sram_write_o = 1'b0;
    //   sram_addr_o = sram_wr_addr;
    //   state_err = 1'b0;

    //   // If the SRAM was read in the previous cycle, write the read data to the output buffer.
    //   if (sram_read_in_prev_cyc_q) begin
    //     oup_buf_wvalid = 1'b1;
    //     oup_buf_wdata = sram_rdata_i;
    //     // The output buffer must be ready; otherwise we are in an erroneous state.
    //     state_err = !oup_buf_wready;
    //   end

    //   // If the SRAM is not empty, data from the input buffer must flow via the SRAM.
    //   if (!sram_empty) begin

    // Prioritize refilling of the output buffer: if the output buffer is not being filled to the
    // last slot in the current cycle or it is being read in the current cycle, read from the SRAM
    // so the output buffer can be written in the next cycle.
    //     if (!((oup_buf_almost_full && oup_buf_wvalid) || oup_buf_full)
    //         || (fifo_rvalid_o && fifo_rready_i)) begin
    //       sram_req_o = 1'b1;
    //       sram_write_o = 1'b0;
    //       sram_addr_o = sram_rd_addr;

    //     // If the output buffer is full (and not being read), drain the input buffer into the SRAM.
    //     end else begin
    //       sram_req_o = !sram_full && inp_buf_rvalid;
    //       sram_write_o = 1'b1;
    //       sram_addr_o = sram_wr_addr;
    //       inp_buf_rready = !sram_full && sram_gnt_i;
    //     end
    
    // Count tracking (direct write)
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            count <= '0;
        end else if (fifo_clr_i) begin
            count <= '0;
        end else begin
            case ({do_write, do_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end
    
    // Read data - combinational with write-through and safety
    // If writing and reading same location, bypass memory (write-through)
    logic bypass;
    assign bypass = do_write && do_read && (wr_ptr == rd_ptr) && !empty;
    assign fifo_rdata_o = empty ? {WIDTH{1'b0}} : (bypass ? fifo_wdata_i : mem[rd_ptr]);
    
    // If the SRAM is empty, data must flow from the input buffer to the output buffer if the output
    // buffer is ready and is not receiving data read from the SRAM in the previous cycle
    //   end else if (oup_buf_wready && !sram_read_in_prev_cyc_q) begin
    //     oup_buf_wvalid = inp_buf_rvalid;
    //     oup_buf_wdata = inp_buf_rdata;
    //     inp_buf_rready = oup_buf_wready;

    // Otherwise the SRAM is empty but the output buffer cannot take the data from the input buffer,
    // so drain the input buffer into the SRAM.
    //   end else begin
    //     sram_req_o = !sram_full && inp_buf_rvalid;
    //     sram_write_o = 1'b1;
    //     sram_addr_o = sram_wr_addr;
    //     inp_buf_rready = !sram_full && sram_gnt_i;
    //   end
    // end
    // 
    // Error output is high if any of the internal errors is high
    // assign err_o = |{inp_buf_err, oup_buf_err, sram_ptrs_err, state_err};

    // The SRAM and the output buffer together form the entire architectural capacity of the FIFO.
    // Thus, when both are full, the FIFO is no longer ready to receive writes even though the input
    // buffer could store one additional entry.  This ensures that in the cycle after an entry has
    // been read from the full FIFO, the next entry can be written to the FIFO.
    // (It may be possible that all input buffer slots except one can be counted to the architectural
    // capacity of the FIFO, but this is a relatively small optimization left for future work.)
    // assign fifo_wready_o = inp_buf_wready && !(sram_full && oup_buf_full);
    // 
    // // The current depth of the FIFO represented by this module is the depth of all buffers plus the
    // // FIFO in the SRAM plus one if there's an entry in transition between SRAM and output buffer.
    // assign fifo_depth_o = DepthW'(inp_buf_depth) + DepthW'(sram_depth) + DepthW'(oup_buf_depth) +
    //                       DepthW'(sram_read_in_prev_cyc_q);
    // 
    // // SRAM write data always comes from the input buffer.
    // assign sram_wdata_o = inp_buf_rdata;
    // assign sram_wmask_o = '1;
    // 
    // // `sram_rvalid_i` is only used for assertions.
    // logic unused_sram_rvalid;
    // assign unused_sram_rvalid = sram_rvalid_i;

  // When we read from the SRAM in the previous cycle, we expect valid read data in this cycle.
  // EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// `ASSUME(SramRvalidAfterRead_A, sram_read_in_prev_cyc_q |-> sram_rvalid_i)

  // When we read from the SRAM in the previous cycle, the output buffer must be ready to store data
  // in this cycle.
  // EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// `ASSERT(OupBufWreadyAfterSramRead_A, sram_read_in_prev_cyc_q |-> oup_buf_wready)

  // We must never write the SRAM when it is full.
  // EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// `ASSERT(NoSramWriteWhenFull_A, sram_full |-> !sram_incr_wr_ptr)

  // We must never read from the SRAM when it is empty.
  // EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// `ASSERT(NoSramReadWhenEmpty_A, sram_empty |-> !sram_incr_rd_ptr)

  // We must never be in an erroneous state (impossible without functional defects).
  // EDIT: COMMENTED OUT CURRENTLY UNEEDED MACROS FROM PRIM_ASSERT
// `ASSERT(NoErr_A, !err_o)
endmodule

