// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Description: UART core module
//
//`include "uart_reg_pkg.sv"

module uart_core (
  input                  clk_i,
  input                  rst_ni,

  input  uart_reg_pkg::uart_reg2hw_t reg2hw,
  output uart_reg_pkg::uart_hw2reg_t hw2reg,

  input                  rx,
  output logic           tx
);


  localparam int NcoWidth = 16;

  localparam int TxFifoDepthW = $clog2(uart_reg_pkg::TxFifoDepth)+1;
  localparam int RxFifoDepthW = $clog2(uart_reg_pkg::RxFifoDepth)+1;

  // The design does not support FIFOs deeper than 255 elements with the current CSR layout.
  //`ASSERT_INIT(uart_reg_pkg::TxFifoDepth_A, uart_reg_pkg::TxFifoDepth < 256)
  //`ASSERT_INIT(uart_reg_pkg::RxFifoDepth_A, uart_reg_pkg::RxFifoDepth < 256)
  
// `ifndef SYNTHESIS
//   initial begin
//   	assert(uart_reg_pkg::TxFifoDepth < 256) else $fatal("uart_reg_pkg::TxFifoDepth must be < 256");
//   	assert(uart_reg_pkg::RxFifoDepth < 256) else $fatal("uart_reg_pkg::RxFifoDepth must be < 256");
//   end
// `endif

  logic   [15:0]  rx_val_q;
  logic   [7:0]   uart_rdata;
  logic           tick_baud_x16, rx_tick_baud;

  logic   [TxFifoDepthW-1:0] tx_fifo_depth;
  logic   [RxFifoDepthW-1:0] rx_fifo_depth;
  logic   [RxFifoDepthW-1:0] rx_fifo_depth_prev_q;

  // logic   [23:0]  rx_timeout_count_d, rx_timeout_count_q, uart_rxto_val;

  logic           rx_fifo_depth_changed, uart_rxto_en;
  logic           tx_enable, rx_enable;
  logic           sys_loopback, line_loopback, rxnf_enable;
  logic           uart_fifo_rxrst, uart_fifo_txrst;
  logic   [2:0]   uart_fifo_rxilvl;
  logic   [2:0]   uart_fifo_txilvl;
  logic           ovrd_tx_en, ovrd_tx_val;
  logic   [7:0]   tx_fifo_data;
  logic           tx_fifo_rready, tx_fifo_rvalid;
  logic           tx_fifo_wready, tx_uart_idle;
  logic           tx_out;
  logic           tx_out_q;
  logic   [7:0]   rx_fifo_data;
  logic           rx_valid, rx_fifo_wvalid, rx_fifo_rvalid;
  logic           rx_fifo_wready, rx_uart_idle;
  logic           rx_sync;
  logic           rx_in;

  logic           event_rx_frame_err;
  logic           event_rx_parity_err;

  assign tx_enable        = reg2hw.ctrl.tx.q;
  assign rx_enable        = reg2hw.ctrl.rx.q;
  assign rxnf_enable      = reg2hw.ctrl.nf.q;
  assign sys_loopback     = reg2hw.ctrl.slpbk.q;
  assign line_loopback    = reg2hw.ctrl.llpbk.q;

  assign uart_fifo_rxrst  = reg2hw.fifo_ctrl.rxrst.q & reg2hw.fifo_ctrl.rxrst.qe;
  assign uart_fifo_txrst  = reg2hw.fifo_ctrl.txrst.q & reg2hw.fifo_ctrl.txrst.qe;
  assign uart_fifo_rxilvl = reg2hw.fifo_ctrl.rxilvl.q; 
  assign uart_fifo_txilvl = reg2hw.fifo_ctrl.txilvl.q;

  assign ovrd_tx_en       = reg2hw.ovrd.txen.q;
  assign ovrd_tx_val      = reg2hw.ovrd.txval.q;

  always_comb begin

    hw2reg = '0;
    
    hw2reg.val.d  = rx_val_q;
    hw2reg.rdata.d = uart_rdata;

   hw2reg.status.rxempty.d     = ~rx_fifo_rvalid;
   hw2reg.status.rxidle.d      = rx_uart_idle;
   hw2reg.status.txidle.d      = tx_uart_idle & ~tx_fifo_rvalid;
   hw2reg.status.txempty.d     = ~tx_fifo_rvalid;
   hw2reg.status.rxfull.d      = ~rx_fifo_wready;
   hw2reg.status.txfull.d      = ~tx_fifo_wready;

   hw2reg.fifo_status.txlvl.d  = 8'(tx_fifo_depth);
   hw2reg.fifo_status.rxlvl.d  = 8'(rx_fifo_depth);

   hw2reg.fifo_ctrl.rxilvl.de = 1'b0;
   hw2reg.fifo_ctrl.rxilvl.d  = 3'h0;
   hw2reg.fifo_ctrl.txilvl.de = 1'b0;
   hw2reg.fifo_ctrl.txilvl.d  = 3'h0;
  end


///uncomment lt
  // assign hw2reg.val.d  = rx_val_q;

  // assign hw2reg.rdata.d = uart_rdata;

  // assign hw2reg.status.rxempty.d     = ~rx_fifo_rvalid;
  // assign hw2reg.status.rxidle.d      = rx_uart_idle;
  // assign hw2reg.status.txidle.d      = tx_uart_idle & ~tx_fifo_rvalid;
  // assign hw2reg.status.txempty.d     = ~tx_fifo_rvalid;
  // assign hw2reg.status.rxfull.d      = ~rx_fifo_wready;
  // assign hw2reg.status.txfull.d      = ~tx_fifo_wready;

  // assign hw2reg.fifo_status.txlvl.d  = 8'(tx_fifo_depth);
  // assign hw2reg.fifo_status.rxlvl.d  = 8'(rx_fifo_depth);


