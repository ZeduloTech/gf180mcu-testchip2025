# TillitisZedulo-testchip2025

This test chip was put together by the Zedulo Tech team and [@egorxe](https://github.com/egorxe) . It was taped out on the wafer.space Run-1 using open source PDK GF180MCU technology. The main goal for this tapeout was to test the flow and several open-source IPs. 

IPs present on chip:
1. Caravel test harness [port](https://github.com/egorxe/gf180mcu-caravel-template).
2. Zedulo UART2GPI IP.
3. Several blocks of eFuse memory generated with the [gf180mcu eFuse compiler](https://github.com/egorxe/gf180_efuse_compiler).
4. SPI-controlled SRAM memory.

![](https://github.com/ZeduloTech/gf180mcu-testchip2025/blob/main/doc/chip_top_annotated.png)

## IPs

### Caravel core

This project is based on the Caravel project template for wafer.space. Caravel VexRiscv CPU core is mostly used to control the Wishbone bus connected to the eFuse blocks. For more info on the Caravel, please check the [template repository](https://github.com/egorxe/gf180mcu-caravel-template) and the [original Caravel documentation](https://caravel-harness.readthedocs.io).

Caravel CPU address map:

| Base address | Function                            |
|--------------|-------------------------------------|
| 0x1000_0000  | SPI flash                           |
| 0x2600_0000  | User project control                |
| 0x2610_0000  | Housekeeping                        |
| 0x3000_0000  | 1024x32 WB eFuse                    |
| 0x3000_1000  | 64x32 WB eFuse                      |
| 0x3000_2000  | 128x8 WB eFuse                      |
| 0x3000_3000  | 32x8 WB eFuse                       |
| 0x3000_4000  | WB-mapped async eFuse               |
| 0xF000_0000  | LiteX CSR (inc. UART, timer & GPIO) |

### eFuse

Three variations of eFuse blocks are present on this chip:

1. Synchronous eFuse memory with Wishbone interface connected to the Caravel core. Four blocks of different sizes: 1024x32, 128x8, 32x8, 64x32 (`ip/efuse_wb_mem_*`).
2. Synchronous eFuse memory with SPI interface connected to the external pads. (`ip/efuse_spi_mem_256x8`). Supported SPI protocol is a subset of the common SPI EEPROM protocol used, for example, in 25-series EEPROM devices.
3. Asynchronous eFuse memory, which is read and latched once on reset (`ip/efuse_async_mem_1x8`). Five blocks are present, four of them are mapped to the Caravel Wishbone as a single 32-bit memory word, and the interface of the remaining one is mapped to the external pads.

For more info on eFuse, please check the documentation in the [eFuse compiler repository](https://github.com/egorxe/gf180_efuse_compiler).

### UART2GPI

TODO

### SPI SRAM

TODO

## Design implementation

This repository contains a Nix flake that provides a shell with the [`leo/gf180mcu`](https://github.com/librelane/librelane/tree/leo/gf180mcu) branch of LibreLane.

Simply run `nix-shell` in the root of this repository.

With this shell enabled, run the implementation, first implementing the Caravel core (can be skipped as all required files are already in the repository):

```
make caravel-librelane
```

After Caravel implementation is done, run the implementation of the chip top:

```
make librelane
```

To run everything at once:
```
make all
```

For more info, please see the original [gf180mcu-project-template](https://github.com/wafer-space/gf180mcu-project-template) and check the GitHub CI scripts in this repository.

## Verification and Simulation

Verification is based on the cocotb using Icarus Verilog as the default simulator and extending the gf180mcu-caravel-template testbench. To run all the provided tests on behavioral RTL, please run:
```
make sim
```

To run all the tests on the post-implementation gate-level netlist (will be present in the `final` folder after implementation), run:
```
make sim-gl
```

Cocotb testbench is located in `cocotb/chip_top_tb.py` and can be run either directly with Python or via pytest. Makefile targets launch all the tests via pytest with the number of parallel runs equivalent to the number of available CPU threads. The list of available tests can be found in `cocotb/test_list.json`. Each test has a dictionary associated with it, allowing to pass additional parameters to the cocotb test if needed. 

For example, to run the uart2gpi test with python, cd to the `cocotb` dir and launch:
```
TEST=uart2gpi python3 chip_top_tb.py
```

The same with pytest (easier test management, but no real-time testbench output to the terminal):
```
pytest --test=uart2gpi chip_top_tb.py
```

Caravel-based tests (with names starting with `caravel_`) consist of a Verilog testbench (`caravel/sim/caravel_tb`) and a Caravel program (`caravel/sim/caravel_sw`), with the cocotb testbench acting mostly as a test framework. Tests for the async eFuse, SPI SRAM & eFuse and the UART2GPI do not use the Caravel infrastructure and are written entirely in Python.

Test list:

| Test                      | Description                                                              |
|---------------------------|--------------------------------------------------------------------------|
| caravel_efuse_rw          | Tests writing and reading all WB eFuse blocks from Caravel.              |
| caravel_async_wb_efuse    | Tests writing and reading async eFuse block from Caravel.                |
| caravel_hkspi             | Tests Caravel Housekeeping SPI.                                          |
| caravel_mprj_bitbang      | Tests Caravel IO control via HK SPI.                                     |
| caravel_uart              | Tests Caravel UART TX.                                                   |
| caravel_pll               | Tests Caravel digital PLL & DCO.                                         |
| caravel_pass_thru         | Tests SPI flash access via HK SPI.                                       |
| caravel_self_suff         | Tests self-sufficient Caravel mode. Starts with DCO & uses eFuse as ROM. |
| caravel_efuse_as_spiflash | Tests SPI eFuse by using it as a flash for another instance of the chip. |
| async_efuse               | Tests async eFuse connected to external pads driving them from cocotb.   |
| spi_sram                  | Tests SPI SRAM with cocotb-spi.                                          |
| spi_efuse                 | Tests SPI eFuse with cocotb-spi.                                         |
| uart2gpi                  | Tests UART2GPI with cocotb.                                              |

## Chip pinout

Pad numbering in the table starts from the lower left (with the default GDS orientation) and going to the right. Numbering should be compatible with the [wafer.space COB project](https://github.com/wafer-space/chip-on-board-wire-bonded-pcbs).

| Pad | Pad name       | IP             | Signal name        | Comment                                     |
|-----|----------------|----------------|--------------------|---------------------------------------------|
| 0   | clk_pad        | General        | clock              |                                             |
| 1   | rst_n_pad      | General        | reset              | Active-low general reset                    |
| 2   | bidir\[0\]     | Caravel        | caravel_io_0       | Caravel debug pin (mprj_io\[0\])            |
| 3   | bidir\[1\]     | Caravel        | caravel_io_1       | Housekeeping SPI SDO (mprj_io\[1\])         |
| 4   | bidir\[2\]     | Caravel        | caravel_io_2       | Housekeeping SPI SDI (mprj_io\[2\])         |
| 5   | bidir\[3\]     | Caravel        | caravel_io_3       | Housekeeping SPI CSB (mprj_io\[3\])         |
| 6   | bidir\[4\]     | Caravel        | caravel_io_4       | Housekeeping SPI SCK (mprj_io\[4\])         |
| 7   | bidir\[5\]     | Caravel        | caravel_io_5       | Caravel UART RX (mprj_io\[5\])              |
| 8   | dvss_pads\[0\] |                | VSS                |                                             |
| 9   | bidir\[6\]     | Caravel        | caravel_io_6       | Caravel UART TX (mprj_io\[6\])              |
| 10  | bidir\[7\]     | Caravel        | caravel_io_7       | Clk0 feedback / SPI MST SCK (mprj_io\[32\]) |
| 11  | bidir\[8\]     | Caravel        | caravel_io_8       | Clk1 feedback / SPI MST CSB (mprj_io\[33\]) |
| 12  | bidir\[9\]     | Caravel        | caravel_io_9       | SPI MST SDI/flash_io0 (mprj_io\[34\])       |
| 13  | bidir\[10\]    | Caravel        | caravel_io_10      | SPI MST SDO/flash_io1 (mprj_io\[35\])       |
| 14  | bidir\[11\]    | Caravel        | caravel_io_11      | QSPI MST flash_io2 (mprj_io\[36\])          |
| 15  | bidir\[12\]    | Caravel        | caravel_io_12      | QSPI MST flash_io3 (mprj_io\[37\])          |
| 16  | bidir\[13\]    | Caravel        | caravel_gpio       |                                             |
| 17  | dvdd_pads\[0\] |                | VDD                |                                             |
| 18  | dvss_pads\[1\] |                | VSS                |                                             |
| 19  | bidir\[14\]    | Caravel        | caravel_flash_csb  |                                             |
| 20  | bidir\[15\]    | Caravel        | caravel_flash_clk  |                                             |
| 21  | bidir\[16\]    | Caravel        | caravel_flash_io0  | MOSI                                        |
| 22  | bidir\[17\]    | Caravel        | caravel_flash_io1  | MISO                                        |
| 23  | bidir\[18\]    | UART2GPI       | uart2gpi_gpio0     |                                             |
| 24  | bidir\[19\]    | UART2GPI       | uart2gpi_gpio1     |                                             |
| 25  | dvdd_pads\[1\] |                | VSS                |                                             |
| 26  | dvss_pads\[2\] |                | VSS                |                                             |
| 27  | bidir\[20\]    | UART2GPI       | uart2gpi_gpio2     |                                             |
| 28  | bidir\[21\]    | UART2GPI       | uart2gpi_gpio3     |                                             |
| 29  | bidir\[22\]    | UART2GPI       | uart2gpi_pwm0      |                                             |
| 30  | bidir\[23\]    | UART2GPI       | uart2gpi_pwm1      |                                             |
| 31  | bidir\[24\]    | Async eFuse    | aef_ready          |                                             |
| 32  | bidir\[25\]    | Async eFuse    | aef_out_0          |                                             |
| 33  | dvss_pads\[3\] |                | VSS                |                                             |
| 34  | dvdd_pads\[2\] |                | VDD                |                                             |
| 35  | dvss_pads\[4\] |                | VSS                |                                             |
| 36  | dvdd_pads\[3\] |                | VDD                |                                             |
| 37  | bidir\[26\]    | Async eFuse    | aef_out_1          |                                             |
| 38  | bidir\[27\]    | Async eFuse    | aef_out_2          |                                             |
| 39  | bidir\[28\]    | Async eFuse    | aef_out_3          |                                             |
| 40  | bidir\[29\]    | Async eFuse    | aef_out_4          |                                             |
| 41  | bidir\[30\]    | Async eFuse    | aef_out_5          |                                             |
| 42  | bidir\[31\]    | Async eFuse    | aef_out_6          |                                             |
| 43  | bidir\[32\]    | Async eFuse    | aef_out_7          |                                             |
| 44  | bidir\[33\]    | UART2GPI       | uart2gpi_i2csda    |                                             |
| 45  | dvss_pads\[5\] |                | VSS                |                                             |
| 46  | bidir\[34\]    | UART2GPI       | uart2gpi_i2cscl    |                                             |
| 47  | bidir\[35\]    | UART2GPI       | uart2gpi_uarttx    |                                             |
| 48  | bidir\[36\]    | UART2GPI       | uart2gpi_uartrx    |                                             |
| 49  | bidir\[37\]    | SPI SRAM/eFuse | sramspi_spidebug   |                                             |
| 50  | bidir\[38\]    | SPI SRAM       | sramspi_spics      | Active-low SPI CS to select SRAM            |
| 51  | bidir\[39\]    | SPI SRAM/eFuse | sramspi_spiclk     | Connected to SRAM & eFuse                   |
| 52  | bidir\[40\]    | SPI SRAM/eFuse | sramspi_spimiso    | Muxed between SRAM & eFuse                  |
| 53  | bidir\[41\]    | SPI SRAM/eFuse | sramspi_spimosi    | Connected to SRAM & eFuse                   |
| 54  | inputs\[0\]    |                |                    | Unused                                      |
| 55  | inputs\[1\]    | SPI eFuse      | efusespi_spics     | Active-low SPI CS to select eFuse           |
| 56  | dvss_pads\[6\] |                | VSS                |                                             |
| 57  | dvdd_pads\[4\] |                | VDD                |                                             |
| 58  | inputs\[2\]    | Async eFuse    | aef_prog_0         |                                             |
| 59  | inputs\[3\]    | Async eFuse    | aef_prog_1         |                                             |
| 60  | inputs\[4\]    | Async eFuse    | aef_prog_2         |                                             |
| 61  | inputs\[5\]    | Async eFuse    | aef_prog_3         |                                             |
| 62  | dvss_pads\[7\] |                | VSS                |                                             |
| 63  | dvdd_pads\[5\] |                | VDD                |                                             |
| 64  | inputs\[6\]    | Async eFuse    | aef_prog_4         |                                             |
| 65  | inputs\[7\]    | Async eFuse    | aef_prog_5         |                                             |
| 66  | inputs\[8\]    | Async eFuse    | aef_prog_6         |                                             |
| 67  | inputs\[9\]    | Async eFuse    | aef_prog_7         |                                             |
| 68  | inputs\[10\]   | Async eFuse    | aef_reset          | Active-low, should be 0 until power stable  |
| 69  | inputs\[11\]   | Caravel        | caravel_start_mode | 0 - regular operation, 1 - self-sufficient  |
| 70  | dvss_pads\[8\] |                | VSS                |                                             |
| 71  | dvdd_pads\[6\] |                | VDD                |                                             |
| 72  | dvss_pads\[9\] |                | VSS                |                                             |
| 73  | dvdd_pads\[7\] |                | VDD                |                                             |

