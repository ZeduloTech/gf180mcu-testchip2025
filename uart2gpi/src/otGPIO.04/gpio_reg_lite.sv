// Lightweight GPIO register block (no TL-UL, no RACL, no prim_*).
// Keeps OpenTitan gpio_reg_pkg types and offsets so gpio.sv works unchanged.

//`ifndef GPIO_REG_TOP_LITE_SV
//`define GPIO_REG_TOP_LITE_SV
//`include "gpio_reg_pkg.sv"
//import gpio_reg_pkg::*;

module gpio_reg_lite
  import gpio_reg_pkg::*;
#(
  // Byte address width; OpenTitan GPIO uses 7 bits (0x00..0x7C)
  parameter int unsigned AW = 7
) (
  input  logic                   clk_i,
  input  logic                   rst_ni,

  // Tiny, single-cycle, ready-always bus
  input  logic                   reg_we,     // write strobe (1-cycle)
  input  logic                   reg_re,     // read  strobe (1-cycle)
  input  logic [AW-1:0]          reg_addr,   // byte address (use GPIO_*_OFFSET)
  input  logic [31:0]            reg_wdata,
  input  logic [3:0]             reg_be,     // byte enables (optional; accepted, not checked)
  output logic [31:0]            reg_rdata,
  output logic                   reg_error,  // 1 on address miss (can tie 0 if you prefer)

  // To/From core (same structs as original)
  output gpio_reg2hw_t           reg2hw,  // SW-visible config to HW
  input  gpio_hw2reg_t           hw2reg   // HW-updated RO/W1C fields
);



  // -------------------------
  // Default bus behavior
  // -------------------------
  logic addr_hit;

  // We’ll compute addr_hit in the read mux; bus is ready-always
  // (No wait-states; return 0xFFFF_FFFF on miss and raise bus_error)
  assign reg_error = (reg_re || reg_we) ? ~addr_hit : 1'b0;

  // -------------------------
  // Storage for RW/RO regs (QS)
  // -------------------------
  // W1C: intr_state (set by HW via hw2reg, cleared by SW writes)
  logic [31:0] r_intr_state_q;

  // RW: intr_enable
  logic [31:0] r_intr_enable_q;

  // WO-pulse: intr_test (no retained state needed; keep last for readback=0 per orig)
  // We just generate pulses.

  // WO-pulse: alert_test[0]
  // We just generate pulses.

  // RO: data_in (captured when hw2reg.data_in.de)
  logic [31:0] r_data_in_q;

  // RW/WO+rdback: direct_out
  logic [31:0] r_direct_out_q;

  // Masked_out_{lower,upper} readback (data only; mask readback is 0 for lower/upper per orig)
  logic [15:0] r_mo_lower_data_q, r_mo_upper_data_q;

  // RW/WO+rdback: direct_oe
  logic [31:0] r_direct_oe_q;

  // Masked_oe_{lower,upper} readback (both data and mask visible on read)
  logic [15:0] r_moe_lower_data_q, r_moe_lower_mask_q;
  logic [15:0] r_moe_upper_data_q, r_moe_upper_mask_q;

  // RW: intr_ctrl_en_* and ctrl_en_input_filter
  logic [31:0] r_intr_en_rise_q, r_intr_en_fall_q, r_intr_en_lvlhigh_q, r_intr_en_lvllow_q;
  logic [31:0] r_ctrl_en_input_filter_q;

  // RO: straps
  logic        r_hw_straps_valid_q;
  logic [31:0] r_hw_straps_data_q;

  // -------------------------
  // One-cycle QE pulses for *_ext-style regs used by gpio.sv
  // -------------------------
  logic p_direct_out_qe;
  logic p_masked_out_lower_qe, p_masked_out_upper_qe;
  logic p_direct_oe_qe;
  logic p_masked_oe_lower_qe, p_masked_oe_upper_qe;
  logic p_intr_test_qe;
  logic p_alert_test_qe;

//  // Default pulses low each cycle
//  always_ff @(posedge clk_i or negedge rst_ni) begin
//    if (!rst_ni) begin
//      p_direct_out_qe       <= 1'b0;
//      p_masked_out_lower_qe <= 1'b0;
//      p_masked_out_upper_qe <= 1'b0;
//      p_direct_oe_qe        <= 1'b0;
//      p_masked_oe_lower_qe  <= 1'b0;
//      p_masked_oe_upper_qe  <= 1'b0;
//      p_intr_test_qe        <= 1'b0;
//      p_alert_test_qe       <= 1'b0;
//    end //else begin
////      p_direct_out_qe       <= 1'b0;
////      p_masked_out_lower_qe <= 1'b0;
////      p_masked_out_upper_qe <= 1'b0;
////      p_direct_oe_qe        <= 1'b0;
////      p_masked_oe_lower_qe  <= 1'b0;
////      p_masked_oe_upper_qe  <= 1'b0;
////      p_intr_test_qe        <= 1'b0;
////      p_alert_test_qe       <= 1'b0;
////
////      // Pulses will be asserted in write logic below on address hit
////    end
//  end


