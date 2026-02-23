// i2c_reg_top.sv - Exposes all I2C registers defined in i2c_reg_pkg
// Minimal MMIO-style register interface
// Updated: Exposed scl/sda direction signals for chip integration

module i2c_reg_top 
    import i2c_reg_pkg::*;
(
    input  logic                        clk,
    input  logic                        rst_n,       
    // Exposed MMIO bus
    input  logic [i2c_reg_pkg::BlockAw-1:0] bus_addr,
    input  logic [31:0]                 wdata_i,
    input  logic                        wen_i,
    input  logic                        ren_i,
    output logic [31:0]                 rdata_o,       
    // Connection to registers
    output i2c_reg_pkg::i2c_reg2hw_t    reg2hw,
    output i2c_reg_pkg::i2c_hw2reg_t    hw2reg,
    
    // I2C pins - directly directly-driven for chip integration
    input  logic        scl_i,      // SCL input
    output logic        scl_o,      // SCL output value
    output logic        scl_oe,     // SCL output enable (directly actively-driven low)
    input  logic        sda_i,      // SDA input
    output logic        sda_o,      // SDA output value  
    output logic        sda_oe      // SDA output enable (directly actively-driven low)
);

    // Internal signals from i2c_core
    logic scl_o_int;
    logic sda_o_int;
    logic hold_nack_event;
    logic hold_arbitration_lost;
    logic fdata_qe;

    // Open-drain output logi:
    // scl_o_int = 0 means drive low, scl_o_int = 1 means release
    // For chip integration:
    //   scl_o = 0 (always drive low when enabled)
    //   scl_oe = 1 when scl_o_int = 0 (drive low)
    //   scl_oe = 0 when scl_o_int = 1 (release/high-Z)
    assign scl_o  = 1'b0;
    assign scl_oe = ~scl_o_int;
    assign sda_o  = 1'b0;
    assign sda_oe = ~sda_o_int;

    // (REG-HW)
    logic [6:0] i2c_ctrl_q;
    
    // STATUS signals from hardware
    logic [4:0]     controller_status;
    logic [7:0]     controller_rdata;
    logic [3:0]     controller_events;

    //------------------------------------- 
    // Register Write & Read Logic 
    //-------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i2c_ctrl_q <= '0;
            hold_nack_event <= 1'b0;
            hold_arbitration_lost <= 1'b0;
            rdata_o <= '0;
        end else begin
            if (wen_i) begin
                case (bus_addr)
                    I2C_CTRL_OFFSET: i2c_ctrl_q <= wdata_i[6:0];
                endcase
            end else if (ren_i) begin
                case (bus_addr)
                    I2C_STATUS_OFFSET: rdata_o[4:0] <= controller_status;
                    I2C_RDATA_O_OFFSET: rdata_o[7:0] <= controller_rdata;
                    I2C_CONTROLLER_EVENTS_OFFSET: rdata_o[3:0] <= controller_events;           
                endcase
            end

            if (wen_i) hold_nack_event <= 1'b0;
            if (!hold_nack_event) hold_nack_event <= hw2reg.controller_events.nack.de;

            if (wen_i) hold_arbitration_lost <= 1'b0;
            if (!hold_arbitration_lost) hold_arbitration_lost <= hw2reg.controller_events.arbitration_lost.de;
        end
    end

    //-------------------------------------
    // Register (reg2hw) mapping (software → hardware)
    //-------------------------------------
    assign reg2hw.ctrl.enablehost.q                = i2c_ctrl_q[0];
    assign reg2hw.ctrl.ack_ctrl_en.q               = i2c_ctrl_q[1];
    assign reg2hw.ctrl.nack_addr_after_timeout.q   = i2c_ctrl_q[2];
    assign reg2hw.ctrl.multi_controller_monitor_en.q = i2c_ctrl_q[3];
    assign reg2hw.ctrl.enabletarget.q              = i2c_ctrl_q[4];
    assign reg2hw.ctrl.llpbk.q                     = i2c_ctrl_q[5];
    assign reg2hw.ctrl.tx_stretch_ctrl_en.q        = i2c_ctrl_q[6];

    // RDATA_I
    assign reg2hw.rdata.q = (ren_i && (bus_addr == I2C_RDATA_O_OFFSET)) ? controller_rdata : 8'b0;
    assign reg2hw.rdata.re = (!hw2reg.status.rxempty.d) && ren_i && (bus_addr == I2C_RDATA_O_OFFSET);

    // FDATA (FMT Fifo)
    assign fdata_qe = (!hw2reg.status.fmtfull.d) && wen_i && (bus_addr == I2C_FDATA_OFFSET);
    assign reg2hw.fdata.fbyte.q   = wdata_i[7:0];
    assign reg2hw.fdata.fbyte.qe  = fdata_qe;
    assign reg2hw.fdata.start.q   = wdata_i[8];
    assign reg2hw.fdata.start.qe  = fdata_qe;
    assign reg2hw.fdata.stop.q    = wdata_i[9];
    assign reg2hw.fdata.stop.qe   = fdata_qe;
    assign reg2hw.fdata.readb.q   = wdata_i[10];
    assign reg2hw.fdata.readb.qe  = fdata_qe;
    assign reg2hw.fdata.rcont.q   = wdata_i[11];
    assign reg2hw.fdata.rcont.qe  = fdata_qe;
    assign reg2hw.fdata.nakok.q   = wdata_i[12];
    assign reg2hw.fdata.nakok.qe  = fdata_qe;

    // FIFO_CTRL (Reset)
    assign reg2hw.fifo_ctrl.fmtrst.q  = 1'b1;
    assign reg2hw.fifo_ctrl.fmtrst.qe = wen_i && (bus_addr == I2C_FIFO_CTRL_OFFSET);
    assign reg2hw.fifo_ctrl.rxrst.q   = 1'b1;
    assign reg2hw.fifo_ctrl.rxrst.qe  = wen_i && (bus_addr == I2C_FIFO_CTRL_OFFSET);

    // TIMING
    assign reg2hw.timing0.tlow.q   = (wen_i && (bus_addr == I2C_TIMING0_OFFSET)) ? wdata_i[12:0] : reg2hw.timing0.tlow.q;
    assign reg2hw.timing0.thigh.q  = (wen_i && (bus_addr == I2C_TIMING0_OFFSET)) ? wdata_i[25:13] : reg2hw.timing0.thigh.q;
    assign reg2hw.timing1.t_r.q    = (wen_i && (bus_addr == I2C_TIMING1_OFFSET)) ? wdata_i[12:0] : reg2hw.timing1.t_r.q;
    assign reg2hw.timing1.t_f.q    = (wen_i && (bus_addr == I2C_TIMING1_OFFSET)) ? wdata_i[25:13] : reg2hw.timing1.t_f.q;
    assign reg2hw.timing2.tsu_sta.q = (wen_i && (bus_addr == I2C_TIMING2_OFFSET)) ? wdata_i[12:0] : reg2hw.timing2.tsu_sta.q;
    assign reg2hw.timing2.thd_sta.q = (wen_i && (bus_addr == I2C_TIMING2_OFFSET)) ? wdata_i[25:13] : reg2hw.timing2.thd_sta.q;
    assign reg2hw.timing3.tsu_dat.q = (wen_i && (bus_addr == I2C_TIMING3_OFFSET)) ? wdata_i[12:0] : reg2hw.timing3.tsu_dat.q;
    assign reg2hw.timing3.thd_dat.q = (wen_i && (bus_addr == I2C_TIMING3_OFFSET)) ? wdata_i[25:13] : reg2hw.timing3.thd_dat.q;
    assign reg2hw.timing4.tsu_sto.q = (wen_i && (bus_addr == I2C_TIMING4_OFFSET)) ? wdata_i[12:0] : reg2hw.timing4.tsu_sto.q;
    assign reg2hw.timing4.t_buf.q  = (wen_i && (bus_addr == I2C_TIMING4_OFFSET)) ? wdata_i[25:13] : reg2hw.timing4.t_buf.q;

    // TIMEOUT_CTRL
    assign reg2hw.timeout_ctrl.en.q   = (wen_i && (bus_addr == I2C_TIMEOUT_CTRL_OFFSET)) ? wdata_i[0] : reg2hw.timeout_ctrl.en.q;
    assign reg2hw.timeout_ctrl.mode.q = (wen_i && (bus_addr == I2C_TIMEOUT_CTRL_OFFSET)) ? wdata_i[1] : reg2hw.timeout_ctrl.mode.q;
    assign reg2hw.timeout_ctrl.val.q = (wen_i && (bus_addr == I2C_TIMEOUT_CTRL_OFFSET)) ? wdata_i[31:2] : reg2hw.timeout_ctrl.val.q;

    //--------------------------------------
    //  Hardware (hw2reg) mapping (hardware → software)
    //--------------------------------------
    assign controller_status[0] = hw2reg.status.rxempty.d;
    assign controller_status[1] = hw2reg.status.hostidle.d;
    assign controller_status[2] = hw2reg.status.fmtempty.d;
    assign controller_status[3] = hw2reg.status.rxfull.d;
    assign controller_status[4] = hw2reg.status.fmtfull.d;

    assign controller_rdata = hw2reg.rdata.d;

    assign controller_events[0] = hold_arbitration_lost;
    assign controller_events[1] = hw2reg.controller_events.arbitration_lost.de;
    assign controller_events[2] = hold_nack_event;
    assign controller_events[3] = hw2reg.controller_events.nack.de;

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
    );
        
endmodule