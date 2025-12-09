// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// General Purpose Input/Output module

import gpio_reg_pkg::*;

module gpio (
    input  logic clk_i,
    input  logic rst_ni,

    // Register interface (from external gpio_reg_lite)
    input  gpio_reg2hw_t reg2hw,
    output gpio_hw2reg_t hw2reg,

    // GPIO physical pins
    input  logic [NumIOs-1:0] cio_gpio_i,
    output logic [NumIOs-1:0] cio_gpio_o,
    output logic [NumIOs-1:0] cio_gpio_en_o
);

    // Internal registers
    logic [NumIOs-1:0] cio_gpio_q;
    logic [NumIOs-1:0] cio_gpio_en_q;
    logic [NumIOs-1:0] data_in_q;

    //==========================================================
    // Input sampling
    //==========================================================
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            data_in_q <= '0;
        end else begin
            data_in_q <= cio_gpio_i;
        end
    end

    // GPIO_IN: Always update data_in register
    assign hw2reg.data_in.de = 1'b1;
    assign hw2reg.data_in.d  = data_in_q;

    //==========================================================
    // GPIO Output Data Control
    //==========================================================
    assign cio_gpio_o = cio_gpio_q;

    // Readback paths for output registers (zero-extend to 32-bit hw2reg fields)
    assign hw2reg.direct_out.d            = {{(32-NumIOs){1'b0}}, cio_gpio_q};
    assign hw2reg.masked_out_upper.data.d = 16'h0;  // NumIOs <= 16, upper unused
    assign hw2reg.masked_out_upper.mask.d = 16'h0;
    assign hw2reg.masked_out_lower.data.d = {{(16-NumIOs){1'b0}}, cio_gpio_q};
    assign hw2reg.masked_out_lower.mask.d = 16'h0;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            cio_gpio_q <= '0;
        end else if (reg2hw.direct_out.qe) begin
            // Direct write to all bits
            cio_gpio_q <= reg2hw.direct_out.q[NumIOs-1:0];
        end else if (reg2hw.masked_out_lower.data.qe) begin
            // Masked write to lower bits (only relevant portion for NumIOs <= 16)
            cio_gpio_q <=
                ( reg2hw.masked_out_lower.mask.q[NumIOs-1:0] & reg2hw.masked_out_lower.data.q[NumIOs-1:0]) |
                (~reg2hw.masked_out_lower.mask.q[NumIOs-1:0] & cio_gpio_q);
        end
        // masked_out_upper not used when NumIOs <= 16
    end

    //==========================================================
    // GPIO Output Enable Control
    //==========================================================
    assign cio_gpio_en_o = cio_gpio_en_q;

    // Readback paths for OE registers (zero-extend to 32-bit hw2reg fields)
    assign hw2reg.direct_oe.d            = {{(32-NumIOs){1'b0}}, cio_gpio_en_q};
    assign hw2reg.masked_oe_upper.data.d = 16'h0;  // NumIOs <= 16, upper unused
    assign hw2reg.masked_oe_upper.mask.d = 16'h0;
    assign hw2reg.masked_oe_lower.data.d = {{(16-NumIOs){1'b0}}, cio_gpio_en_q};
    assign hw2reg.masked_oe_lower.mask.d = 16'h0;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            cio_gpio_en_q <= '0;
        end else if (reg2hw.direct_oe.qe) begin
            // Direct write to all OE bits
            cio_gpio_en_q <= reg2hw.direct_oe.q[NumIOs-1:0];
        end else if (reg2hw.masked_oe_lower.data.qe) begin
            // Masked write to lower OE bits (only relevant portion for NumIOs <= 16)
            cio_gpio_en_q <=
                ( reg2hw.masked_oe_lower.mask.q[NumIOs-1:0] & reg2hw.masked_oe_lower.data.q[NumIOs-1:0]) |
                (~reg2hw.masked_oe_lower.mask.q[NumIOs-1:0] & cio_gpio_en_q);
        end
        // masked_oe_upper not used when NumIOs <= 16
    end

    //==========================================================
    // Unused hw2reg fields - tie off cleanly
    //==========================================================
    assign hw2reg.intr_state.d  = '0;
    assign hw2reg.intr_state.de = 1'b0;
    assign hw2reg.hw_straps_data_in_valid.d  = 1'b0;
    assign hw2reg.hw_straps_data_in_valid.de = 1'b0;
    assign hw2reg.hw_straps_data_in.d  = '0;
    assign hw2reg.hw_straps_data_in.de = 1'b0;

endmodule