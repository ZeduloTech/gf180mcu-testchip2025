`timescale 1ns / 1ps

package pwm_reg_pkg;

  // Param list
  parameter int NOutputs = 2;
  //parameter int NumAlerts = 1;

  // Address widths within the block
  parameter int BlockAw = 7;

  // Number of registers for every interface
  //parameter int NumRegs = 23;

  ////////////////////////////
  // Typedefs for registers //
  ////////////////////////////


  typedef struct packed {
    logic        cntr_en_q;
    logic        cntr_en_qe;

    logic [3:0]  dc_resn_q;
    logic        dc_resn_qe;

    logic [26:0] clk_div_q;
    logic        clk_div_qe;
  } pwm_reg2hw_cfg_reg_t;


  typedef struct packed {
    logic        q;
    logic        qe;
  } pwm_reg2hw_pwm_en_mreg_t;


  typedef struct packed {
    logic        q;
    logic        qe;
  } pwm_reg2hw_invert_mreg_t;


  typedef struct packed {
    logic        blink_en_q;
    logic        blink_en_qe;

    logic        htbt_en_q;
    logic        htbt_en_qe;

    logic [15:0] phase_delay_q;
    logic        phase_delay_qe;
  } pwm_reg2hw_pwm_param_mreg_t;


  typedef struct packed {
    logic [15:0] b_q;
    logic        b_qe;

    logic [15:0] a_q;
    logic        a_qe;
  } pwm_reg2hw_duty_cycle_mreg_t;


  typedef struct packed {
    logic [15:0] y_q;
    logic        y_qe;

    logic [15:0] x_q;
    logic        x_qe;
  } pwm_reg2hw_blink_param_mreg_t;


  // Register -> HW type (ONLY the registers actually used)
  typedef struct packed {
      pwm_reg2hw_cfg_reg_t cfg;
      pwm_reg2hw_pwm_en_mreg_t [1:0] pwm_en;
      pwm_reg2hw_invert_mreg_t [1:0] invert;
      pwm_reg2hw_pwm_param_mreg_t [1:0] pwm_param;
      pwm_reg2hw_duty_cycle_mreg_t [1:0] duty_cycle;
      pwm_reg2hw_blink_param_mreg_t [1:0] blink_param;
  } pwm_reg2hw_t;


  // Register offsets
  //parameter logic [BlockAw-1:0] PWM_ALERT_TEST_OFFSET = 7'h 0;
  //parameter logic [BlockAw-1:0] PWM_REGWEN_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] PWM_CFG_OFFSET = 7'h 0;
  parameter logic [BlockAw-1:0] PWM_PWM_EN_OFFSET = 7'h 4;
  parameter logic [BlockAw-1:0] PWM_INVERT_OFFSET = 7'h 8;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_0_OFFSET = 7'h c;
  parameter logic [BlockAw-1:0] PWM_PWM_PARAM_1_OFFSET = 7'h 10;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_0_OFFSET = 7'h 14;
  parameter logic [BlockAw-1:0] PWM_DUTY_CYCLE_1_OFFSET = 7'h 18;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_0_OFFSET = 7'h 1c;
  parameter logic [BlockAw-1:0] PWM_BLINK_PARAM_1_OFFSET = 7'h 20;


  // Reset values for hwext registers and their fields
  // parameter logic [0:0] PWM_ALERT_TEST_RESVAL = 1'h 0;
  // parameter logic [0:0] PWM_ALERT_TEST_FATAL_FAULT_RESVAL = 1'h 0;


  // Register index
  typedef enum int {
    PWM_CFG,
    PWM_PWM_EN,
    PWM_INVERT,
    PWM_PWM_PARAM_0,
    PWM_PWM_PARAM_1,
    PWM_DUTY_CYCLE_0,
    PWM_DUTY_CYCLE_1,
    PWM_BLINK_PARAM_0,
    PWM_BLINK_PARAM_1
  } pwm_id_e;

endpackage