///uncomment lt
  //resets are self-clearing, so need to update FIFO_CTRL
  // assign hw2reg.fifo_ctrl.rxilvl.de = 1'b0;
  // assign hw2reg.fifo_ctrl.rxilvl.d  = 3'h0;
  // assign hw2reg.fifo_ctrl.txilvl.de = 1'b0;
  // assign hw2reg.fifo_ctrl.txilvl.d  = 3'h0;

  //              NCO 16x Baud Generator
  // output clock rate is:
  //      Fin * (NCO/2**NcoWidth)
  logic   [NcoWidth:0]     nco_sum_q; // extra bit to get the carry

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      nco_sum_q <= 17'h0;
    end else if (tx_enable || rx_enable) begin
      nco_sum_q <= {1'b0,nco_sum_q[NcoWidth-1:0]} + {1'b0,reg2hw.ctrl.nco.q[NcoWidth-1:0]}; //op

    end
  end

  assign tick_baud_x16 = nco_sum_q[NcoWidth];

  //////////////
  // TX Logic //
  //////////////

  assign tx_fifo_rready = tx_uart_idle & tx_fifo_rvalid & tx_enable;

  prim_fifo_sync #(
    .Width   (8),
    .Pass    (1'b0),
    .Depth   (uart_reg_pkg::TxFifoDepth)
  ) u_uart_txfifo (
    .clk_i	(clk_i),
    .rst_ni	(rst_ni),
    .clr_i   (uart_fifo_txrst),
    .wvalid_i(reg2hw.wdata.qe),
    .wready_o(tx_fifo_wready),
    .wdata_i (reg2hw.wdata.q),	//reg2hw.wdata.q, data to send
    .depth_o (tx_fifo_depth),
    .full_o (),
    .rvalid_o(tx_fifo_rvalid),	//reg2hw.wdata.qe[0]
    .rready_i(tx_fifo_rready),
    .rdata_o (tx_fifo_data),	//reg2hw.wdata.q
    .err_o   ()
  );

  uart_tx uart_tx (
    .clk_i,
    .rst_ni,
    .tx_enable,
    .tick_baud_x16,
    .parity_enable  (reg2hw.ctrl.parity_en.q),
    .wr             (tx_fifo_rready),
    .wr_parity      ((^tx_fifo_data) ^ reg2hw.ctrl.parity_odd.q),
    .wr_data        (tx_fifo_data),
    .idle           (tx_uart_idle),
    .tx             (tx_out)
  );

  assign tx = line_loopback ? rx : tx_out_q ;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      tx_out_q <= 1'b1;
    end else if (ovrd_tx_en) begin
      tx_out_q <= ovrd_tx_val ;
    end else if (sys_loopback) begin
      tx_out_q <= 1'b1;
    end else begin
      tx_out_q <= tx_out;
    end
  end

  //////////////
  // RX Logic //
  //////////////

       //sync the incoming data
  prim_flop_2sync #(
    .Width(1),
    .ResetValue(1'b1)
  ) sync_rx (
    .clk_i,
    .rst_ni,
    .d_i(rx),
    .q_o(rx_sync)
  );

  // Based on: en.wikipedia.org/wiki/Repetition_code mentions the use of a majority filter
  // in UART to ignore brief noise spikes
  logic   rx_sync_q1, rx_sync_q2, rx_in_mx, rx_in_maj;

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      rx_sync_q1 <= 1'b1;
      rx_sync_q2 <= 1'b1;
    end else begin
      rx_sync_q1 <=  rx_sync;
      rx_sync_q2 <= rx_sync_q1;
    end
  end

  assign rx_in_maj = (rx_sync    & rx_sync_q1) |
                     (rx_sync    & rx_sync_q2) |
                     (rx_sync_q1 & rx_sync_q2);
  assign rx_in_mx  = rxnf_enable ? rx_in_maj : rx_sync;

//feeds tx output back into rx path
  assign rx_in =  sys_loopback ? tx_out   :
                  line_loopback ? 1'b1 :
                  rx_in_mx;

  uart_rx uart_rx (
    .clk_i,
    .rst_ni,
    .rx_enable,
    .tick_baud_x16,
    .parity_enable  (reg2hw.ctrl.parity_en.q),
    .parity_odd     (reg2hw.ctrl.parity_odd.q),
    .tick_baud      (rx_tick_baud),
    .rx_valid,
    .rx_data        (rx_fifo_data),
    .idle           (rx_uart_idle),
    .frame_err      (event_rx_frame_err),
    .rx             (rx_in),
    .rx_parity_err  (event_rx_parity_err)
  );

   assign rx_fifo_wvalid = rx_valid & ~event_rx_frame_err & ~event_rx_parity_err;
  // assign rx_fifo_wvalid = rx_valid; //mine

  prim_fifo_sync #(
    .Width   (8),
    .Pass    (1'b0),
    .Depth   (uart_reg_pkg::RxFifoDepth)
  ) u_uart_rxfifo (
    .clk_i,
    .rst_ni,
    .clr_i   (uart_fifo_rxrst),
    .wvalid_i(rx_fifo_wvalid),
    .wready_o(rx_fifo_wready),//
    .wdata_i (rx_fifo_data),
    .depth_o (rx_fifo_depth),
    .full_o (),
    .rvalid_o(rx_fifo_rvalid),
    .rready_i(reg2hw.rdata.re),
    .rdata_o (uart_rdata),
    .err_o   ()
  );

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni)            rx_val_q <= 16'h0;
    else if (tick_baud_x16) rx_val_q <= {rx_val_q[14:0], rx_in};
  end

endmodule