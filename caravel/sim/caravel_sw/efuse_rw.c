/*
 *  eFuse Wishbone memory read-write test
 * 
 */ 

#include <defs.h>

// User Wishbone address
#define USER_WB_ADDR            0x30000000
#define EFUSE_BLOCKS            4   // number of eFuse blocks on chip

const uint32_t efuse_addr[EFUSE_BLOCKS]     = {USER_WB_ADDR, USER_WB_ADDR+0x1000, USER_WB_ADDR+0x2000, USER_WB_ADDR+0x3000};  // efuse block addresses on WB
const uint32_t efuse_nwords[EFUSE_BLOCKS]   = {1024, 128, 64, 32};  // efuse block sizes
const uint32_t efuse_wdt[EFUSE_BLOCKS]      = {32, 8, 32, 8};       // efuse block widths

// User wishbone access helpers
#define write_efuse(s, off, val) {(*(volatile uint32_t*)((s) + (off))) = (val);}
#define read_efuse(s, off) (*(volatile uint32_t*)((s) + (off)))

// --------------------------------------------------------
// Signal test success or failure with IO
// --------------------------------------------------------

void fail()
{
    // raise IO[1] on failure (HK SPI should not be used)
    reg_mprj_datal = 2;
}

void success()
{
    // raise GPIO pin on success
    reg_gpio_out = 1;
}

// --------------------------------------------------------
// Main & test
// --------------------------------------------------------

#define mem_word(s, i, m) ((((i + s)*0x3751E19B) ^ 0xAABBCCDD) & m) // trivial pseudo-random

// Put test function to data section to speedup test (will be copied and executed from SRAM)
void test_efuse(uint32_t start, uint32_t size, uint32_t mask) __attribute__((section(".data")));

void test_efuse(uint32_t start, uint32_t size, uint32_t mask)
{
    // Write efuse
    for (int i = 0; i < size; i++)
        write_efuse(start, i*4, mem_word(start, i, mask));
        
    // Read efuse
    for (int i = 0; i < size; i++)
        if (read_efuse(start, i*4) != mem_word(start, i, mask))
            fail();
}

void main()
{
    // Configure IO pads & enable GPIO, UART and user Wishbone
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;

    reg_uart_enable = 1;
    reg_wb_enable = 1;
    
    for (int n = 0; n < EFUSE_BLOCKS; n++)
        test_efuse(efuse_addr[n], efuse_nwords[n], (1ull<<efuse_wdt[n])-1);
        
    success();
}

