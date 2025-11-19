/*
 *  Simple test for Wishbone counter demo on gf180mcu Caravel project template
 * 
 */ 

#include <defs.h>

// User Wishbone address
#define USER_WB_ADDR            0x30000000

// User wishbone access helpers
#define write_user_reg(off, val) {(*(volatile uint32_t*)(USER_WB_ADDR + (off))) = (val);}
#define read_user_reg(off) (*(volatile uint32_t*)(USER_WB_ADDR + (off)))

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

uint32_t check_counter(uint32_t cnt)
{
    uint32_t ncnt = read_user_reg(0);
    if (cnt >= ncnt)
        fail();
    return ncnt;
}

// --------------------------------------------------------
// Main
// --------------------------------------------------------

void main()
{
	int i, j, k;

    // Configure IO pads & enable GPIO, UART and user Wishbone
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;

    reg_uart_enable = 1;
    reg_wb_enable = 1;
    
    // Test Wishbone counter
    uint32_t cnt = read_user_reg(0);
    cnt = check_counter(cnt);
    cnt = check_counter(cnt);
    cnt = check_counter(cnt);
    cnt = check_counter(cnt);
    
    const uint32_t set_val = 0xAABBCCDD;
    write_user_reg(0, set_val);    
    if (read_user_reg(0) <= set_val)
        fail();
        
    success();
}