// -------------------------
// Separate Pulse Generation Logic
// -------------------------
always_ff @(posedge clk_i or negedge rst_ni) begin
  if (!rst_ni) begin
    p_direct_out_qe       <= 1'b0;
    p_masked_out_lower_qe <= 1'b0;
    p_masked_out_upper_qe <= 1'b0;
    p_direct_oe_qe        <= 1'b0;
    p_masked_oe_lower_qe  <= 1'b0;
    p_masked_oe_upper_qe  <= 1'b0;
    p_intr_test_qe        <= 1'b0;
    p_alert_test_qe       <= 1'b0;
  end else begin
    // Default: clear all pulses every cycle
    p_direct_out_qe       <= 1'b0;
    p_masked_out_lower_qe <= 1'b0;
    p_masked_out_upper_qe <= 1'b0;
    p_direct_oe_qe        <= 1'b0;
    p_masked_oe_lower_qe  <= 1'b0;
    p_masked_oe_upper_qe  <= 1'b0;
    p_intr_test_qe        <= 1'b0;
    p_alert_test_qe       <= 1'b0;
    
    // Assert pulses for one cycle on SW writes
    if (reg_we) begin
      case (reg_addr)
        GPIO_INTR_TEST_OFFSET:           p_intr_test_qe        <= 1'b1;
        GPIO_ALERT_TEST_OFFSET:          p_alert_test_qe       <= 1'b1;
        GPIO_DIRECT_OUT_OFFSET:          p_direct_out_qe       <= 1'b1;
        GPIO_MASKED_OUT_LOWER_OFFSET:    p_masked_out_lower_qe <= 1'b1;
        GPIO_MASKED_OUT_UPPER_OFFSET:    p_masked_out_upper_qe <= 1'b1;
        GPIO_DIRECT_OE_OFFSET:           p_direct_oe_qe        <= 1'b1;
        GPIO_MASKED_OE_LOWER_OFFSET:     p_masked_oe_lower_qe  <= 1'b1;
        GPIO_MASKED_OE_UPPER_OFFSET:     p_masked_oe_upper_qe  <= 1'b1;
        //default: ;  // Other writes don't generate pulses
      endcase
    end
  end
