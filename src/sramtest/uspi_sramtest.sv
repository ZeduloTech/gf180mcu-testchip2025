/*
 * Copyright (c) 2025 Zedulo
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 Micro SPI controller, all SPI commands are 8 bit long, followed by an 8bit arg
 Returns command bits with top bit set to 1, second byte depends on command.
	CMD:	ARG:		Definition:
	STATUS	field		Returns status for the specific field
	SET	CEN bits	Sets the specified chip-select/enable pin
	ADDRL	addr		Set the address register lower 8 bits
	ADDRH	addr		Set the address register upper 1 bit
	WRITE	data		Writes to the data bus
	READ	n/a		Reads from the data bus
	WRITEI	data		Writes to the data bus and increase address
	READI	n/a		Reads from the data bus and increase address

Write Enable Input. The RAM is in write cycle when sram_write is low. The RAM is in read cycle when sram_write is high.
*/

`define CMD_STATUS 8'h0
`define CMD_CEN_SET 8'h1
`define CMD_WRMASK_SET 8'h2
`define CMD_ADDRL 8'h3
`define CMD_ADDRH 8'h4
`define CMD_WRITE 8'h8 //bit 4 marks write, writes to all banks with CEN enabled
`define CMD_READ0 8'h10 //bit 5 marks read, bit 0:1 marks bank
`define CMD_READ1 8'h11
`define CMD_READ2 8'h12
`define CMD_READ3 8'h13
`define CMDBIT_ADDRINC 8'h20 //bit 6 marks addr increase, combined with read/write
`define CMD_WRITEI 8'h28 
`define CMD_READI0 8'h30
`define CMD_READI1 8'h31
`define CMD_READI2 8'h32
`define CMD_READI3 8'h33

`default_nettype none
`timescale 1 ps / 1 ps


module uspi_sramtest (
    `ifdef USE_POWER_PINS
    inout wire VDD,
    inout wire VSS,
    `endif
	input  wire clk /*verilator public*/,	// clock
	input  wire rst_n /*verilator public*/,	// reset_n - low to reset

	input  wire spi_mosi /*verilator public*/,    	//
	input  wire wspi_clk /*verilator public*/,    	//
	input  wire wspi_cs /*verilator public*/,    	//
	output wire wspi_miso /*verilator public*/,   	//	

	output wire wled_status /*verilator public*/,   //optional
	output wire wled_reset /*verilator public*/,   	//optional
	output wire wdebug /*verilator public*/   	//optional
);

	reg spi_clk_buff[1:0];
	wire spi_clk;
	assign spi_clk = spi_clk_buff[0];
	wire spi_clk_stable;		
	assign spi_clk_stable = spi_clk_buff[0] == spi_clk_buff[1];

	reg spi_miso;
	assign wspi_miso = spi_miso;
	
	reg led_status;
	assign wled_status = led_status;
	reg led_reset;
	assign wled_reset = led_reset;
	reg debug;
	assign wdebug = debug;
	//assign wdebug = spi_clk_stable;

	reg cmd_ready; //0 if no command h as been received, 1 if it has been
	reg [7:0] spi_command;
	

