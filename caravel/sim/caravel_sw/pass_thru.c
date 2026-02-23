#include <defs.h>
 
void main()
{
    // keep CPU busy while flash is accessed
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oeb = 0;

    reg_gpio_out = 1;
    reg_gpio_out = 0;
    
    while(1);
}

