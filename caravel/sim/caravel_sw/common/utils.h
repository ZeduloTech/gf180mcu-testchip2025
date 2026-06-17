#ifndef __UTILS_H
#define __UTILS_H

#include <defs.h>

#ifndef NO_PRINT
void putchar(char c);
void print_hex(uint32_t v, int digits);
void print(const char *p);
#else
#define putchar(c)
#define print_hex(v, d)
#define print(p)
#endif

#define nl() putchar('\n')
#define space() putchar(' ')

void delay(const int d);

#endif
