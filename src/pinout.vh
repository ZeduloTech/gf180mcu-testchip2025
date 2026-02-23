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
`define PADI_AEF_RESET      10
`define PADI_AEF_PROG_LOW   2
`define PADI_AEF_PROG_HIGH  9
`define PAD_AEF_OUT_LOW     25
`define PAD_AEF_OUT_HIGH    32
`define PAD_AEF_READY       24

// uart2gpi
`define PAD_UART2GPI_LOW0   18
`define PAD_UART2GPI_GPIO0  18
`define PAD_UART2GPI_GPIO1  19
`define PAD_UART2GPI_GPIO2  20
`define PAD_UART2GPI_GPIO3  21
`define PAD_UART2GPI_PWM0   22
`define PAD_UART2GPI_PWM1   23
`define PAD_UART2GPI_HIGH0  23

`define PAD_UART2GPI_LOW1   33
`define PAD_UART2GPI_I2CSDA 33
`define PAD_UART2GPI_I2CSCL 34
`define PAD_UART2GPI_UARTTX 35
`define PAD_UART2GPI_UARTRX 36
`define PAD_UART2GPI_HIGH1  36

// SRAM test pads

`define PAD_SRAM_LOW        37
`define PAD_SRAM_SPIDEBUG   37
`define PAD_SRAM_SPICS      38
`define PAD_SRAM_SPICLK     39
`define PAD_SRAM_SPIMISO    40
`define PAD_SRAM_SPIMOSI    41
`define PAD_SRAM_HIGH       41

// SPI eFuse
`define PADI_SEF_SPICS      1

//Unused pins, take pins from here and modify low/high
//to ensure all unused pins are properly defined

//`define PAD_UNUSED_LOW      - all are used!
//`define PAD_UNUSED_HIGH     -

`endif
