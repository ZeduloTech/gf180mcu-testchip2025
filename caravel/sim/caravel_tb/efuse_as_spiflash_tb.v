`default_nettype none

`timescale 1 ns / 1 ps

module efuse_as_spiflash_tb;
    reg clock;
    reg clock2;
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

    always #400 clock <= (clock === 1'b0);
    always #40 clock2 <= (clock2 === 1'b0);

    initial begin
        clock = 0;
    end
    
    `define CHIP_TOP_HIER uut.chip
    `include "sdf.vh" 
    
    `define CHIP_TOP_HIER chip_as_flash.chip
    `include "sdf.vh" 

    initial begin
        $display("Wait for eFuse read-write test to complete");
        wait(gpio == 1'b1);
        wait(gpio == 1'b0);
        wait(gpio == 1'b1);
        wait(gpio == 1'b0);
        wait(gpio == 1'b1);
        $display("Monitor: Test eFuse read-write Passed");
        test_success <= 1'b1;
        #100;
        $finish;
    end

    initial begin
        RSTB <= 1'b0;
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

    // chip_top acting as Caravel
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

    // chip_top acting as SPI memory
    chip_wrapper chip_as_flash ();
    
    assign chip_as_flash.clock = clock2;
    assign chip_as_flash.resetb = RSTB;
    assign chip_as_flash.spi_sclk = flash_clk;
    assign chip_as_flash.spi_cs_efuse = flash_csb;
    assign chip_as_flash.spi_cs_sram = 1'b1;
    assign chip_as_flash.spi_mosi = (flash_io0 === 1'b0) ? 1'b0 : 1'b1; // remove X's on start
    assign flash_io1 = chip_as_flash.spi_miso;


endmodule
`default_nettype wire
