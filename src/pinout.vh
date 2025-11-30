// Caravel pad assignment

`ifndef _PINOUT_VH
`define _PINOUT_VH

`define PAD_CARAVELIO_0 0
`define PAD_GPIO        13
`define PAD_FLASH_CSB   14
`define PAD_FLASH_CLK   15
`define PAD_FLASH_IO0   16
`define PAD_FLASH_IO1   17

`define PAD_CARAVEL_END `PAD_FLASH_IO1


//SRAM test
`define PAD_SRAM_SPIMOSI   39
`define PAD_SRAM_SPIMISO   38
`define PAD_SRAM_SPICLK    37
`define PAD_SRAM_SPICS     36
`define PAD_SRAM_SPIDEBUG  35
`define PAD_SRAM_LEDSTATUS 34
`define PAD_SRAM_LEDRESET  33

`endif