end




  // -------------------------
  // Reset & HW-updates
  // -------------------------
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      r_intr_state_q           <= '0;
      r_intr_enable_q          <= '0;

      r_data_in_q              <= '0;
      r_direct_out_q           <= '0;
      r_mo_lower_data_q        <= '0;
      r_mo_upper_data_q        <= '0;

      r_direct_oe_q            <= '0;
      r_moe_lower_data_q       <= '0;
      r_moe_lower_mask_q       <= '0;
      r_moe_upper_data_q       <= '0;
      r_moe_upper_mask_q       <= '0;

      r_intr_en_rise_q         <= '0;
      r_intr_en_fall_q         <= '0;
      r_intr_en_lvlhigh_q      <= '0;
      r_intr_en_lvllow_q       <= '0;
      r_ctrl_en_input_filter_q <= '0;

      r_hw_straps_valid_q      <= 1'b0;
      r_hw_straps_data_q       <= '0;
    end else begin
      // HW-driven fields
      if (hw2reg.intr_state.de)           r_intr_state_q      	<= hw2reg.intr_state.d;
      if (hw2reg.data_in.de)              r_data_in_q         	<= hw2reg.data_in.d;
      if (hw2reg.hw_straps_data_in_valid.de) r_hw_straps_valid_q <= hw2reg.hw_straps_data_in_valid.d;
      if (hw2reg.hw_straps_data_in.de)    r_hw_straps_data_q  	<= hw2reg.hw_straps_data_in.d;
      // SW writes below
    //end
  //end

  // -------------------------
  // SW Write logic (W1C / RW / WO-pulse)
  // -------------------------
  // Address decoding and state updates
  //always_ff @(posedge clk_i) begin
    if (reg_we) begin			//rst_ni && 
      unique case (reg_addr) 
        GPIO_INTR_STATE_OFFSET: begin
          // W1C: write 1 clears corresponding bits
          //r_intr_state_q <= r_intr_state_q & ~reg_wdata;
			 if (!hw2reg.intr_state.de)  // Only if HW not updating
            r_intr_state_q <= r_intr_state_q & ~reg_wdata;
			 //end
        end

        GPIO_INTR_ENABLE_OFFSET: begin
          r_intr_enable_q <= reg_wdata;
        end

        GPIO_INTR_TEST_OFFSET: begin
          // Pulse semantics: drive q + qe for one cycle to core
          //p_intr_test_qe <= 1'b1;
        end

        GPIO_ALERT_TEST_OFFSET: begin
          // 1-bit pulse
          //p_alert_test_qe <= 1'b1;
        end

        GPIO_DIRECT_OUT_OFFSET: begin
          r_direct_out_q  <= reg_wdata;
          //p_direct_out_qe <= 1'b1;
        end

        GPIO_MASKED_OUT_LOWER_OFFSET: begin
          r_mo_lower_data_q  <= reg_wdata[15:0];
          // mask field is write-only path to core; we also expose via reg2hw
          //p_masked_out_lower_qe <= 1'b1;
        end

        GPIO_MASKED_OUT_UPPER_OFFSET: begin
          r_mo_upper_data_q  <= reg_wdata[15:0];
          //p_masked_out_upper_qe <= 1'b1;
        end

        GPIO_DIRECT_OE_OFFSET: begin
          r_direct_oe_q  <= reg_wdata;
          //p_direct_oe_qe <= 1'b1;
        end

        GPIO_MASKED_OE_LOWER_OFFSET: begin
          r_moe_lower_data_q <= reg_wdata[15:0];
          r_moe_lower_mask_q <= reg_wdata[31:16];
          //p_masked_oe_lower_qe <= 1'b1;
        end

        GPIO_MASKED_OE_UPPER_OFFSET: begin
          r_moe_upper_data_q <= reg_wdata[15:0];
          r_moe_upper_mask_q <= reg_wdata[31:16];
          //p_masked_oe_upper_qe <= 1'b1;
        end

        GPIO_INTR_CTRL_EN_RISING_OFFSET:  r_intr_en_rise_q    <= reg_wdata;
        GPIO_INTR_CTRL_EN_FALLING_OFFSET: r_intr_en_fall_q    <= reg_wdata;
        GPIO_INTR_CTRL_EN_LVLHIGH_OFFSET: r_intr_en_lvlhigh_q <= reg_wdata;
        GPIO_INTR_CTRL_EN_LVLLOW_OFFSET:  r_intr_en_lvllow_q  <= reg_wdata;

        GPIO_CTRL_EN_INPUT_FILTER_OFFSET: r_ctrl_en_input_filter_q <= reg_wdata;

        //default:
      endcase
    end
  end
 end   
  
  // -------------------------
  // Read mux (QS view)
  // -------------------------
  always_comb begin
    addr_hit = 1'b1;
    case (reg_addr)		//unique 
      GPIO_INTR_STATE_OFFSET:          reg_rdata = r_intr_state_q;
      GPIO_INTR_ENABLE_OFFSET:         reg_rdata = r_intr_enable_q;
      GPIO_INTR_TEST_OFFSET:           reg_rdata = 32'h0;                  // WO
      GPIO_ALERT_TEST_OFFSET:          reg_rdata = 32'h0;                  // WO
      GPIO_DATA_IN_OFFSET:             reg_rdata = r_data_in_q;            // RO
      GPIO_DIRECT_OUT_OFFSET:          reg_rdata = r_direct_out_q;         // RW
      GPIO_MASKED_OUT_LOWER_OFFSET:    reg_rdata = {16'h0000, r_mo_lower_data_q};
      GPIO_MASKED_OUT_UPPER_OFFSET:    reg_rdata = {16'h0000, r_mo_upper_data_q};
      GPIO_DIRECT_OE_OFFSET:           reg_rdata = r_direct_oe_q;
      GPIO_MASKED_OE_LOWER_OFFSET:     reg_rdata = {r_moe_lower_mask_q, r_moe_lower_data_q};
      GPIO_MASKED_OE_UPPER_OFFSET:     reg_rdata = {r_moe_upper_mask_q, r_moe_upper_data_q};
      GPIO_INTR_CTRL_EN_RISING_OFFSET: reg_rdata = r_intr_en_rise_q;
      GPIO_INTR_CTRL_EN_FALLING_OFFSET:reg_rdata = r_intr_en_fall_q;
      GPIO_INTR_CTRL_EN_LVLHIGH_OFFSET:reg_rdata = r_intr_en_lvlhigh_q;
      GPIO_INTR_CTRL_EN_LVLLOW_OFFSET: reg_rdata = r_intr_en_lvllow_q;
      GPIO_CTRL_EN_INPUT_FILTER_OFFSET:reg_rdata = r_ctrl_en_input_filter_q;
      GPIO_HW_STRAPS_DATA_IN_VALID_OFFSET: reg_rdata = {31'h0, r_hw_straps_valid_q};
      GPIO_HW_STRAPS_DATA_IN_OFFSET:   reg_rdata = r_hw_straps_data_q;
      default: begin
        addr_hit = 1'b0;
        reg_rdata = 32'hFFFF_FFFF;
      end
    endcase
  end

  // -------------------------
  // Drive reg2hw (to core), mirroring original semantics
  // -------------------------

  // intr_state: HW sets via hw2reg, SW clears; core reads q (already in GPIO via intr_hw paths)
  assign reg2hw.intr_state.q = r_intr_state_q;

  // intr_enable: RW
  assign reg2hw.intr_enable.q = r_intr_enable_q;

  // intr_test: pulse via qe + q (data payload = what SW wrote)
  // We don’t store last wd; for test we forward current bus write data.
  // If you prefer, keep a holding reg to echo last write; not required by gpio.sv.
  assign reg2hw.intr_test.q  = reg_wdata;   // only meaningfully sampled when qe=1
  assign reg2hw.intr_test.qe = p_intr_test_qe;

  // alert_test: 1-bit pulse
  assign reg2hw.alert_test.q  = reg_wdata[0];
  assign reg2hw.alert_test.qe = p_alert_test_qe;

  // data_in: RO captured from hw2reg; gpio.sv reads via hw2reg path, but SW readback is r_data_in_q
  // (no reg2hw field for data_in)

  // direct_out: RW + qe for one cycle on write
  assign reg2hw.direct_out.q  = r_direct_out_q;
  assign reg2hw.direct_out.qe = p_direct_out_qe;

  // masked_out_lower/upper: provide data/mask q and one-cycle qe on write
  assign reg2hw.masked_out_lower.data.q  = r_mo_lower_data_q;
  assign reg2hw.masked_out_lower.data.qe = p_masked_out_lower_qe;
  assign reg2hw.masked_out_lower.mask.q  = reg_wdata[31:16]; // mask comes from the same write
  assign reg2hw.masked_out_lower.mask.qe = p_masked_out_lower_qe;

  assign reg2hw.masked_out_upper.data.q  = r_mo_upper_data_q;
  assign reg2hw.masked_out_upper.data.qe = p_masked_out_upper_qe;
  assign reg2hw.masked_out_upper.mask.q  = reg_wdata[31:16];
  assign reg2hw.masked_out_upper.mask.qe = p_masked_out_upper_qe;

  // direct_oe + qe
  assign reg2hw.direct_oe.q  = r_direct_oe_q;
  assign reg2hw.direct_oe.qe = p_direct_oe_qe;

  // masked_oe lower/upper + qe
  assign reg2hw.masked_oe_lower.data.q  = r_moe_lower_data_q;
  assign reg2hw.masked_oe_lower.data.qe = p_masked_oe_lower_qe;
  assign reg2hw.masked_oe_lower.mask.q  = r_moe_lower_mask_q;
  assign reg2hw.masked_oe_lower.mask.qe = p_masked_oe_lower_qe;

  assign reg2hw.masked_oe_upper.data.q  = r_moe_upper_data_q;
  assign reg2hw.masked_oe_upper.data.qe = p_masked_oe_upper_qe;
  assign reg2hw.masked_oe_upper.mask.q  = r_moe_upper_mask_q;
  assign reg2hw.masked_oe_upper.mask.qe = p_masked_oe_upper_qe;

  // interrupt enables for edge/level
  assign reg2hw.intr_ctrl_en_rising.q  = r_intr_en_rise_q;
  assign reg2hw.intr_ctrl_en_falling.q = r_intr_en_fall_q;
  assign reg2hw.intr_ctrl_en_lvlhigh.q = r_intr_en_lvlhigh_q;
  assign reg2hw.intr_ctrl_en_lvllow.q  = r_intr_en_lvllow_q;

  // input glitch filter enables
  assign reg2hw.ctrl_en_input_filter.q = r_ctrl_en_input_filter_q;

  // straps (gpio.sv reads via reg2hw.hw_straps_* .q)
  assign reg2hw.hw_straps_data_in_valid.q = r_hw_straps_valid_q;
  assign reg2hw.hw_straps_data_in.q       = r_hw_straps_data_q;

  // Unused reg2hw fields (if any) default to zero by struct default elsewhere.

endmodule