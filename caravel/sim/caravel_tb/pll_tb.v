// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

module pll_tb;
    reg clock;
    reg power1;
    reg RSTB;

    wire gpio;
    wire [15:0] checkbits;
    wire [7:0] spivalue;
    wire [37:0] mprj_io;
    wire flash_csb;
    wire flash_clk;
    wire flash_io0;
    wire flash_io1;
    wire SDO;
    wire uart_tx;
    
    reg test_success;

    integer ccount;
    integer ucount;

    assign checkbits = mprj_io[31:16];
    assign spivalue  = mprj_io[15:8];
    assign uart_tx = mprj_io[6];

    // External clock is used by default.  Make this artificially fast for the
    // simulation.  Normally this would be a slow clock and the digital PLL
    // would be the fast clock.
    
    localparam EXT_PERIOD = 200;
    real EXT_FREQ = 1000.0 / EXT_PERIOD;

    always #(EXT_PERIOD / 2) clock <= (clock === 1'b0);

    // User clock monitoring
    always @(posedge mprj_io[32]) begin
        ucount = ucount + 1;
    end

    // Core clock monitoring
    always @(posedge mprj_io[33]) begin
        ccount = ccount + 1;
    end

    initial begin
        clock = 0;
    end
    
    `ifdef ENABLE_SDF
    initial begin
        $sdf_annotate({`FINAL_PREFIX, "/sdf/nom_tt_025C_5v00/chip_top__nom_tt_025C_5v00.sdf"}, uut.chip );
        $sdf_annotate({`CARAVEL_FINAL_PREFIX, "/sdf/nom_tt_025C_5v00/caravel_core__nom_tt_025C_5v00.sdf"}, uut.chip.\i_chip_core.caravel );
        $sdf_annotate({`OSC_FINAL_PREFIX, "/sdf/nom_tt_025C_5v00/ring_osc2x13__nom_tt_025C_5v00.sdf"}, uut.chip.\i_chip_core.caravel .\pll.ringosc  );
    end
    `endif 

    initial begin
        //$dumpfile("pll.vcd");
        //$dumpvars(0, pll_tb);
        repeat (50) begin
            repeat (1000) @(posedge clock);
            //$display("+1000 cycles");
        end
        $display("%c[1;31m",27);
        $display ("Monitor: Timeout, PLL test Failed");
        $display("%c[0m",27);
        $finish;
    end
    
    integer test_num = 1;
    task pll_test_cycle(
        input [255:0] name, input integer mtime, 
        input real cdivisor, input real udivisor, 
        input real min_freq, input real max_freq); 
        
        real cfreq, ufreq;
        begin
            wait(gpio == 1'b1);
            $display("Monitor: PLL Test %d - %s", test_num, name);
            ucount = 0;
            ccount = 0;
            #(1000 * mtime);
            cfreq = ccount * cdivisor / mtime;
            ufreq = ucount * udivisor / mtime;
            $display("Monitor: core prediv frequency = %f MHz, user prediv frequency = %f MHz", cfreq, ufreq);
    
            if (cfreq < min_freq || cfreq > max_freq || 
                ufreq < min_freq || cfreq > max_freq ||
                (ufreq/cfreq) < 0.97 || (cfreq/ufreq) < 0.97
            ) begin
                #10;
                $display("Monitor: PLL test Failed");
                $finish;
            end
            wait(gpio == 1'b0);
            
            test_num = test_num + 1;
        end
    endtask

    // Monitor
    real freq;
    initial begin

        pll_test_cycle("PLL disabled", 100, 1, 1, EXT_FREQ*0.99, EXT_FREQ*1.01);
        pll_test_cycle("PLL bypass", 100, 1, 1, EXT_FREQ*0.99, EXT_FREQ*1.01);
        pll_test_cycle("PLL max frequency", 10, 7, 1, 20, 200);
        pll_test_cycle("PLL min frequency", 50, 2, 2, 10, 100);
        pll_test_cycle("PLL 50MHz frequency", 20, 4, 4, 45, 55);
        pll_test_cycle("DCO default", 10, 5, 2, 20, 100);
        pll_test_cycle("DCO max", 10, 6, 3, 50, 200);

        $display("Monitor: Test PLL (RTL) Passed");
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

    initial begin
        power1 <= 1'b0;
        #200;
        power1 <= 1'b1;
    end

    always @(checkbits) begin
        #1 $display("GPIO state = %b ", checkbits);
    end

    wire VDD5V0;
    wire VSS;
    
    assign VDD5V0 = power1;
    assign VSS = 1'b0;

    assign mprj_io[3] = 1'b1;  // Force CSB high.

    caravel uut (
        `ifdef USE_POWER_PINS
        .VDD      (VDD5V0),
        .VSS      (VSS),
        `endif
        .clock    (clock),
        .gpio     (gpio),
        .mprj_io  (mprj_io),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0(flash_io0),
        .flash_io1(flash_io1),
        .resetb      (RSTB)
    );

    spiflash #(
        .FILENAME({`HEX_PREFIX, "pll.hex"})
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
