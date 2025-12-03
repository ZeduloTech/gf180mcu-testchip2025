`ifndef _PINOUT_VH
`define _PINOUT_VH

// Caravel pad assignment

`define PAD_CARAVELIO_0     0
`define PAD_GPIO            13
`define PAD_FLASH_CSB       14
`define PAD_FLASH_CLK       15
`define PAD_FLASH_IO0       16
`define PAD_FLASH_IO1       17

`define PAD_CARAVEL_END     `PAD_FLASH_IO1

`define PADI_START_MODE     11

// Async eFuse pads
`define PADI_AEF_RESET      0
`define PADI_AEF_PROG_LOW   1
`define PADI_AEF_PROG_HIGH  8
`define PAD_AEF_OUT_LOW     25
`define PAD_AEF_OUT_HIGH    32
`define PAD_AEF_READY       24

// SRAM test pads

`define PAD_SRAM_LOW        33

`define PAD_SRAM_LEDRESET   33
`define PAD_SRAM_LEDSTATUS  34
`define PAD_SRAM_SPIDEBUG   35
`define PAD_SRAM_SPICS      36
`define PAD_SRAM_SPICLK     37
`define PAD_SRAM_SPIMISO    38
`define PAD_SRAM_SPIMOSI    39

`define PAD_SRAM_HIGH       39

//Unused pins, take pins from here and modify low/high
//to ensure all unused pins are properly defined

`define PAD_UNUSED_LOW      18
`define PAD_UNUSED_HIGH     23

`endif
