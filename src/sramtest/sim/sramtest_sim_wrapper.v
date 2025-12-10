// Simulation wrapper around chip_top to test SPI SRAM

`default_nettype none
`include "pinout.vh"
`include "defines.v"
    
module chip_wrapper #(
    parameter NUM_INPUT_PADS = 12,
    parameter NUM_BIDIR_PADS = 40,
    parameter NUM_ANALOG_PADS = 2
    ) ();

    wire clock = 1'b0;
    wire resetb = 1'b0;
    supply1 VDD;
    supply0 VSS;
    
    wire [NUM_INPUT_PADS-1:0] in_pads = {NUM_INPUT_PADS{1'b0}};
    wire [NUM_BIDIR_PADS-1:0] bidir_pads = {NUM_BIDIR_PADS{1'bz}};
    
    reg sramtest_sclk = 1'b1;
    reg sramtest_cs = 1'b1;
    reg sramtest_mosi = 1'b1;
    wire sramtest_miso;
    
    assign bidir_pads[`PAD_SRAM_SPICLK] = sramtest_sclk;
    assign bidir_pads[`PAD_SRAM_SPICS] = sramtest_cs;
    assign bidir_pads[`PAD_SRAM_SPIMOSI] = sramtest_mosi;
    assign sramtest_miso = bidir_pads[`PAD_SRAM_SPIMISO];

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
    

endmodule
