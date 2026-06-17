// Small UART & timer helper funcs

#include <utils.h>

void putchar(char c)
{
    if (c == '\n')
        putchar('\r');
    while (reg_uart_txfull == 1);
        reg_uart_data = c;
}

void print_hex(uint32_t v, int digits)
{
	for (int i = digits - 1; i >= 0; i--) 
    {
		char c = "0123456789abcdef"[(v >> (4*i)) & 15];
		putchar(c);
	}
}

void print(const char *p)
{
    while (*p)
        putchar(*(p++));
}

void delay(const int d)
{
    // Configure timer for a single-shot countdown
	reg_timer0_config = 0;
	reg_timer0_data = d;
    reg_timer0_config = 1;

    // Loop, waiting for value to reach zero
    reg_timer0_update = 1;  // latch current value
    while (reg_timer0_value > 0)
        reg_timer0_update = 1;
}
