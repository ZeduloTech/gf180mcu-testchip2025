`default_nettype none

`timescale 1 ns / 1 ps

module async_wb_efuse_tb;
    reg clock;
    reg RSTB;
    reg power1;

    wire gpio;
    wire checkbits;
    wire [37:0] mprj_io;
    wire flash_csb;
    wire flash_clk;
    wire flash_io0;
    wire flash_io1;
    wire uart_tx;
    reg uart_rx = 1'b1;
    wire uart_loopback;
    wire SDO;
    
    reg test_success = 1'b0;

    assign checkbits = mprj_io[1];
    assign uart_tx = mprj_io[6];
    assign mprj_io[5] = uart_rx;

    always #25 clock <= (clock === 1'b0);

    initial begin
        clock = 0;
    end
    
    `define CHIP_TOP_HIER uut.chip
    `include "sdf.vh" 

    initial begin
        $display("Wait for Wishbone async eFuse test to complete...");
        wait(gpio == 1'b1);
        $display("eFuse write completed, resetting...");
        #1000;  // reset will pe performed here
        wait(gpio == 1'b1);
        wait(gpio == 1'b0);
        wait(gpio == 1'b1);
        $display("Monitor: Wishbone async eFuse test passed");
        test_success <= 1'b1;
        #100;
        $finish;
    end

    `ifdef GL
    `define POR_INST `CHIP_TOP_HIER.\i_chip_core.caravel .por_inst
    `else
    `define POR_INST `CHIP_TOP_HIER.i_chip_core.caravel.por_inst 
    `endif
    initial begin
        RSTB <= 1'b0;
        #1000;
        RSTB <= 1'b1;        // Release reset
        #2000;
        wait(gpio == 1'b1); // Reset & simulate POR after first test part
        RSTB <= 1'b0;
        `POR_INST.restart = 0;
        #1;
        `POR_INST.restart = 1;
        #1000;
        RSTB <= 1'b1;        // Release reset
        #2000;
    end

    initial begin        // Power-up sequence
        power1 <= 1'b0;
        #2000;
        power1 <= 1'b1;
    end

    initial begin
         wait(checkbits == 1'b1);
         $display("Monitor: Test eFuse read-write Failed");
         $finish;
    end

    wire VDD5V0;
    wire VSS;

    assign VDD5V0 = power1;
    assign VSS = 1'b0;
    
    assign mprj_io[3] = 1'b1;  // Force CSB high.
    assign mprj_io[0] = 1'b0;  // Disable debug mode

    caravel uut (
        `ifdef USE_POWER_PINS
        .VDD      (VDD5V0),
        .VSS      (VSS),
        `endif
        .clock      (clock),
        .gpio     (gpio),
        .mprj_io  (mprj_io),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0(flash_io0),
        .flash_io1(flash_io1),
        .resetb      (RSTB)
    );

    spiflash #(
        .FILENAME({`HEX_PREFIX, "async_wb_efuse.hex"})
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),            // not used
        .io3()            // not used
    );

endmodule
`default_nettype wire
