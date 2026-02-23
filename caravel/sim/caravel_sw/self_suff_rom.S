// Very simple test to toggle GPIO from eFuse ROM

#ifndef CSR_BASE
#define CSR_BASE 0xF0000000L
#endif
#define CSR_GPIO_IEN_ADDR (CSR_BASE + 0x2808L)
#define CSR_GPIO_OE_ADDR (CSR_BASE + 0x280CL)
#define CSR_GPIO_OUT_ADDR (CSR_BASE + 0x2814L)

.section .efuse
_start:
.global _start

la t0, CSR_GPIO_IEN_ADDR
addi t1, zero, 1
sw t1, 0(t0)
la t0, CSR_GPIO_OE_ADDR
sw zero, 0(t0)
la t0, CSR_GPIO_OUT_ADDR
loop: 
sw zero, 0(t0)
sw t1, 0(t0)
j loop
