/*
 *  eFuse Wishbone memory read-write test
 * 
 */ 

#include <defs.h>

// User Wishbone address
#define USER_WB_ADDR            0x30000000
#define EFUSE0_ADDR             USER_WB_ADDR
#define EFUSE1_ADDR             (USER_WB_ADDR + 0x100000)

#define EFUSE_WDT               8   // efuse word size in bits
#define EFUSE_SIZE              64  // efuse size in words

// User wishbone access helpers
#define efuse_addr(n) (n ? EFUSE1_ADDR : EFUSE0_ADDR)
#define write_efuse(n, off, val) {(*(volatile uint32_t*)(efuse_addr(n) + (off))) = (val);}
#define read_efuse(n, off) (*(volatile uint32_t*)(efuse_addr(n) + (off)))

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
// Main
// --------------------------------------------------------

#define mem_word(n, i) ((i+n) & ((1<<EFUSE_WDT)-1))

void main()
{
    // Configure IO pads & enable GPIO, UART and user Wishbone
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;

    reg_uart_enable = 1;
    reg_wb_enable = 1;
    
    for (int n = 0; n < 2; n++)
    {
        // Write efuse
        for (int i = 0; i < EFUSE_SIZE; i++)
            write_efuse(n, i*4, mem_word(n, i));
            
        // Read efuse
        for (int i = 0; i < EFUSE_SIZE; i++)
            if (read_efuse(n, i*4) != mem_word(n, i))
                fail();
    }
        
    success();
}

