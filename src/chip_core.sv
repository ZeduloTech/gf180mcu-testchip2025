// SPDX-FileCopyrightText: © 2025 egorxe
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
`include "pinout.vh"

module chip_core #(
    parameter NUM_INPUT = 12,
    parameter NUM_BIDIR = 42
    )(
`ifdef USE_POWER_PINS
    inout VDD,		// Common 5.0V padframe/ESD power
    inout VSS,		// Common padframe/ESD ground
`endif
    input  logic clk,       // clock
    input  logic rst_n,     // reset (active low)
    
    input  wire [NUM_INPUT-1:0] input_in,   // Input value
    output wire [NUM_INPUT-1:0] input_pu,   // Pull-up
    output wire [NUM_INPUT-1:0] input_pd,   // Pull-down

    input  wire [NUM_BIDIR-1:0] bidir_in,   // Input value
    output wire [NUM_BIDIR-1:0] bidir_out,  // Output value
    output wire [NUM_BIDIR-1:0] bidir_oe,   // Output enable
    output wire [NUM_BIDIR-1:0] bidir_cs,   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    output wire [NUM_BIDIR-1:0] bidir_sl,   // Slew rate (0=fast, 1=slow)
    output wire [NUM_BIDIR-1:0] bidir_ie,   // Input enable
    output wire [NUM_BIDIR-1:0] bidir_pu,   // Pull-up
    output wire [NUM_BIDIR-1:0] bidir_pd    // Pull-down
);

    // Disable pull-up and pull-down for input
    assign input_pu = '0;
    assign input_pd = '0;
    
    // set pad config for flash & GPIO
    assign bidir_pu[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0010;
    assign bidir_pd[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_sl[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_cs[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    
    
    caravel_core caravel (

    // All top-level I/O are package-facing pins

`ifdef USE_POWER_PINS
    .VDD(VDD),		
    .VSS(VSS),		
`endif
    // SoC Core Interface
	.rstb(rst_n),
    .clock_core(clk),
	.gpio_out_core(bidir_out[`PAD_GPIO]),
	.gpio_in_core(bidir_in[`PAD_GPIO]),
	.gpio_outenb_core(bidir_oe[`PAD_GPIO]),
	.gpio_inenb_core(bidir_ie[`PAD_GPIO]),
    
	.flash_csb_frame(bidir_out[`PAD_FLASH_CSB]),
	.flash_clk_frame(bidir_out[`PAD_FLASH_CLK]),
	.flash_csb_oe(bidir_oe[`PAD_FLASH_CSB]),
	.flash_clk_oe(bidir_oe[`PAD_FLASH_CLK]),
	.flash_io0_oe(bidir_oe[`PAD_FLASH_IO0]),
	.flash_io1_oe(bidir_oe[`PAD_FLASH_IO1]),
	.flash_io0_ie(bidir_ie[`PAD_FLASH_IO0]),
	.flash_io1_ie(bidir_ie[`PAD_FLASH_IO1]),
	.flash_io0_do(bidir_out[`PAD_FLASH_IO0]),
	.flash_io1_do(bidir_out[`PAD_FLASH_IO1]),
	.flash_io0_di(bidir_in[`PAD_FLASH_IO0]),
	.flash_io1_di(bidir_in[`PAD_FLASH_IO1]),
    
	.caravel_io_in(bidir_in[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_out(bidir_out[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_oe(bidir_oe[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_ie(bidir_ie[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_schmitt_sel(bidir_cs[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_pullup_sel(bidir_pu[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_pulldown_sel(bidir_pd[`CARAVEL_IO_PADS-1:0]),
	.caravel_io_slew_sel(bidir_sl[`CARAVEL_IO_PADS-1:0]),
    
    // User wishbone stub
    .user_wb_dat_i(32'b0),
    .user_wb_ack_i(1'b0),
    .user_irq_core(1'b0),
    
    // User IO stub
    .user_gpio_out({`CARAVEL_IO_PADS{1'b0}}),
    .user_gpio_oeb({`CARAVEL_IO_PADS{1'b1}})
);

endmodule

`default_nettype wire
