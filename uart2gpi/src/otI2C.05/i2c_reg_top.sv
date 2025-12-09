// i2c_reg_top.sv - Exposes all I2C registers defined in i2c_reg_pkg
// Minimal MMIO-style register interface

`timescale 1ns/1ps
// `include "i2c_reg_pkg.sv"
  import i2c_reg_pkg::*;


module i2c_reg_top (
        input  logic                   clk,
        input  logic                   rst_n,       
        // Exposed MMIO bus
        input  logic [i2c_reg_pkg::BlockAw-1:0] bus_addr,
        input  logic [31:0]            wdata_i,
        input  logic                   wen_i,
        input  logic                   ren_i,
        output logic [31:0]            rdata_o,       
        // Connection to registers
        output i2c_reg_pkg::i2c_reg2hw_t reg2hw,
        output i2c_reg_pkg::i2c_hw2reg_t hw2reg,

        input  logic        scl_i,
        output logic        scl_o,
        output logic        scl_oe,
        input  logic        sda_i,
        output logic        sda_o,
        output logic        sda_oe

        // inout   tri             scl,
        // inout   tri             sda
);

        //import i2c_reg_pkg::*;

        // I/o for Global Foundry & Tiny Tapout
        // logic           scl_i, scl_o;
        // logic           sda_i, sda_o;
        // logic           scl_oe;
        // logic           sda_oe;

        // Internal signals from i2c_core
        logic scl_o_int;
        logic sda_o_int;


        // Flags
        logic           hold_nack_event;      // Hold nack that slave sent for a while until there is a write from software (That is, if software never read it, clear it)
        logic           hold_arbitration_lost;
        logic           hold_unhandled_nack_timeout;
        logic           fdata_qe;

        // Bidirectional I/O
        // assign  scl = (scl_o == 1'b0) ? 1'b0 : 1'bz;
        // assign  sda = (sda_o == 1'b0) ? 1'b0 : 1'bz;
        // assign  scl_i = scl;
        // assign  sda_i = sda;

        // assign  scl_oe = ~scl_o;
        // assign  sda_oe = ~sda_o;

        assign scl_o  = 1'b0;
        assign scl_oe = ~scl_o_int;
        assign sda_o  = 1'b0;
        assign sda_oe = ~sda_o_int;

        // (REG-HW)
        logic [6:0] i2c_ctrl_q;
        
        // I2C_FDATA_OFFSET             -->  fmt_data [7:0] , start[8] , stop [9] , readb [10] , rcont [11] , nanok[12]
        // I2C_FIFO_CTRL_OFFSET         -->  [1] fmt_reset [0], [0] rx_reset
        // I2C_TIMING0_OFFSET           -->  Timing_0 (rise)[12:0] , Timing_0 (fall)[25:13]         SCL Timing
        // I2C_TIMING1_OFFSET           -->  Timing_1 (rise)[12:0] , Timing_1 (fall)[25:13]         Time Compensation (For slow hardware, to catch up with transmision)
        // I2C_TIMING2_OFFSET           -->  Timing_2 (start)[12:0] , Timing_2 (hold start)[25:13]        Start Timing
        // I2C_TIMING3_OFFSET           -->  Timing_3 (data setup)[12:0] , Timing_0 (data hold)[25:13]          Data Timing
        // I2C_TIMING4_OFFSET           -->  Timing_0 (stop)[12:0] , Timing_0 (bus)[25:13]              Stop & Bus free Timing
        // I2C_TIMEOUT_CTRL_OFFSET      -->  Clock stretching on/off [0] , Mode (Should be 0 if user wants to enable Clock stretching) [1] , Max time for Clock stretching [31:2]
        // I2C_HOST_NACK_HANDLER_TIMEOUT_OFFSET -->  Host Timeout for Un-handled nacks

        // (HW-REG)
        logic [31:0]     controller_status;      // [5] rxempty, [3] hostidle, [2] fmtempty, [1] rxfull, [0] fmtfull
        logic [31:0]     controller_rdata;       // Pop & collect Rx fifo data [7:0]
        logic [31:0]     host_fifo_status;      // [11:0] fmt_fifo level , [27:16] rx_fifo level
        logic [31:0]     controller_events;      // [0] Nack received!, from Slave (Holds 1 until user decides not to read it, but write to otI2C) [1] Unhandled nack timeout
                                                // [2] Bus timeout , [3] Host arbitration lost (Holds 1 until user decides not to read it, but write to otI2C),

        logic   prev_hold_nack_event;
        logic   prev_hold_arbitration_lost;
        logic   prev_hold_unhandled_nack_timeout;


        //------------------------------------- 
        // Register Write & Read Logic 
        //-------------------------------------
        always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                        // Reset registers.
                        i2c_ctrl_q <= '0;
                        hold_nack_event <= 1'b0;
                        hold_arbitration_lost <= 1'b0;
                        hold_unhandled_nack_timeout <= 1'b0;
                        prev_hold_nack_event <= 1'b0;
                        prev_hold_arbitration_lost <= 1'b0;
                        prev_hold_unhandled_nack_timeout <= 1'b0;
                        rdata_o <= 0;

                end else begin
                        if (wen_i) begin
                                // Write operations.
                                case (bus_addr)
                                        I2C_CTRL_OFFSET: i2c_ctrl_q <= wdata_i[6:0];
                                endcase

                        end else if (ren_i) begin
                                // Read operations.
                                case (bus_addr)
                                        I2C_STATUS_OFFSET: rdata_o <= controller_status;
                                        I2C_RDATA_OFFSET: rdata_o <= controller_rdata;
                                        I2C_HOST_FIFO_STATUS_OFFSET: rdata_o <= host_fifo_status;
                                        I2C_CONTROLLER_EVENTS_OFFSET: begin
                                                hold_nack_event         <= 1'b0;
                                                hold_arbitration_lost   <= 1'b0;
                                                hold_unhandled_nack_timeout <= 1'b0;
                                                rdata_o <= controller_events;
                                        end
                                        default: rdata_o <= '0;
                                endcase

                        end else begin
                                if (!hold_nack_event) hold_nack_event                 <= hw2reg.controller_events.nack.de;
                                if (!hold_arbitration_lost) hold_arbitration_lost           <= hw2reg.controller_events.arbitration_lost.de;
                                if (!hold_unhandled_nack_timeout) hold_unhandled_nack_timeout     <= hw2reg.controller_events.unhandled_nack_timeout.de;

                                prev_hold_nack_event    <= hold_nack_event;
                                prev_hold_arbitration_lost      <= hold_arbitration_lost;
                                prev_hold_unhandled_nack_timeout<= hold_unhandled_nack_timeout;
                        end
                end
        end


        //-------------------------------------
        // Register (reg2hw) mapping (software → hardware)
        //-------------------------------------
        // CTRL
        assign reg2hw.ctrl.enablehost.q                = i2c_ctrl_q[0];         // 1 Enable Master
        assign reg2hw.ctrl.enabletarget.q              = i2c_ctrl_q[1];
        assign reg2hw.ctrl.llpbk.q                     = i2c_ctrl_q[2];
        assign reg2hw.ctrl.nack_addr_after_timeout.q   = i2c_ctrl_q[3];         // 1 Enable Nack after timeout
        assign reg2hw.ctrl.ack_ctrl_en.q               = i2c_ctrl_q[4];         // 1 Enable ack ctrl
        assign reg2hw.ctrl.multi_controller_monitor_en.q = i2c_ctrl_q[5];
        assign reg2hw.ctrl.tx_stretch_ctrl_en.q        = i2c_ctrl_q[6];

        // RDATA
        assign reg2hw.rdata.q = (ren_i && (bus_addr == I2C_RDATA_OFFSET)) ? controller_rdata : 8'b0;
        assign reg2hw.rdata.re = (!hw2reg.status.rxempty.d) && ren_i && (bus_addr == I2C_RDATA_OFFSET);

        // FDATA (FMT Fifo)
        assign fdata_qe = (!hw2reg.status.fmtfull.d) && wen_i && (bus_addr == I2C_FDATA_OFFSET);
        assign reg2hw.fdata.fbyte.q   = wdata_i[7:0];   // Byte
        assign reg2hw.fdata.fbyte.qe  = fdata_qe;
        assign reg2hw.fdata.start.q   = wdata_i[8];     // Start
        assign reg2hw.fdata.start.qe  = fdata_qe;
        assign reg2hw.fdata.stop.q    = wdata_i[9];     // Stop
        assign reg2hw.fdata.stop.qe   = fdata_qe;
        assign reg2hw.fdata.readb.q   = wdata_i[10];    // Read from Slave mode
        assign reg2hw.fdata.readb.qe  = fdata_qe;
        assign reg2hw.fdata.rcont.q   = wdata_i[11];
        assign reg2hw.fdata.rcont.qe  = fdata_qe;
        assign reg2hw.fdata.nakok.q   = wdata_i[12];    // Nack from slave on this fifo entry (when transmitted) is acceptable (only for this one byte)
        assign reg2hw.fdata.nakok.qe  = fdata_qe;

        // FIFO_CTRL (Reset)
        assign reg2hw.fifo_ctrl.fmtrst.q  = 1'b1;       // FIFO's are only reset when their register offset (I2C_FIFO_CTRL_OFFSET) is called with (wen_i)
        assign reg2hw.fifo_ctrl.fmtrst.qe = wdata_i[1] && wen_i && (bus_addr == I2C_FIFO_CTRL_OFFSET);
        assign reg2hw.fifo_ctrl.rxrst.q   = 1'b1;
        assign reg2hw.fifo_ctrl.rxrst.qe  = wdata_i[0] && wen_i && (bus_addr == I2C_FIFO_CTRL_OFFSET);

        // TIMING
        assign reg2hw.timing0.tlow.q   = (wen_i && (bus_addr == I2C_TIMING0_OFFSET)) ? wdata_i[12:0] : reg2hw.timing0.tlow.q;           // Timing 0 
        assign reg2hw.timing0.thigh.q  = (wen_i && (bus_addr == I2C_TIMING0_OFFSET)) ? wdata_i[28:16] : reg2hw.timing0.thigh.q;
        assign reg2hw.timing1.t_r.q    = (wen_i && (bus_addr == I2C_TIMING1_OFFSET)) ? wdata_i[9:0] : reg2hw.timing1.t_r.q;            // Timing 1
        assign reg2hw.timing1.t_f.q    = (wen_i && (bus_addr == I2C_TIMING1_OFFSET)) ? wdata_i[24:16] : reg2hw.timing1.t_f.q;
        assign reg2hw.timing2.tsu_sta.q = (wen_i && (bus_addr == I2C_TIMING2_OFFSET)) ? wdata_i[12:0] : reg2hw.timing2.tsu_sta.q;       // Timing 2
        assign reg2hw.timing2.thd_sta.q = (wen_i && (bus_addr == I2C_TIMING2_OFFSET)) ? wdata_i[28:16] : reg2hw.timing2.thd_sta.q;
        assign reg2hw.timing3.tsu_dat.q = (wen_i && (bus_addr == I2C_TIMING3_OFFSET)) ? wdata_i[8:0] : reg2hw.timing3.tsu_dat.q;       // Timing 3
        assign reg2hw.timing3.thd_dat.q = (wen_i && (bus_addr == I2C_TIMING3_OFFSET)) ? wdata_i[28:16] : reg2hw.timing3.thd_dat.q;
        assign reg2hw.timing4.tsu_sto.q = (wen_i && (bus_addr == I2C_TIMING4_OFFSET)) ? wdata_i[12:0] : reg2hw.timing4.tsu_sto.q;       // Timing 4
        assign reg2hw.timing4.t_buf.q  = (wen_i && (bus_addr == I2C_TIMING4_OFFSET)) ? wdata_i[28:16] : reg2hw.timing4.t_buf.q;

        // TIMEOUT_CTRL (Clock-stretching)
        assign reg2hw.timeout_ctrl.en.q   = (wen_i && (bus_addr == I2C_TIMEOUT_CTRL_OFFSET)) ? wdata_i[31] : reg2hw.timeout_ctrl.en.q;   // Clock-stretching on/off
        assign reg2hw.timeout_ctrl.mode.q = (wen_i && (bus_addr == I2C_TIMEOUT_CTRL_OFFSET)) ? wdata_i[30] : reg2hw.timeout_ctrl.mode.q;
        assign reg2hw.timeout_ctrl.val.q = (wen_i && (bus_addr == I2C_TIMEOUT_CTRL_OFFSET)) ? wdata_i[29:0] : reg2hw.timeout_ctrl.val.q; // Clock-stretching value

        // HOST NACK TIMEOUT
        assign reg2hw.host_nack_handler_timeout.en.q  = (wen_i && (bus_addr == I2C_HOST_NACK_HANDLER_TIMEOUT_OFFSET)) ? wdata_i[31]  : reg2hw.host_nack_handler_timeout.en.q;
        assign reg2hw.host_nack_handler_timeout.val.q = (wen_i && (bus_addr == I2C_HOST_NACK_HANDLER_TIMEOUT_OFFSET)) ? wdata_i[30:0] : reg2hw.host_nack_handler_timeout.val.q;


        //--------------------------------------
        //  Hardware (hw2reg) mapping (hardware → software)
        //--------------------------------------
        // STATUS
        assign controller_status[5] = hw2reg.status.rxempty.d;
        assign controller_status[3] = hw2reg.status.hostidle.d;
        assign controller_status[2] = hw2reg.status.fmtempty.d;
        assign controller_status[1] = hw2reg.status.rxfull.d;
        assign controller_status[0] = hw2reg.status.fmtfull.d;
        assign controller_status[31:6] = '0;
        assign controller_status[4] = 1'b0;

        // RDATA_O
        assign controller_rdata[7:0] = hw2reg.rdata.d;
        assign controller_rdata[31:8] = '0;

        // FIFO LEVELS
        assign host_fifo_status[31:28] = '0;
        assign host_fifo_status[27:16] = hw2reg.host_fifo_status.rxlvl.d;       // RX Level
        assign host_fifo_status[15:12] = '0;
        assign host_fifo_status[11:0] = hw2reg.host_fifo_status.fmtlvl.d;       // FMT Level

        // CONTROLLER_EVENTS
        assign controller_events[3] = prev_hold_arbitration_lost;
        assign controller_events[2] = hw2reg.controller_events.bus_timeout.de;
        assign controller_events[1] = prev_hold_unhandled_nack_timeout;
        assign controller_events[0] = prev_hold_nack_event;
        assign controller_events[31:4] = '0;


        // Core instantiation
        i2c_core u_i2c_core (
                .clk_i(clk),
                .rst_ni(rst_n),

                .reg2hw(reg2hw),
                .hw2reg(hw2reg),

                .scl_i(scl_i),
                .scl_o(scl_o_int),
                .sda_i(sda_i),
                .sda_o(sda_o_int)

                // .scl_i(scl_i),
                // .scl_o(scl_o),
                // .sda_i(sda_i),
                // .sda_o(sda_o)
        );
        
endmodule
