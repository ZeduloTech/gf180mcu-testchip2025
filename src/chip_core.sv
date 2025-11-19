// SPDX-FileCopyrightText: © 2025 egorxe
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
`include "pinout.vh"
`include "defines.v" // from Caravel

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_BIDIR_PADS,
    parameter NUM_ANALOG_PADS
    )(
    `ifdef USE_POWER_PINS
    inout  wire VDD,
    inout  wire VSS,
    `endif
    
    input  wire clk,       // clock
    input  wire rst_n,     // reset (active low)
    
    input  wire [NUM_INPUT_PADS-1:0] input_in,   // Input value
    output wire [NUM_INPUT_PADS-1:0] input_pu,   // Pull-up
    output wire [NUM_INPUT_PADS-1:0] input_pd,   // Pull-down

    input  wire [NUM_BIDIR_PADS-1:0] bidir_in,   // Input value
    output wire [NUM_BIDIR_PADS-1:0] bidir_out,  // Output value
    output wire [NUM_BIDIR_PADS-1:0] bidir_oe,   // Output enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_cs,   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    output wire [NUM_BIDIR_PADS-1:0] bidir_sl,   // Slew rate (0=fast, 1=slow)
    output wire [NUM_BIDIR_PADS-1:0] bidir_ie,   // Input enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_pu,   // Pull-up
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd,   // Pull-down

    inout  wire [NUM_ANALOG_PADS-1:0] analog  // Analog
);

    // Wishbone from Caravel
    wire user_wb_clk;
    wire user_wb_rst;
    wire user_wb_cyc;
    wire user_wb_stb;
    wire user_wb_we;
    wire [3:0]  user_wb_sel;
    wire [31:0] user_wb_adr;
    wire [31:0] user_wb_dat_in;
    wire [31:0] user_wb_dat_out;
    wire user_wb_ack;
    
    // Disable pull-up and pull-down for input
    assign input_pu = '0;
    assign input_pd = '0;
    
    // set pad config for flash & GPIO
    assign bidir_pu[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0010;
    assign bidir_pd[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_sl[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_cs[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    
    // set all other bidirs
    assign bidir_pu[NUM_BIDIR_PADS-1:`PAD_CARAVEL_END+1] = '0;
    assign bidir_pd[NUM_BIDIR_PADS-1:`PAD_CARAVEL_END+1] = '0;
    assign bidir_sl[NUM_BIDIR_PADS-1:`PAD_CARAVEL_END+1] = '0;
    assign bidir_cs[NUM_BIDIR_PADS-1:`PAD_CARAVEL_END+1] = '0;
    
    wb_counter counter (
        .wb_clk_i(user_wb_clk),
        .wb_rst_i(user_wb_rst),
        .wb_stb_i(user_wb_stb),
        .wb_cyc_i(user_wb_cyc),
        .wb_adr_i(user_wb_adr),
        .wb_dat_i(user_wb_dat_in),
        .wb_we_i (user_wb_we),
        .wb_dat_o(user_wb_dat_out),
        .wb_ack_o(user_wb_ack)
    );
    
    caravel_core caravel (
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
        .user_wb_clk_o(user_wb_clk),
        .user_wb_rst_o(user_wb_rst),
        .user_wb_cyc_o(user_wb_cyc),
        .user_wb_stb_o(user_wb_stb),
        .user_wb_we_o (user_wb_we),
        .user_wb_sel_o(user_wb_sel),
        .user_wb_adr_o(user_wb_adr),
        .user_wb_dat_o(user_wb_dat_in),
        .user_wb_dat_i(user_wb_dat_out),
        .user_wb_ack_i(user_wb_ack),
        
        .user_irq_core(1'b0),
        
        // User IO stub
        .user_gpio_out({`CARAVEL_IO_PADS{1'b0}}),
        .user_gpio_oeb({`CARAVEL_IO_PADS{1'b1}})
    );

endmodule

`default_nettype wire
