// SPDX-FileCopyrightText: © 2025 egorxe
// SPDX-License-Identifier: Apache-2.0

`timescale 1 ns / 1 ps
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
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd    // Pull-down

    //inout  wire [NUM_ANALOG_PADS-1:0] analog  // Analog, not used!
);

    // Wishbone from Caravel
    wire user_wb_clk_prebuf;
    wire user_wb_clk;
    wire user_wb_rst;
    wire user_wb_cyc;
    wire user_wb_stb;
    wire user_wb_we;
    wire [3:0]  user_wb_sel;
    wire [31:0] user_wb_adr;
    wire [31:0] user_wb_dat_wr;
    wire [31:0] user_wb_dat_rd;
    wire user_wb_ack;

    // Additional Caravel signals
    wire npor;
    wire caravel_start_mode;
    
    // Set all inputs to pull-down
    assign input_pu = '0;
    assign input_pd = '1;
    
    // SRAM test signals
    wire sramtest_clk;
    wire sram_spi_miso;
    wire efuse_spi_miso;
    wire rst_n_buf;
    
    // Set pad config for flash & GPIO
    assign bidir_pu[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0010;
    assign bidir_pd[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_sl[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_cs[`PAD_FLASH_IO1:`PAD_GPIO] = 5'b0000;
    assign bidir_ie[`PAD_FLASH_CLK:`PAD_FLASH_CSB] = 2'b00;

    // Set pad config for SRAM test: MOSI MISO CLK CS DEBUG
    assign bidir_oe[`PAD_SRAM_HIGH:`PAD_SRAM_LOW] = 5'b01001;   // Output enable
    assign bidir_ie[`PAD_SRAM_HIGH:`PAD_SRAM_LOW] = 5'b10110;   // Input enable
    assign bidir_cs[`PAD_SRAM_HIGH:`PAD_SRAM_LOW] = 5'b00000;   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    assign bidir_sl[`PAD_SRAM_HIGH:`PAD_SRAM_LOW] = 5'b00000;   // Slew rate (0=fast, 1=slow)
    assign bidir_pu[`PAD_SRAM_HIGH:`PAD_SRAM_LOW] = 5'b00000;   // Pull-up
    assign bidir_pd[`PAD_SRAM_HIGH:`PAD_SRAM_LOW] = 5'b00000;   // Pull-down

    // Set pad config for UART2GPI block0: PWM1-0, GPIO3-0
    assign bidir_oe[`PAD_UART2GPI_PWM1:`PAD_UART2GPI_PWM0] = 2'b11;   // Output enable
    assign bidir_ie[`PAD_UART2GPI_PWM1:`PAD_UART2GPI_PWM0] = 2'b00;   // Input enable
    //GPIO oe set by GPIO block
    assign bidir_ie[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0] = ~bidir_oe[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0];
    assign bidir_cs[`PAD_UART2GPI_HIGH0:`PAD_UART2GPI_LOW0] = 6'b000000;   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    assign bidir_sl[`PAD_UART2GPI_HIGH0:`PAD_UART2GPI_LOW0] = 6'b000000;   // Slew rate (0=fast, 1=slow)
    assign bidir_pu[`PAD_UART2GPI_HIGH0:`PAD_UART2GPI_LOW0] = 6'b000000;   // Pull-up
    assign bidir_pd[`PAD_UART2GPI_HIGH0:`PAD_UART2GPI_LOW0] = 6'b000000;   // Pull-down


    // Set pad config for UART2GPI block1: uartRX, uartTX, i2cSCL, i2cSDA
    assign bidir_oe[`PAD_UART2GPI_UARTRX:`PAD_UART2GPI_UARTTX] = 2'b01;   // Output enable
    assign bidir_ie[`PAD_UART2GPI_UARTRX:`PAD_UART2GPI_UARTTX] = 2'b10;   // Input enable
    //SDA/SCL oe set by I2C block
    assign bidir_ie[`PAD_UART2GPI_I2CSCL:`PAD_UART2GPI_I2CSDA] = ~bidir_oe[`PAD_UART2GPI_I2CSCL:`PAD_UART2GPI_I2CSDA];
    assign bidir_cs[`PAD_UART2GPI_HIGH1:`PAD_UART2GPI_LOW1] = 4'b0000;   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    assign bidir_sl[`PAD_UART2GPI_HIGH1:`PAD_UART2GPI_LOW1] = 4'b0000;   // Slew rate (0=fast, 1=slow)
    assign bidir_pu[`PAD_UART2GPI_HIGH1:`PAD_UART2GPI_LOW1] = 4'b0000;   // Pull-up
    assign bidir_pd[`PAD_UART2GPI_HIGH1:`PAD_UART2GPI_LOW1] = 4'b0000;   // Pull-down

    // Set pad config for async eFuse
    assign bidir_oe[`PAD_AEF_OUT_HIGH:`PAD_AEF_READY] = 9'b11111_1111; // Output enable
    assign bidir_ie[`PAD_AEF_OUT_HIGH:`PAD_AEF_READY] = 9'b00000_0000; // Input enable
    assign bidir_cs[`PAD_AEF_OUT_HIGH:`PAD_AEF_READY] = 9'b00000_0000; // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    assign bidir_sl[`PAD_AEF_OUT_HIGH:`PAD_AEF_READY] = 9'b00000_0000; // Slew rate (0=fast, 1=slow)
    assign bidir_pu[`PAD_AEF_OUT_HIGH:`PAD_AEF_READY] = 9'b00000_0000; // Pull-up
    assign bidir_pd[`PAD_AEF_OUT_HIGH:`PAD_AEF_READY] = 9'b00000_0000; // Pull-down
    
    // Set all other bidirs
    //assign bidir_pu[`PAD_UNUSED_HIGH:`PAD_UNUSED_LOW] = '0;
    //assign bidir_pd[`PAD_UNUSED_HIGH:`PAD_UNUSED_LOW] = '0;
    //assign bidir_sl[`PAD_UNUSED_HIGH:`PAD_UNUSED_LOW] = '0;
    //assign bidir_cs[`PAD_UNUSED_HIGH:`PAD_UNUSED_LOW] = '0;
    //assign bidir_ie[`PAD_UNUSED_HIGH:`PAD_UNUSED_LOW] = '0;
    //assign bidir_oe[`PAD_UNUSED_HIGH:`PAD_UNUSED_LOW] = '0;

    // eFuse Wishbone memory
    wb_efuses wb_efuses (
        .wb_clk_i (user_wb_clk),
        .wb_rst_i (user_wb_rst),

        .wbm_adr_i(user_wb_adr),   
        .wbm_dat_i(user_wb_dat_wr),   
        .wbm_dat_o(user_wb_dat_rd),   
        .wbm_we_i (user_wb_we),    
        .wbm_sel_i(user_wb_sel),   
        .wbm_stb_i(user_wb_stb),   
        .wbm_ack_o(user_wb_ack),   
        .wbm_cyc_i(user_wb_cyc),   
        .npor_i(npor)       
    );
    
    // Buffer wb clock
    (* keep, dont_touch *) gf180mcu_fd_sc_mcu7t5v0__clkbuf_8 wb_clk_buf (
        .I(user_wb_clk_prebuf),
        .Z(user_wb_clk)
    );

    // eFuse async memory
    efuse_async_mem_1x8 efuse_async (
        .reset_n(input_in[`PADI_AEF_RESET]),
        .ready(bidir_out[`PAD_AEF_READY]),
        .prog(input_in[`PADI_AEF_PROG_HIGH:`PADI_AEF_PROG_LOW]),
        .out(bidir_out[`PAD_AEF_OUT_HIGH:`PAD_AEF_OUT_LOW])
    );

    // Caravel core
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
        .user_wb_clk_o(user_wb_clk_prebuf),
        .user_wb_rst_o(user_wb_rst),
        .user_wb_cyc_o(user_wb_cyc),
        .user_wb_stb_o(user_wb_stb),
        .user_wb_we_o (user_wb_we),
        .user_wb_sel_o(user_wb_sel),
        .user_wb_adr_o(user_wb_adr),
        .user_wb_dat_o(user_wb_dat_wr),
        .user_wb_dat_i(user_wb_dat_rd),
        .user_wb_ack_i(user_wb_ack),
        
        .user_irq_core(1'b0),
        
        // User IO stub
        .user_gpio_out({`CARAVEL_IO_PADS{1'b0}}),
        .user_gpio_oeb({`CARAVEL_IO_PADS{1'b1}}),
        
        .npor(npor),
        .start_mode(caravel_start_mode)
    );
    assign caravel_start_mode = input_in[`PADI_START_MODE];

    // SRAM test over SPI
    reg sram_ledstatus;
    reg sram_ledreset;
    reg sram_spidebug;
    assign bidir_out[`PAD_SRAM_SPIDEBUG] = sram_ledstatus | sram_ledreset | sram_spidebug;

    (* keep, dont_touch *) gf180mcu_fd_sc_mcu7t5v0__clkbuf_8 sramtest_clk_buf (
        .I(clk),
        .Z(sramtest_clk)
    );

    (* keep, dont_touch *) gf180mcu_fd_sc_mcu7t5v0__buf_8 sramtest_rst_clk_buf (
        .I(rst_n),
        .Z(rst_n_buf)
    );
    uspi_sramtest sram_test_0(
        .clk(sramtest_clk),
        .rst_n(rst_n_buf),
        .spi_mosi(bidir_in[`PAD_SRAM_SPIMOSI]),
        .wspi_clk(bidir_in[`PAD_SRAM_SPICLK]),
        .wspi_cs(bidir_in[`PAD_SRAM_SPICS]),
        .wspi_miso(sram_spi_miso),
        .wled_status(sram_ledstatus),
        .wled_reset(sram_ledreset),
        .wdebug(sram_spidebug)
    );

    // eFuse SPI memory
    efuse_spi_mem_256x8 efuse_spi (
        .clk_i(sramtest_clk),
        .npor(npor & rst_n_buf),
        .spi_mosi(bidir_in[`PAD_SRAM_SPIMOSI]),
        .spi_clk(bidir_in[`PAD_SRAM_SPICLK]),
        .spi_csn(input_in[`PADI_SEF_SPICS]),
        .spi_miso(efuse_spi_miso)
    );

    assign bidir_out[`PAD_SRAM_SPIMISO] = input_in[`PADI_SEF_SPICS] ? sram_spi_miso : efuse_spi_miso;

    // UART2GPI IP
    uart2gpi uart2gpi_0 (
        .clk(sramtest_clk),
        .rst_ni(rst_n_buf),
        .uart_rx_i(bidir_in[`PAD_UART2GPI_UARTRX]),
        .uart_tx_o(bidir_out[`PAD_UART2GPI_UARTTX]),
        .gpio_i(bidir_in[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0]),
        .gpio_o(bidir_out[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0]),
        .gpio_oe(bidir_oe[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0]),
        .pwm_o(bidir_out[`PAD_UART2GPI_PWM1:`PAD_UART2GPI_PWM0]),
        .i2c_scl_i(bidir_in[`PAD_UART2GPI_I2CSCL]),
        .i2c_scl_o(bidir_out[`PAD_UART2GPI_I2CSCL]),
        .i2c_scl_oe(bidir_oe[`PAD_UART2GPI_I2CSCL]),
        .i2c_sda_i(bidir_in[`PAD_UART2GPI_I2CSDA]),
        .i2c_sda_o(bidir_out[`PAD_UART2GPI_I2CSDA]),
        .i2c_sda_oe(bidir_oe[`PAD_UART2GPI_I2CSDA])
     );

endmodule

`default_nettype wire
