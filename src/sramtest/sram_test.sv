// SPDX-FileCopyrightText: © 2025 Zedulo
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
//`include "pinout.vh"
//`include "defines.v" // from Caravel

module sram_test (
    `ifdef USE_POWER_PINS
    inout wire VDD,
    inout wire VSS,
    `endif
     
    input  logic clk,       // clock
    input  logic rst_n,     // reset (active low)

    input wire [1:0] bank_select,
    output wire [7:0] sram_out
);

    reg [7:0] sram64_0_out;
    reg [7:0] sram128_0_out;
    reg [7:0] sram256_0_out;
    reg [7:0] sram512_0_out;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            sram_out <= '0;
        end else begin
            case (bank_select[1:0])
    	        2'h0 : begin
    	            sram_out <= sram64_0_out;
	        	end

    	        2'h1 : begin
    	            sram_out <= sram128_0_out;
	        	end

    	        2'h2 : begin
    	            sram_out <= sram256_0_out;
	        	end

    	        2'h3 : begin
    	            sram_out <= sram512_0_out;
	        	end
            endcase //end case
        end //end else begin
    end //end always_ff

  gf180_ram_64x8_wrapper sram64_0 (
//   `ifdef USE_POWER_PINS
//    inout wire VDD,
//    inout wire VSS,
//    `endif
     .CLK(clk), 
     .CEN(1'b1), 
     .GWEN(1'b1), 
     .WEN(8'b1111_1111), 
     .A(5'b0_0000), 
     .D(8'b0), 
     .Q(sram64_0_out) );
     
  gf180_ram_128x8_wrapper sram128_0 (
//      `ifdef USE_POWER_PINS
//    inout wire VDD,
//    inout wire VSS,
//    `endif
     .CLK(clk),
     .CEN(1'b1),
     .GWEN(1'b1),
     .WEN(8'b1111_1111),
     .A(5'b0_0000),
     .D(8'b0),
     .Q(sram128_0_out) );
  
  gf180_ram_256x8_wrapper sram256_0 (
//      `ifdef USE_POWER_PINS
//    inout wire VDD,
//    inout wire VSS,
//    `endif
    .CLK(clk),
    .CEN(1'b1),
    .GWEN(1'b1),
    .WEN(8'b1111_1111),
    .A(5'b0_0000),
    .D(8'b0),
    .Q(sram256_0_out) );
  
  gf180_ram_512x8_wrapper sram512_0 (
//      `ifdef USE_POWER_PINS
//    inout wire VDD,
//    inout wire VSS,
//    `endif
    .CLK(clk),
    .CEN(1'b1),
    .GWEN(1'b1),
    .WEN(8'b1111_1111),
    .A(5'b0_0000),
    .D(8'b0),
    .Q(sram512_0_out) );

endmodule

`default_nettype wire