//////////////////////////
	reg sram_addr_inc; //indicates if addr should inc after read/write

	reg sram_write /*verilator public*/;
	reg [3:0] sram_cen /*verilator public*/;	//chip enable, one bit per sram block
	reg [7:0] sram_write_bitmask /*verilator public*/;
	reg [7:0] sram_d_in /*verilator public*/;
	reg [8:0] sram_address /*verilator public*/;

	reg [7:0] sram64_0_d_out/*verilator public*/;
	reg [7:0] sram128_0_d_out/*verilator public*/;
	reg [7:0] sram256_0_d_out/*verilator public*/;
	reg [7:0] sram512_0_d_out/*verilator public*/;

	`ifdef _TESTBENCH
	reg VDD;
	reg VSS;
	assign VDD = 1'b1;
	assign VSS = 1'b0;

	gf180mcu_fd_ip_sram__sram64x8m8wm1 sram64_0(
	clk,
	sram_cen[0],  //chip en for SRAM block 0
	sram_write,  //global write en
	sram_write_bitmask,   //write en
	sram_address[5:0],     //addr
	sram_d_in,     //data in
	sram64_0_d_out,     //data out
	VDD,
	VSS);

	gf180mcu_fd_ip_sram__sram128x8m8wm1 sram128_0(
	clk,
	sram_cen[1],  //chip en for SRAM block 1
	sram_write,  //global write en
	sram_write_bitmask,   //write en
	sram_address[6:0],     //addr
	sram_d_in,     //data in
	sram128_0_d_out,     //data out
	VDD,
	VSS);

	gf180mcu_fd_ip_sram__sram256x8m8wm1 sram256_0(
	clk,
	sram_cen[2],  //chip en for SRAM block 2
	sram_write,  //global write en
	sram_write_bitmask,   //write en
	sram_address[7:0],     //addr
	sram_d_in,     //data in
	sram256_0_d_out,     //data out
	VDD,
	VSS);
	
	gf180mcu_fd_ip_sram__sram512x8m8wm1 sram512_0(
	clk,
	sram_cen[3],  //chip en for SRAM block 3
	sram_write,  //global write en
	sram_write_bitmask,   //write en
	sram_address,     //addr
	sram_d_in,     //data in
	sram512_0_d_out,     //data out
	VDD,
	VSS);
	`else
  gf180_ram_64x8_wrapper sram64_0 (
	.CLK(clk),
	.CEN(sram_cen[0]),  //chip en for SRAM block 3
	.GWEN(sram_write),  //global write en
	.WEN(sram_write_bitmask),   //write en
	.A(sram_address[5:0]),     //addr
	.D(sram_d_in),     //data in
	.Q(sram64_0_d_out)     //data out
     );
     
  gf180_ram_128x8_wrapper sram128_0 (
	.CLK(clk),
	.CEN(sram_cen[1]),  //chip en for SRAM block 3
	.GWEN(sram_write),  //global write en
	.WEN(sram_write_bitmask),   //write en
	.A(sram_address[6:0]),     //addr
	.D(sram_d_in),     //data in
	.Q(sram128_0_d_out)     //data out
     );
  
  gf180_ram_256x8_wrapper sram256_0 (
	.CLK(clk),
	.CEN(sram_cen[2]),  //chip en for SRAM block 3
	.GWEN(sram_write),  //global write en
	.WEN(sram_write_bitmask),   //write en
	.A(sram_address[7:0]),     //addr
	.D(sram_d_in),     //data in
	.Q(sram256_0_d_out)     //data out
     );
  
  gf180_ram_512x8_wrapper sram512_0 (
	.CLK(clk),
	.CEN(sram_cen[3]),  //chip en for SRAM block 3
	.GWEN(sram_write),  //global write en
	.WEN(sram_write_bitmask),   //write en
	.A(sram_address[8:0]),     //addr
	.D(sram_d_in),     //data in
	.Q(sram512_0_d_out)     //data out
     );

	`endif
//////////////////////////


	reg data_ready; //data is ready for use
	reg arm_tx; //put out first tx bit on miso
	reg spi_completed; //tranmission completed flag, rx data in data_reg
	reg prev_spi_clk; //last state of cpi_clk, to detect edges
	reg [7:0] main_reg; //main shiftreg
	reg [2:0] spi_count;
	
	
	always @ (posedge clk or negedge rst_n)
	begin
		//$strobe("spi_clk %d", spi_clk);
		
		//reset sequence
		if(rst_n == 0)begin //0 == reset
			//$display("Reset");
			//SPI regs
			main_reg <= 8'h59;  //no need to clear other regs
			led_reset <= 1'h1; //LED2 on
			led_status <= 1'h1;			
			debug <= 0;
			
			sram_cen <= 0;
			sram_write <= 1; //default read mode
			sram_write_bitmask <= 0; //disable writes on all bits
			sram_d_in <= 0;
			sram_address <= 0;
			sram_addr_inc <= 0;
            
            spi_count <= 0;

		end
		else if(wspi_cs == 1'b1) begin
			// $display("CS high");
			prev_spi_clk <= 1;
			spi_completed <= 0;
			arm_tx <= 1;
			spi_clk_buff[0] <= wspi_clk;
			spi_clk_buff[1] <= wspi_clk;
			data_ready <= 0;
			spi_count <= 0;
			cmd_ready <= 0;
		end
		//normal operation
		else begin
			//$display("SPI: Normal op");
			spi_clk_buff[1] <= spi_clk_buff[0];
			spi_clk_buff[0] <= wspi_clk;
						
			led_reset <= 1'h0; //LED2 off			

			if(data_ready == 1 && cmd_ready == 0)begin
				$display("->Cmd received %h", main_reg[7:0]);
				spi_command <= main_reg;
				main_reg[7] <= 1; //echo back command with top bit set
				cmd_ready <= 1;
				data_ready <= 0;				
				arm_tx <= 1;
				debug <= 1'b0;
				sram_write <= 1; //default to read mode

				if (sram_addr_inc == 1) begin
					sram_addr_inc <= 0;
					sram_address <= sram_address + 1;
				end
			end
			else if(data_ready == 1 && cmd_ready == 1)begin
			
				`ifdef _VERILATOR
				$display("->Target exec. %h with arg %h", spi_command[7:0], main_reg[7:0]);
				`endif

				cmd_ready <= 0;
				data_ready <= 0;				
				arm_tx <= 1;
				debug <= 1'b0;

				case (spi_command)
					`CMD_STATUS : begin
						$display("-- STATUS");
						main_reg <= sram_address[7:0];
					end

					`CMD_CEN_SET : begin //	reg [3:0] sram_cen; //one bit per sram block
						$display("-- CEN SET");
						sram_cen[3:0] <= main_reg[3:0]; //4'b1111;
						main_reg <= main_reg;
					end

					`CMD_WRMASK_SET : begin
						$display("-- SET WRITE BITMASK");
						sram_write_bitmask <= main_reg;  //0 = write, 1 = no write
						main_reg <= main_reg;
					end					
					

					`CMD_ADDRL : begin
						$display("-- ADDRL");
						sram_address[7:0] <= main_reg;
					end

					`CMD_ADDRH : begin
						$display("-- ADDRH");
						sram_address[8] <= main_reg[0];
					end

					`CMD_WRITE : begin
						$display("-- WRITE");
						sram_write <= 0; //write mode
						sram_d_in <= main_reg;
						main_reg[7:0] <= 8'hcc;
					end

					`CMD_READ0 : begin
						$display("-- READ0 %h", sram64_0_d_out);
						main_reg <= sram64_0_d_out;
					end
					`CMD_READ1 : begin
						$display("-- READ1 %h", sram128_0_d_out);
						main_reg <= sram128_0_d_out;
					end
					`CMD_READ2 : begin
						$display("-- READ2 %h", sram256_0_d_out);
						main_reg <= sram256_0_d_out;
					end
					`CMD_READ3 : begin
						$display("-- READ3 %h", sram512_0_d_out);
						main_reg <= sram512_0_d_out;
					end

					`CMD_WRITEI : begin
						$display("-- WRITEI");
						sram_write <= 0; //write mode
						sram_d_in <= main_reg;			
						sram_addr_inc <= 1;
						main_reg[7:0] <= 8'hdd;
					end

					`CMD_READI0 : begin
						$display("-- READI0 %h", sram64_0_d_out);
						main_reg <= sram64_0_d_out;
						sram_addr_inc <= 1;
					end
					`CMD_READI1 : begin
						$display("-- READI1 %h", sram128_0_d_out);
						main_reg <= sram128_0_d_out;
						sram_addr_inc <= 1;
					end
					`CMD_READI2 : begin
						$display("-- READI2 %h", sram256_0_d_out);
						main_reg <= sram256_0_d_out;
						sram_addr_inc <= 1;
					end
					`CMD_READI3 : begin
						$display("-- READI3 %h", sram512_0_d_out);
						main_reg <= sram512_0_d_out;
						sram_addr_inc <= 1;
					end
										
					default : begin //do nothing
						$display("-- UNKNOWN CMD");
						main_reg[7:0] <= 8'hff;
					end
				endcase
			end //
			else if(spi_completed == 1)begin 
				//$display("SPI: completed");
				//spi_count <= 0;
				spi_completed <= 0;
				data_ready <= 1;
			end
			else if(arm_tx == 1)begin
				//$display("SPI: arm tx");
				spi_miso <= main_reg[7];
				arm_tx <= 0;
			end
			else if(spi_clk_stable == 1 && spi_clk == 1 && prev_spi_clk == 0)begin
				//$display("SPI: datatransfer");
				prev_spi_clk <= 1;

				main_reg[7] <= main_reg[6];
				main_reg[6] <= main_reg[5];
				main_reg[5] <= main_reg[4];
				main_reg[4] <= main_reg[3];
				main_reg[3] <= main_reg[2];
				main_reg[2] <= main_reg[1];
				main_reg[1] <= main_reg[0];
				main_reg[0] <= spi_mosi;

				if(spi_count == 7)begin 
					//led_status <= 1'h0; //LED1 off
					spi_completed <= 1;
					debug <= 1'b1;
				end
				
				spi_count <= spi_count + 3'h1;
			end
			// SPI Clock low, put out new data
			else if(spi_clk_stable == 1 && spi_clk == 0 && prev_spi_clk == 1)begin
				spi_miso <= main_reg[7];
				prev_spi_clk <= 0;
			end
			else begin
				spi_completed <= spi_completed;
				prev_spi_clk <= prev_spi_clk;
				spi_count <= spi_count;
				spi_miso <= spi_miso;
				arm_tx <= arm_tx;
				debug <= debug;
			end
			
		end

	end


endmodule

 
