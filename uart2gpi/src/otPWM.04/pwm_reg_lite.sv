// PWM Reg Lite - Complete Implementation

`timescale 1ns / 1ps
//`include "pwm_reg_pkg.sv"
import pwm_reg_pkg::*;


module pwm_reg_lite (
    input clk,
    input rst_n,

    // Exposed MMIO bus
    input  logic [pwm_reg_pkg::BlockAw-1:0] bus_addr,
    input  logic [31:0]            wdata_i,
    input  logic                   wen_i,
    input  logic                   ren_i,
    output logic [31:0]            rdata_o,

    output pwm_reg_pkg::pwm_reg2hw_t reg2hw,

    output logic [1:0]             pwm_out
);

        // import pwm_reg_pkg::*;

        // Configuration Flags
        // logic init_flag;
        logic pwm_en_qe;

        // Internal Registers
        logic [3:0]     dc_resn;
        logic [26:0]    clk_divider;
        logic           ctrl_enable;

        // Register Mapping ()
        logic [31:0]    pwm_config;             //      -->     [26:0] clock_divider, [30:27] dc_resn, [31] ctrl_enable
        logic [31:0]    pwm_channel_enable;     //      -->     [0] and [1]        .. channel 1 & 2
        logic [31:0]    pwm_channel_invert;     //      -->     [0] and [1]        .. channel 1 & 2
        logic [31:0]    pwm_channel_0_param;       // Blink , Heartbeat , Phase Delay  -->      [0], [1], [17:2]        .. channel 1
        logic [31:0]    pwm_channel_1_param;       // Blink , Heartbeat , Phase Delay  -->      [0], [1], [17:2]        .. channel 2
        logic [31:0]    pwm_channel_0_duty_cycle;  // Duty Cycle Channel 0             -->      [15:0] duty A, [31:16] duty B        .. channel 1
        logic [31:0]    pwm_channel_1_duty_cycle;  // Duty Cycle Channel 1             -->      [15:0] duty A, [31:16] duty B        .. channel 2
        logic [31:0]    pwm_channel_0_blink_param; // Blink Parameters Channel 0       -->        [15:0] blink_x , [31:16] blink_y        .. channel 1
        logic [31:0]    pwm_channel_1_blink_param; // Blink Parameters Channel 1       -->        [15:0] blink_x , [31:16] blink_y        .. channel 2

        // Extract fields from parameter registers
        logic [1:0]     channel_blink_en;
        logic [1:0]     channel_htbt_en;
        logic [31:0]    phase_delay;
        logic [31:0]    duty_cycle_0;
        logic [31:0]    duty_cycle_1;
        logic [31:0]    blink_param_0;
        logic [31:0]    blink_param_1;

        // Extract parameters for Channel 0
        assign channel_blink_en[0] = pwm_channel_0_param[0];
        assign channel_htbt_en[0]  = pwm_channel_0_param[1];
        assign phase_delay[15:0]   = pwm_channel_0_param[17:2];

        // Extract parameters for Channel 1
        assign channel_blink_en[1] = pwm_channel_1_param[0];
        assign channel_htbt_en[1]  = pwm_channel_1_param[1];
        assign phase_delay[31:16]  = pwm_channel_1_param[17:2];

        // Extract duty cycles
        assign duty_cycle_0[15:0]  = pwm_channel_0_duty_cycle[15:0];    // duty A
        assign duty_cycle_0[31:16] = pwm_channel_0_duty_cycle[31:16];   // duty B
        assign duty_cycle_1[15:0]  = pwm_channel_1_duty_cycle[15:0];                // A
        assign duty_cycle_1[31:16] = pwm_channel_1_duty_cycle[31:16];               // B

        // Blink parameters
        assign blink_param_0 = pwm_channel_0_blink_param;   // (X : [15:0] , Y : [31:16])
        assign blink_param_1 = pwm_channel_1_blink_param;   // (X : [15:0] , Y : [31:16])


        //-------------------------------------
        // Register Write & Read Logic
        //-------------------------------------
        always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                        pwm_config <= 32'h0;
                        pwm_channel_enable <= 32'h0;
                        pwm_channel_invert <= 32'h0;
                        pwm_channel_0_param <= 32'h0;
                        pwm_channel_1_param <= 32'h0;
                        pwm_channel_0_duty_cycle <= 32'h0;
                        pwm_channel_1_duty_cycle <= 32'h0;
                        pwm_channel_0_blink_param <= 32'h0;
                        pwm_channel_1_blink_param <= 32'h0;
                        rdata_o <= 32'h0;
                end else begin
                        if (wen_i) begin  // Write operation
                                case (bus_addr)
                                        PWM_CFG_OFFSET: pwm_config <= wdata_i;
                                        PWM_PWM_EN_OFFSET: pwm_channel_enable <= wdata_i;
                                        PWM_INVERT_OFFSET: pwm_channel_invert <= wdata_i;
                                        PWM_PWM_PARAM_0_OFFSET: pwm_channel_0_param <= wdata_i;
                                        PWM_PWM_PARAM_1_OFFSET: pwm_channel_1_param <= wdata_i;
                                        PWM_DUTY_CYCLE_0_OFFSET: pwm_channel_0_duty_cycle <= wdata_i;
                                        PWM_DUTY_CYCLE_1_OFFSET: pwm_channel_1_duty_cycle <= wdata_i;
                                        PWM_BLINK_PARAM_0_OFFSET: pwm_channel_0_blink_param <= wdata_i;
                                        PWM_BLINK_PARAM_1_OFFSET: pwm_channel_1_blink_param <= wdata_i;
                                endcase
                        end else if (ren_i) begin  // Read operation
                                case (bus_addr)
                                        PWM_CFG_OFFSET: rdata_o <= pwm_config;
                                        PWM_PWM_EN_OFFSET: rdata_o <= pwm_channel_enable;
                                        PWM_INVERT_OFFSET: rdata_o <= pwm_channel_invert;
                                        PWM_PWM_PARAM_0_OFFSET: rdata_o <= pwm_channel_0_param;
                                        PWM_PWM_PARAM_1_OFFSET: rdata_o <= pwm_channel_1_param;
                                        PWM_DUTY_CYCLE_0_OFFSET: rdata_o <= pwm_channel_0_duty_cycle;
                                        PWM_DUTY_CYCLE_1_OFFSET: rdata_o <= pwm_channel_1_duty_cycle;
                                        PWM_BLINK_PARAM_0_OFFSET: rdata_o <= pwm_channel_0_blink_param;
                                        PWM_BLINK_PARAM_1_OFFSET: rdata_o <= pwm_channel_1_blink_param;
                                        default: rdata_o <= 32'h0;
                                endcase
                        end
                end
        end


        // // One-time configuration for pwm_en_qe
        // always_ff @(posedge clk or negedge rst_n) begin
        //     if (!rst_n) begin
        //         init_flag <= 1'b1;
        //         pwm_en_qe <= 1'b0;
        //     end else if (init_flag) begin
        //         pwm_en_qe <= 1'b1;
        //         init_flag <= 1'b0;
        //     end else begin
        //         pwm_en_qe <= 1'b0;
        //     end
        // end

        assign pwm_en_qe = wen_i;

        // Config Register
        assign clk_divider = pwm_config[26:0];
        assign dc_resn = pwm_config[30:27];
        assign ctrl_enable = pwm_config[31];


        // Build the output struct using a function
        function automatic pwm_reg_pkg::pwm_reg2hw_t build_reg2hw(
                logic qe
        );
                pwm_reg_pkg::pwm_reg2hw_t result;

                // Initialize all bits to zero first
                result = '0;

                // Global settings
                result.cfg.cntr_en_q = ctrl_enable;
                result.cfg.clk_div_q = clk_divider;
                result.cfg.dc_resn_q = dc_resn;
                result.cfg.cntr_en_qe = qe;
                result.cfg.clk_div_qe = qe;
                result.cfg.dc_resn_qe = qe;

                // Channel 0
                result.pwm_en[0].q = pwm_channel_enable[0];
                result.pwm_en[0].qe = qe;
                result.invert[0].q = pwm_channel_invert[0];
                result.invert[0].qe = qe;
                result.pwm_param[0].blink_en_q = channel_blink_en[0];
                result.pwm_param[0].blink_en_qe = qe;
                result.pwm_param[0].htbt_en_q = channel_htbt_en[0];
                result.pwm_param[0].htbt_en_qe = qe;
                result.pwm_param[0].phase_delay_q = phase_delay[15:0];
                result.pwm_param[0].phase_delay_qe = qe;
                result.duty_cycle[0].a_q = duty_cycle_0[15:0];
                result.duty_cycle[0].a_qe = qe;
                result.duty_cycle[0].b_q = duty_cycle_0[31:16];
                result.duty_cycle[0].b_qe = qe;
                result.blink_param[0].x_q = blink_param_0[15:0];    // X
                result.blink_param[0].x_qe = qe;
                result.blink_param[0].y_q = blink_param_0[31:16];   // Y
                result.blink_param[0].y_qe = qe;

                // Channel 1
                result.pwm_en[1].q = pwm_channel_enable[1];
                result.pwm_en[1].qe = qe;
                result.invert[1].q = pwm_channel_invert[1];
                result.invert[1].qe = qe;
                result.pwm_param[1].blink_en_q = channel_blink_en[1];
                result.pwm_param[1].blink_en_qe = qe;
                result.pwm_param[1].htbt_en_q = channel_htbt_en[1];
                result.pwm_param[1].htbt_en_qe = qe;
                result.pwm_param[1].phase_delay_q = phase_delay[31:16];
                result.pwm_param[1].phase_delay_qe = qe;
                result.duty_cycle[1].a_q = duty_cycle_1[15:0];
                result.duty_cycle[1].a_qe = qe;
                result.duty_cycle[1].b_q = duty_cycle_1[31:16];
                result.duty_cycle[1].b_qe = qe;
                result.blink_param[1].x_q = blink_param_1[15:0];    // X
                result.blink_param[1].x_qe = qe;
                result.blink_param[1].y_q = blink_param_1[31:16];   // Y
                result.blink_param[1].y_qe = qe;

                return result;
        endfunction


        // Use the function to build and assign the output
        assign reg2hw = build_reg2hw(pwm_en_qe);


        // PWM core instance with improved timing
        pwm_core #(
                .NOutputs(2),
                .PhaseCntDw(16),
                .BeatCntDw(13)
        ) pwm_sig(
                .clk_core_i(clk),
                .rst_core_ni(rst_n),
                .reg2hw(reg2hw),
                .pwm_o(pwm_out)		// Output (LED)
        );

endmodule
