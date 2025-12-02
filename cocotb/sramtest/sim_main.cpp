/*
 * Copyright (c) 2025 Zedulo
 * SPDX-License-Identifier: Apache-2.0
 */
 
#include <stdio.h>

#include "Vuspi_sramtest.h"
#include "Vuspi_sramtest_uspi_sramtest.h"
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

*/

#define CMD_STATUS (0x00)
#define CMD_CEN_SET (0x01)
#define CMD_WRMASK_SET (0x02)
#define CMD_ADDRL (0x03)
#define CMD_ADDRH (0x04)
#define CMD_WRITE (0x08)
#define CMD_READ0 (0x10)
#define CMD_READ1 (0x11)
#define CMD_READ2 (0x12)
#define CMD_READ3 (0x13)
#define CMD_WRITEI (0x28)
#define CMD_READI0 (0x30)
#define CMD_READI1 (0x31)
#define CMD_READI2 (0x32)
#define CMD_READI3 (0x33)

Vuspi_sramtest* top = new Vuspi_sramtest;

uint64_t ticks = 0; //1 tick is low or high
uint64_t cycles = 0; //cycle is going high. I.e. cycle ~= 2xticks

int tick()
{
        static int clockphase = 0;

        if(clockphase == 0){
                ticks++;
                clockphase = 1;
                top->clk = 1;
                top->eval();
        }else{
                ticks++;
                cycles++;
                clockphase = 0;
                top->clk = 0;
                top->eval();
        }
        return ticks;
}

#define SPI_CLK_SET (top->wspi_clk = 1)
#define SPI_CLK_CLEAR (top->wspi_clk = 0)

#define SPI_DATA_SET (top->spi_mosi = 1)
#define SPI_DATA_CLEAR (top->spi_mosi = 0)


#define DATABUFF_SZ (100000)

#define SRAM_START_ADDRL (0xf0)
#define SRAM_START_ADDRH (0x00)
#define SRAM_TEST_LENGTH (10)

//Load data and return number of entries loaded

int load_dataout(char *dout)
{
	int i = 0;
	dout[i++] = CMD_STATUS; //status
	dout[i++] = 0xf0; //arg

	dout[i++] = CMD_CEN_SET; //CEN SET
	dout[i++] = 0x0f; //arg
	dout[i++] = CMD_CEN_SET; //CEN CLEAR
	dout[i++] = 0x00; //arg	

	dout[i++] = CMD_WRMASK_SET; //Set write bitmask
	dout[i++] = 0x00; //arg	  00 = write to all bits

	dout[i++] = CMD_ADDRL; //Set lower bits of addr
	dout[i++] = SRAM_START_ADDRL; //arg	
	dout[i++] = CMD_ADDRH; //Set top bit of addr
	dout[i++] = SRAM_START_ADDRH; //arg	

	dout[i++] = CMD_STATUS; //status, read back addr low
	dout[i++] = 0x00; //arg

/*
	for(int addr = 0; addr < 10; addr++) {
		dout[i++] = CMD_WRITE; //WRITE from addr
		dout[i++] = 0xa0 + addr; //

		dout[i++] = CMD_ADDRL; //Set lower bits of addr
		dout[i++] = addr + 1; //arg	
	}
*/

	for(int addr = 0; addr < SRAM_TEST_LENGTH; addr++) {
		dout[i++] = CMD_WRITEI; //WRITE from addr
		dout[i++] = 0xa0 + addr;
	}

	dout[i++] = CMD_STATUS; //status, read back addr low
	dout[i++] = 0x00; //arg

	dout[i++] = CMD_ADDRL; //Set lower bits of addr
	dout[i++] = SRAM_START_ADDRL; //arg
	dout[i++] = CMD_ADDRH; //Set top bit of addr
	dout[i++] = SRAM_START_ADDRH; //arg

/*	for(int addr = 0; addr < 10; addr++) {
		dout[i++] = CMD_READ; //READ from addr
		dout[i++] = //

		dout[i++] = CMD_ADDRL; //Set lower bits of addr
		dout[i++] = addr + 1; //arg	
	}
*/

	for(int addr = 0; addr < SRAM_TEST_LENGTH; addr++) {
		dout[i++] = CMD_READI1; //READ from addr
		dout[i++] = addr; //for debugging
	}

	//last one
	dout[i++] = CMD_STATUS; //status
	dout[i] = 0x00; //arg

	return i;
}

