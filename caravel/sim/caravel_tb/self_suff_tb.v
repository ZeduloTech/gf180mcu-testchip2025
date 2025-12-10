// Test "self sufficient" Caravel start mode

`default_nettype none

`timescale 1 ns / 1 ps

module self_suff_tb;
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

	assign uart_tx = mprj_io[6];
	assign mprj_io[5] = uart_rx;

	initial begin
		clock = 1'b0;
        uut.self_sufficient = 1'b1; // enable self-sufficient mode
	end
	
	`define CHIP_TOP_HIER uut.chip
    `include "sdf.vh"

	initial begin
		$display("Wait for self sufficient test to complete");
        wait(gpio == 1'b1);
        $display("Monitor: Test self sufficient Passed");
        test_success <= 1'b1;
        #1000000;
		$finish;
	end
    
    // no reset, no flash, no clock
    assign RSTB = 1'b1;

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		#2000;
		power1 <= 1'b1;
	end

	wire VDD5V0;
	wire VSS;

	assign VDD5V0 = power1;
	assign VSS = 1'b0;
	
	assign mprj_io[3] = 1'b1;  // Force CSB high.
	assign mprj_io[0] = 1'b0;  // Disable debug mode
    
	caravel uut (
        `ifdef USE_POWER_PINS
		.VDD	  (VDD5V0),
		.VSS	  (VSS),
        `endif
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

endmodule
`default_nettype wire
