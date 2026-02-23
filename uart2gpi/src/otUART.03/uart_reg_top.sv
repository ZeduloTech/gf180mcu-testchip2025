//=======================================================
// UART Register File Module
// Implements memory-mapped register interface for SW access
// No interrupts - polling-based operation only
//=======================================================
module uart_reg_top 
    import uart_reg_pkg::*;
(
    input  logic        clk_i,
    input  logic        rst_ni,
    
    input  logic [5:0]  addr_i,
    input  logic [31:0] wdata_i,
    input  logic        wen_i,
    input  logic        ren_i,
    output logic [31:0] rdata_o,
    output logic        ready_o,
    
    output uart_reg2hw_t reg2hw,
    input  uart_hw2reg_t hw2reg
);

    //=======================================================
    // Register Storage
    //=======================================================
    logic [31:0] ctrl_q;
    logic [31:0] fifo_ctrl_q;
    logic [31:0] timeout_ctrl_q;
    logic [7:0]  wdata_q;           // storage for write data
    logic        wdata_qe;          // Store the write enable pulse

    //=======================================================
    // Register Write Logic
    // Only essential registers needed for polling-based operation
    //=======================================================
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            ctrl_q          <= 32'h0;
            fifo_ctrl_q     <= 32'h0;
            timeout_ctrl_q  <= 32'h0;
            wdata_q         <= 8'h0;    //Reset write data storage
            wdata_qe        <= 1'b0;    // Reset write enable
        end else begin
            // Default clear wdata_qe after one cycle
            wdata_qe <= 1'b0;
            
            if (wen_i) begin
                case (addr_i)
                    UART_CTRL_OFFSET: begin
                    // Control register: baud rate, enable TX/RX, parity, etc.
                        ctrl_q <= wdata_i;
                    end
                    
                    UART_FIFO_CTRL_OFFSET: begin
                        // FIFO control: watermark levels, reset FIFOs
                        fifo_ctrl_q <= wdata_i;
                    end
                    
                    UART_WDATA_OFFSET: begin
                        // Store write data and assert qe
                        wdata_q  <= wdata_i[7:0];
                        wdata_qe <= 1'b1;
                    end
                    
                    UART_TIMEOUT_CTRL_OFFSET: begin
                        timeout_ctrl_q <= wdata_i;
                    end
                    
                    default: begin
                        // Invalid address
                    end
                endcase
            end
        end
    end

    //=======================================================
    // Register Read Logic
    //=======================================================
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            rdata_o <= 32'h0;
            ready_o <= 1'b0;
        end else begin
            // Ready is high when transaction completes
            // For reads, data is available on the NEXT cycle
            // For writes, ready is asserted immediately
            ready_o <= ren_i | wen_i;
            
            if (ren_i) begin
                case (addr_i)
                    UART_CTRL_OFFSET: begin
                        rdata_o <= ctrl_q;
                    end
                    
                    UART_STATUS_OFFSET: begin
                    // Status register: FIFO empty/full flags, idle states
                        rdata_o <= {26'h0,
                                    hw2reg.status.rxempty.d,  // [5] RX FIFO empty
                                    hw2reg.status.rxidle.d,   // [4] RX idle
                                    hw2reg.status.txidle.d,   // [3] TX idle
                                    hw2reg.status.txempty.d,  // [2] TX FIFO empty
                                    hw2reg.status.rxfull.d,   // [1] RX FIFO full
                                    hw2reg.status.txfull.d};  // [0] TX FIFO full
                    end
                    
                    UART_RDATA_OFFSET: begin
                        rdata_o <= {24'h0, hw2reg.rdata.d};
                    end
                    
                    UART_FIFO_CTRL_OFFSET: begin
                        rdata_o <= fifo_ctrl_q;
                    end
                    
                    UART_FIFO_STATUS_OFFSET: begin
                        rdata_o <= {8'h0,
                                    hw2reg.fifo_status.rxlvl.d,
                                    hw2reg.fifo_status.txlvl.d};
                    end
                    
                    UART_VAL_OFFSET: begin
                        rdata_o <= {16'h0, hw2reg.val.d};
                    end
                    
                    UART_TIMEOUT_CTRL_OFFSET: begin
                        rdata_o <= timeout_ctrl_q;
                    end
                    
                    default: begin
                        rdata_o <= 32'hDEADBEEF;
                    end
                endcase
            end
        end
    end

    //=======================================================
    // Configuration to UART Core
    //=======================================================
    // assign reg2hw.ctrl.tx.q         = ctrl_q[0];
    // assign reg2hw.ctrl.rx.q         = ctrl_q[1];
    // assign reg2hw.ctrl.nf.q         = ctrl_q[2];
    // assign reg2hw.ctrl.slpbk.q      = ctrl_q[4];
    // assign reg2hw.ctrl.llpbk.q      = ctrl_q[5];
    // assign reg2hw.ctrl.parity_en.q  = ctrl_q[6];
    // assign reg2hw.ctrl.parity_odd.q = ctrl_q[7];
    // assign reg2hw.ctrl.rxblvl.q     = ctrl_q[9:8];
    // assign reg2hw.ctrl.nco.q        = ctrl_q[31:16];

    // assign reg2hw.fifo_ctrl.rxrst.q   = fifo_ctrl_q[0];
    // assign reg2hw.fifo_ctrl.rxrst.qe  = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);
    // assign reg2hw.fifo_ctrl.txrst.q   = fifo_ctrl_q[1];
    // assign reg2hw.fifo_ctrl.txrst.qe  = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);
    // assign reg2hw.fifo_ctrl.rxilvl.q  = fifo_ctrl_q[4:2];
    // assign reg2hw.fifo_ctrl.rxilvl.qe = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);
    // assign reg2hw.fifo_ctrl.txilvl.q  = fifo_ctrl_q[7:5];
    // assign reg2hw.fifo_ctrl.txilvl.qe = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);

    // assign reg2hw.wdata.q  = wdata_q;
    // assign reg2hw.wdata.qe = wdata_qe;

    // assign reg2hw.rdata.re = ren_i && (addr_i == UART_RDATA_OFFSET);

    // assign reg2hw.status.txfull.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
    // assign reg2hw.status.rxfull.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
    // assign reg2hw.status.txempty.re = ren_i && (addr_i == UART_STATUS_OFFSET);
    // assign reg2hw.status.txidle.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
    // assign reg2hw.status.rxidle.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
    // assign reg2hw.status.rxempty.re = ren_i && (addr_i == UART_STATUS_OFFSET);

    // assign reg2hw.ovrd.txen.q  = '0;
    // assign reg2hw.ovrd.txval.q = '1;
    
    // assign reg2hw.timeout_ctrl.en.q  = timeout_ctrl_q[31];
    // assign reg2hw.timeout_ctrl.val.q = timeout_ctrl_q[23:0];

    //=======================================================
    // Tie Off Unused Signals
    //=======================================================
    // assign reg2hw.intr_enable = '0;
    // assign reg2hw.intr_state  = '0;
    // assign reg2hw.intr_test   = '0;
    // assign reg2hw.alert_test  = '0;
    
    // assign reg2hw.status.txfull.q  = '0;
    // assign reg2hw.status.rxfull.q  = '0;
    // assign reg2hw.status.txempty.q = '0;
    // assign reg2hw.status.txidle.q  = '0;
    // assign reg2hw.status.rxidle.q  = '0;
    // assign reg2hw.status.rxempty.q = '0;

    always_comb begin
	reg2hw = '0;
        reg2hw.ctrl.tx.q         = ctrl_q[0];
        reg2hw.ctrl.rx.q         = ctrl_q[1];
        reg2hw.ctrl.nf.q         = ctrl_q[2];
        reg2hw.ctrl.slpbk.q      = ctrl_q[4];
        reg2hw.ctrl.llpbk.q      = ctrl_q[5];
        reg2hw.ctrl.parity_en.q  = ctrl_q[6];
        reg2hw.ctrl.parity_odd.q = ctrl_q[7];
        reg2hw.ctrl.rxblvl.q     = ctrl_q[9:8];
        reg2hw.ctrl.nco.q        = ctrl_q[31:16];

        reg2hw.fifo_ctrl.rxrst.q   = fifo_ctrl_q[0];
        reg2hw.fifo_ctrl.rxrst.qe  = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);
        reg2hw.fifo_ctrl.txrst.q   = fifo_ctrl_q[1];
        reg2hw.fifo_ctrl.txrst.qe  = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);
        reg2hw.fifo_ctrl.rxilvl.q  = fifo_ctrl_q[4:2];
        reg2hw.fifo_ctrl.rxilvl.qe = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);
        reg2hw.fifo_ctrl.txilvl.q  = fifo_ctrl_q[7:5];
        reg2hw.fifo_ctrl.txilvl.qe = wen_i && (addr_i == UART_FIFO_CTRL_OFFSET);

        reg2hw.wdata.q  = wdata_q;
        reg2hw.wdata.qe = wdata_qe;

        reg2hw.rdata.re = ren_i && (addr_i == UART_RDATA_OFFSET);

        reg2hw.status.txfull.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
        reg2hw.status.rxfull.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
        reg2hw.status.txempty.re = ren_i && (addr_i == UART_STATUS_OFFSET);
        reg2hw.status.txidle.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
        reg2hw.status.rxidle.re  = ren_i && (addr_i == UART_STATUS_OFFSET);
        reg2hw.status.rxempty.re = ren_i && (addr_i == UART_STATUS_OFFSET);

        reg2hw.ovrd.txen.q  = '0;
        reg2hw.ovrd.txval.q = '1;
    
        reg2hw.timeout_ctrl.en.q  = timeout_ctrl_q[31];
        reg2hw.timeout_ctrl.val.q = timeout_ctrl_q[23:0];

    end

endmodule
