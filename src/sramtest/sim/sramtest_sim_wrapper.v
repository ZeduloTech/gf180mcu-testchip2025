// Simulation wrapper around chip_top to test SPI SRAM & async eFuse in cocotb

`default_nettype none
`include "pinout.vh"
`include "defines.v"
    
module chip_wrapper #(
    parameter NUM_INPUT_PADS = 12,
    parameter NUM_BIDIR_PADS = 42
) ();

    wire clock = 1'b0;
    wire resetb = 1'b0;
    supply1 VDD;
    supply0 VSS;
    
    wire [NUM_INPUT_PADS-1:0] in_pads = {1'b0, {(NUM_INPUT_PADS-1){1'bz}}};
    wire [NUM_BIDIR_PADS-1:0] bidir_pads = {NUM_BIDIR_PADS{1'bz}};
    
    wire sramtest_sclk  = 1'b1;
    wire sramtest_cs    = 1'b1;
    wire sramtest_mosi  = 1'b1;
    wire sramtest_miso;

    wire       aef_ready;
    wire       aef_rst  = 1'b0;
    wire [7:0] aef_prog = 8'h00;
    wire [7:0] aef_out;
    
    assign bidir_pads[`PAD_SRAM_SPICLK]     = sramtest_sclk;
    assign bidir_pads[`PAD_SRAM_SPICS]      = sramtest_cs;
    assign bidir_pads[`PAD_SRAM_SPIMOSI]    = sramtest_mosi;
    assign sramtest_miso = bidir_pads[`PAD_SRAM_SPIMISO];    
    
    assign in_pads[`PADI_AEF_RESET] = aef_rst;
    assign in_pads[`PADI_AEF_PROG_HIGH:`PADI_AEF_PROG_LOW] = aef_prog;
    assign aef_out = bidir_pads[`PAD_AEF_OUT_HIGH:`PAD_AEF_OUT_LOW];
    assign aef_ready = bidir_pads[`PAD_AEF_READY];

    chip_top chip (
        `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
        `endif
    
        .clk_PAD(clock),
        .rst_n_PAD(resetb),

        .input_PAD(in_pads),
        .bidir_PAD(bidir_pads)
    );
    
    `define CHIP_TOP_HIER chip
    `include "sdf.vh"

endmodule
