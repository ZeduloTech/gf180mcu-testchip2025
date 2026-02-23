/*
 *  eFuse Wishbone memory read-write test
 * 
 */ 

#include <defs.h>

// User Wishbone address
#define USER_WB_ADDR            0x30004000
#define EFUSE_BLOCKS            4   // number of eFuse blocks on chip

// User wishbone access helpers
#define write_efuse(val) {(*(volatile uint32_t*)(USER_WB_ADDR)) = (val);}
#define write_efuse_byte(i, val) {(*(volatile uint8_t*)(USER_WB_ADDR + i)) = (val); \
    for (volatile int i = 0; i < 100; i++);\
    write_efuse(0);}
#define read_efuse() (*(volatile uint32_t*)(USER_WB_ADDR))

// --------------------------------------------------------
// Signal test success or failure with IO
// --------------------------------------------------------

void fail()
{
    // raise IO[1] on failure (HK SPI should not be used)
    reg_mprj_datal = 2;
    while(1);
}

void success()
{
    // raise GPIO pin on success
    reg_gpio_out = 1;
    while(1);
}

void success2()
{
    // raise GPIO pin twice on read success
    reg_gpio_out = 1;
    reg_gpio_out = 0;
    reg_gpio_out = 1;
    while(1);
}

// --------------------------------------------------------
// Main
// --------------------------------------------------------

#define TEST_WORD   0xDEADBEEF

void main()
{
    // Configure IO pads & enable GPIO, UART and user Wishbone
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;

    reg_uart_enable = 1;
    reg_wb_enable = 1;
    
    // On first boot eFuse will contain zeroes, on second - TEST_WORD
    uint32_t ef = read_efuse();
    if (ef == TEST_WORD) {
        success2();
    }
    
    if (ef != 0)
        fail();
    
    // Write TEST_WORD byte by byte to eFuse on first boot, will be reread after reboot
    for (int i = 0; i < 4; i++)
        write_efuse_byte(i, (TEST_WORD >> i*8) & 0xFF);
    
    if (read_efuse() != 0)
        fail();
        
    success();
}