int print_sram_regs()
{
	printf("Write 0x%x\n", top->uspi_sramtest->sram_write);
	printf("CEN 0x%x\n", top->uspi_sramtest->sram_cen);
	printf("Wr Bitmask 0x%x\n", top->uspi_sramtest->sram_write_bitmask);
	printf("Din 0x%x\n", top->uspi_sramtest->sram_d_in);
	printf("Dout64 0x%x\n", top->uspi_sramtest->sram64_0_d_out);
	printf("Dout128 0x%x\n", top->uspi_sramtest->sram128_0_d_out);
	printf("Dout256 0x%x\n", top->uspi_sramtest->sram256_0_d_out);
	printf("Dout512 0x%x\n", top->uspi_sramtest->sram512_0_d_out);
	printf("addr 0x%x\n", top->uspi_sramtest->sram_address);

	return 0;
}

int main(int argc, char** argv, char** env)
{
	char spi_in, spi_out, spi_cycles;
	
	char dout[DATABUFF_SZ] = {0};
	char din[DATABUFF_SZ] = {0};
	
	int bytes_to_transfer = load_dataout(dout);
	int dindex = 0;
	

	if(DATABUFF_SZ <= bytes_to_transfer) {
		printf("Error: dataset allocated %d, prepared %d bytes to send\n", DATABUFF_SZ, bytes_to_transfer);
		printf("Increase dataset or decrease bytes to send\n");
		return -1;
	}
	
	//Init
	Verilated::commandArgs(argc, argv);

	//Model reset:
	SPI_CLK_SET; //by default it should be high
	top->rst_n = 1;
	top->clk = 0;
	tick();
	tick();
	top->rst_n = 0; //reset
	tick();
	tick();
	top->rst_n = 1; //release
	tick();
	tick();

	top->wspi_cs = 1; //SPI CS high, spi not selected
	tick();
	tick();
	tick();
	tick();

	top->wspi_cs = 0; //SPI CS low, spi ready for transfer
	tick();
	tick();
	tick();
	tick();

	//Run simulation:
	printf("Start sim\n");
	spi_cycles = 0;
	spi_in = 0;
	spi_out = dout[dindex++];
	printf("Host Loading TX: 0x%02x\n", spi_out & 0x00ff);

	SPI_CLK_CLEAR; //start SPI transfer
	tick();
	tick();
	tick();
	tick();

	int update_mosi = 1;
	
	for(int i = 0; dindex != (bytes_to_transfer + 1); i++) {


		if(update_mosi == 1) {
			((spi_out & 0x80) == 0) ? SPI_DATA_CLEAR : SPI_DATA_SET;
			spi_out = spi_out << 1;
			
			update_mosi = 0;
		}
	
		if(i % 6 == 0) { //tick the SPI clock
		
			if(top->wspi_clk == 0) { //SPI clock is low, put out new data
				//printf("** CLOCK LOW\n");
				SPI_CLK_SET;
			}
			else {	//SPI clock is high, sample data
				//printf("** CLOCK HIGH %d\n", spi_cycles);
				spi_in = spi_in << 1 | top->wspi_miso;
				//printf("spi_in: 0x%x\n", spi_in);

				if(spi_cycles == 7) {
					spi_cycles = 0;
					printf("Host RX: 0x%02x\n\n", spi_in & 0x00ff);
					din[dindex] = spi_in & 0x00ff;
					spi_in = 0;
					spi_out = dout[dindex++]; //prepare next byte   0x10;
					printf("Host Loading TX: 0x%02x\n", spi_out & 0x00ff);
				}
				else spi_cycles++;
				SPI_CLK_CLEAR;
				update_mosi = 1;
			}

		} //if i % 3
		tick();
		tick();
	} //for int i...

	print_sram_regs();

	printf("---- Data reveived:\n");
	for(int i = 0; i < bytes_to_transfer + 1; i++) {
		printf("Din[%d]: 0x%02x\n", i, din[i] & 0x00ff);
	}

	printf("---- Read data:\n");
	int error = 0;
	int exp = 0xa0;

	for(int i = 0; i < bytes_to_transfer + 1; i+=2) {
		if((din[i] & 0x0010) == 0x10) {
			if(exp != (din[i+1] & 0x00ff)) {
				//printf("ERROR: ");
				error++;
			}
			printf("%d  0x%02x\n", i, din[i+1] & 0x00ff);
			//printf("%d  0x%02x  expected 0x%02x\n", i, din[i+1] & 0x00ff, exp);

			exp++;
			exp = exp % 0x100;
		}
	}

	//Done. Let's wrap up...
	top->final();
	delete top;

//	printf("Done: %d errors\n", error);

	if(error != 0)return -1;
	return 0;
}

