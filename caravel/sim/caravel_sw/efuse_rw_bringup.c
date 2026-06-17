/*
 *  eFuse Wishbone memory read-write test for bringup (without the largest eFuse and with UART output)
 * 
 */ 

//#define READ_ONLY
//#define NO_PRINT

#include <defs.h>
#include <utils.h>

// User Wishbone address
#define USER_WB_ADDR            0x30000000
#define EFUSE_BLOCKS            3   // number of eFuse blocks on chip

const uint32_t efuse_addr[EFUSE_BLOCKS]     = {USER_WB_ADDR+0x1000, USER_WB_ADDR+0x2000, USER_WB_ADDR+0x3000};  // efuse block addresses on WB
const uint32_t efuse_nwords[EFUSE_BLOCKS]   = {64, 128, 32};  // efuse block sizes
const uint32_t efuse_wdt[EFUSE_BLOCKS]      = {32, 8, 8};     // efuse block widths

// User wishbone access helpers
#define write_efuse(s, off, val) {(*(volatile uint32_t*)((s) + (off))) = (val);}
#define read_efuse(s, off) (*(volatile uint32_t*)((s) + (off)))

// --------------------------------------------------------
// Signal test success or failure with IO
// --------------------------------------------------------

static int errors;

void fail(int* e, uint32_t off, uint32_t read, uint32_t expected)
{
    errors++;
    reg_mprj_datal = 2;
    if (!(*e))
    {
        // print only once for block
        print("Wrong data read at offset ");
        print_hex(off, 8);
        print(" expected ");
        print_hex(expected, 8);
        print(" got ");
        print_hex(read, 8);
        nl();
    }
    (*e)++;
}

void success()
{
    // blink GPIO indefinetely
    int gpio = 1;
    while (1) 
    {
        reg_gpio_out = gpio;
        gpio = !gpio;
		delay(2000000);
    }
}

// --------------------------------------------------------
// Main & test
// --------------------------------------------------------

#define mem_word(s, i, m) ((((i + s)*0x3751E19B) ^ 0xAABBCCDD) & m) // trivial pseudo-random

#ifdef NO_PRINT
// Put test function to data section to speedup test (will be copied and executed from SRAM)
void test_efuse(uint32_t start, uint32_t size, uint32_t mask) __attribute__((section(".data")));
#endif

void test_efuse(uint32_t start, uint32_t size, uint32_t mask)
{
    print("Testing eFuse block at ");
    print_hex(start, 8);
    nl();
    print("First word is: ");
    print_hex(read_efuse(start, 0), 8);
    nl();
    
    #ifndef READ_ONLY
    // Write efuse
    for (int i = 0; i < size; i++)
        write_efuse(start, i*4, mem_word(start, i, mask));
    print("Write completed. First word is: ");
    print_hex(read_efuse(start, 0), 8);
    nl();
    #endif
        
    // Read efuse
    int e = 0;
    for (int i = 0; i < size; i++)
    {
        uint32_t r = read_efuse(start, i*4);
        if (r != mem_word(start, i, mask))
            fail(&e, i*4, r, mem_word(start, i, mask));
    }
    
    if (e)
    {
        print("Read error count: 0x");
        print_hex(e, 4);
        nl();
    }
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
    
    print("Starting eFuse test...\n\n");
    
    for (int n = 0; n < EFUSE_BLOCKS; n++)
        test_efuse(efuse_addr[n], efuse_nwords[n], (1ull<<efuse_wdt[n])-1);
    
    print("\nTest completed!\n");
    
    if (!errors)
        success();
    else
        reg_gpio_out = 1;
        
    print("Got a total of 0x");
    print_hex(errors, 8);
    print(" errors\n");
}

