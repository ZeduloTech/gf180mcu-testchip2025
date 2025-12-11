// Simulation wrapper around chip_top to test Caravel

`default_nettype wire
`include "pinout.vh"
`include "defines.v"
    
module caravel #(
    parameter NUM_INPUT_PADS = 12,
    parameter NUM_BIDIR_PADS = 42
) (
    `ifdef USE_POWER_PINS
    inout VDD,        
    inout VSS,        
    `endif
    inout gpio,        
    inout [`MPRJ_IO_PADS-1:0] mprj_io,
    input clock,    
    input resetb,    

    inout flash_csb,
    inout flash_clk,
    inout flash_io0,
    inout flash_io1
);

    reg self_sufficient = 1'b0;
    wire [NUM_INPUT_PADS-1:0] in_pads = {self_sufficient, {NUM_INPUT_PADS-1{1'b0}}};
    wire [NUM_BIDIR_PADS-1:0] bidir_pads;

    chip_top chip (
        `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
        `endif
    
        .clk_PAD(clock),
        .rst_n_PAD(resetb),

        .input_PAD(in_pads),
        .bidir_PAD({bidir_pads[NUM_BIDIR_PADS-1:`PAD_CARAVEL_END+1], flash_io1, flash_io0, flash_clk, flash_csb, gpio, mprj_io[`MPRJ_IO_PADS-1:`MPRJ_IO_PADS-`MPRJ_TO_CARAVEL_HI], mprj_io[`MPRJ_TO_CARAVEL_LO-1:0]})
    );
    

endmodule
