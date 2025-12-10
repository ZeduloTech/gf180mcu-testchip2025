#! /usr/bin/env python3
# SPDX-FileCopyrightText: © 2025 Project Template Contributors
# SPDX-License-Identifier: Apache-2.0

import os
import json
import logging
import random
from pathlib import Path
import shutil

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge
from cocotbext.uart import UartSink
from cocotbext.spi import SpiBus, SpiConfig, SpiMaster
from cocotb_tools.runner import get_runner

sim = os.getenv("SIM", "icarus")
pdk_root = os.getenv("PDK_ROOT", Path("../gf180mcu").absolute())
pdk = os.getenv("PDK", "gf180mcuD")
scl = os.getenv("SCL", "gf180mcu_fd_sc_mcu7t5v0")
gl = os.getenv("GL", False)
sdf = os.getenv("SDF", False)
test_env = os.getenv("TEST", "all")
add_build_args = os.getenv("ADD_BUILD_ARGS", "").split()
add_plus_args = os.getenv("ADD_PLUS_ARGS", "").split()

# SPI test class
# class SPITest

@cocotb.test(timeout_time=300, timeout_unit="us")
async def spi_sram_test(dut):
    """Test SRAMs available via SPI"""
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    logger.info("Starting SRAM SPI test")

    # Clock & reset
    cocotb.start_soon(Clock(dut.clock, 100, "ns").start())
    dut.resetb.value = 0
    await Timer(1, "us")
    dut.resetb.value = 1
    await Timer(1, "us")
    logger.info("Reset deasserted")

    spi_bus = SpiBus.from_prefix(dut, "sramtest", cs_name="cs")

    spi_config = SpiConfig(
        word_width = 8,         # number of bits in a SPI transaction
        sclk_freq  = 1e6,       # clock rate in Hz
        cpol       = True,      # clock idle polarity
        cpha       = True,      # clock phase (CPHA=True means data sampled on second edge)
        msb_first  = True,      # the order that bits are clocked onto the wire
        data_output_idle = 1,   # the idle value of the MOSI or MISO line
        ignore_rx_value = None, # MISO value that should be ignored when received
        cs_active_low = True    # the chip select is active low
    )

    spi_master = SpiMaster(spi_bus, spi_config)

    # Write test sequence to SPI:
    # Write single byte to all SRAMs and read single byte from SRAM_64)
    TEST_BYTE = random.randrange(256)
    logger.info(f"Shifting test sequence to SPI, writing {TEST_BYTE:x}")
    spi_master.write_nowait([
        0x00, 0xF0,         # CMD_STATUS
        0x01, 0x0F,         # CMD_CEN_SET
        0x01, 0x00,         # CMD_CEN_SET
        0x02, 0x00,         # CMD_WRMASK_SET
        0x03, 0x00,         # CMD_ADDRL
        0x04, 0x00,         # CMD_ADDRH
        0x28, TEST_BYTE,    # CMD_WRITEI
        0x03, 0x00,         # CMD_ADDRL
        0x30, 0x00,         # CMD_READ0
        0x00, 0x00          # CMD_STATUS
    ])
    await spi_master.wait()
    read_bytes = await spi_master.read()

    logger.info("Verifying read byte...")
    assert int(read_bytes[-2]) == TEST_BYTE

    logger.info("Done!")

@cocotb.test(timeout_time=200, timeout_unit="us")
async def async_efuse_test(dut):
    """Test write & read async efuse"""
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    logger.info("Starting async eFuse test")
    dut.aef_rst.value = 0
    await Timer(1, "us")
    dut.aef_rst.value = 1
    await Timer(1, "us")

    while dut.aef_ready.value != 1:
        await dut.aef_ready.value_change
    await Timer(1, "us")

    # in_val = in_val_orig = dut.input_PAD.get()
    # for i in range(8):
    #     dut.aef_prog[1+i].value = i&1
    #     logger.info(f"Wrote bit {i} {i&1}")
    test_byte = random.randrange(256)
    dut.aef_prog.value = test_byte
    logger.info(f"Wrote byte 0x{test_byte:x}")
    # dut.input_PAD.set(in_val)
    await Timer(10, "us")
    dut.aef_prog.value = 0
    # dut.input_PAD.set(in_val_orig)
    await Timer(1, "us")

    # reset & try to write during reset low
    dut.aef_rst.value = 0
    await Timer(1, "us")
    # in_val = in_val_orig = dut.input_PAD.get()
    # for i in range(8):
    #     in_val[1+i] = 1
    # dut.input_PAD.set(in_val)
    dut.aef_prog.value = 0xFF
    await Timer(1, "us")
    dut.aef_prog.value = 0
    await Timer(1, "us")
    dut.aef_rst.value = 1
    await Timer(1, "us")

    # read & check value after ready
    while dut.aef_ready.value != 1:
        await dut.aef_ready.value_change

    # for i in range(8):
    #     logger.info(f"Read bit {i}: {dut.bidir_PAD.value[25+i]}")
    read_byte = int(dut.aef_out.value)
    logger.info(f"Read byte 0x{read_byte:x}")
    assert(read_byte == test_byte)

uart_recv = ""
async def uart_monitor(uart_sink):
    global uart_recv
    while True:
        uart_byte = await uart_sink.read()
        if int.from_bytes(uart_byte) != 0:
            if int.from_bytes(uart_byte) != 0xd:    # ignore CR
                uart_recv += uart_byte.decode("utf-8")
        else:
            # allow zero bytes at the beginning
            assert(not uart_recv)

@cocotb.test(timeout_time=200, timeout_unit="ms")
async def caravel_test(dut):
    """Run the Caravel test"""

    # Create a logger for this testbench
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info(f"Starting Caravel test {os.getenv('TEST_NAME')}")
    
    # Copy efuse hex
    efuse = os.getenv("EFUSE_HEX")
    if efuse:
        shutil.copy(efuse, "efuse_init.hex")

    # Connect UART
    uart_sink = UartSink(dut.uart_tx, baud=19200, bits=8)
    cocotb.start_soon(uart_monitor(uart_sink))
    
    await RisingEdge(dut.test_success)

    uart = os.getenv("EXPECT_UART")
    if uart:
        while len(uart_recv) < len(uart):
            logger.info("Waiting for UART data to arrive...")
            await Timer(100, "us")
        logger.info(f"Checking received UART data: got {uart_recv}, expected {uart}")
        assert(uart == uart_recv)

    logger.info("Done!")


def test_chip_top_runner(test : str, is_pytest : bool = True):

    proj_path = Path(__file__).resolve().parent

    sources = []
    defines = {}
    includes = []

    hex_prefix = str(proj_path / "../caravel/sim/caravel_sw") + "/"
    defines.update({
        "SIM" : 1, 
        "HEX_PREFIX" : hex_prefix,
        "FINAL_PREFIX" : str(proj_path / "../final") + "/",
        "CARAVEL_FINAL_PREFIX" : str(proj_path / "../caravel/final") + "/",
        "OSC_FINAL_PREFIX" : str(proj_path / "../caravel/ring_osc2x13/final") + "/"
    })

    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v")
    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / "primitives.v")

    if gl:
        # Use the powered netlist
        sources.append(proj_path / "../caravel/ring_osc2x13/final/pnl/ring_osc2x13.pnl.v")
        sources.append(proj_path / "../caravel/final/pnl/caravel_core.pnl.v")
        sources.append(proj_path / "../final/pnl/chip_top.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_32x8/efuse_wb_mem_32x8.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_128x8/efuse_wb_mem_128x8.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_64x32/efuse_wb_mem_64x32.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_1024x32/efuse_wb_mem_1024x32.pnl.v")
        sources.append(proj_path / "../ip/efuse_async_mem_1x8/efuse_async_mem_1x8.pnl.v")

        defines.update({"USE_POWER_PINS": 1})
        if sdf:
            defines.update({"ENABLE_SDF" : 1})
    else:
        sources.append(proj_path / "../src/chip_top.sv")
        sources.append(proj_path / "../src/chip_core.sv")
        sources.append(proj_path / "../src/sramtest/uspi_sramtest.sv")
        sources.append(proj_path / "../src/wb_mux_4.v")
        sources.append(proj_path / "../src/wb_reg.v")
        sources.append(proj_path / "../src/wb_switch.v")
        sources.append(proj_path / "../src/wb_efuses.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_32x8/efuse_wb_mem_32x8.nl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_128x8/efuse_wb_mem_128x8.nl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_64x32/efuse_wb_mem_64x32.nl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_1024x32/efuse_wb_mem_1024x32.nl.v")
        sources.append(proj_path / "../ip/efuse_async_mem_1x8/efuse_async_mem_1x8.v")

        sources += (proj_path / "../caravel/verilog/").glob("*.v")

        defines.update({"SLOT_1X1" : 1, "FUNCTIONAL": 1})

    includes.append(proj_path / "../src")
    includes.append(proj_path / "../caravel/verilog/")
    includes.append(proj_path / "../caravel/sim/common/")

    sources += [
        # IO pad models
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_io/verilog/gf180mcu_fd_io.v",
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_io/verilog/gf180mcu_ws_io.v",
        
        # SRAM macros
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram64x8m8wm1.v",
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram128x8m8wm1.v",
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram256x8m8wm1.v",
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram512x8m8wm1.v",

        # SRAM wrappers
        proj_path / "../ip/sram/gf180_ram_64x8_wrapper.v",
        proj_path / "../ip/sram/gf180_ram_128x8_wrapper.v",
        proj_path / "../ip/sram/gf180_ram_256x8_wrapper.v",
        proj_path / "../ip/sram/gf180_ram_512x8_wrapper.v",
        
        # Caravel IP
        proj_path / "../ip/simple_por/verilog/simple_por.v",

        # eFuse array model
        proj_path / "../ip/efuse_wb_mem_1024x32/efuse_array_64x32.v",    # for 1024x32 & 64x32
        proj_path / "../ip/efuse_wb_mem_128x8/efuse_array_64x8.v",
        proj_path / "../ip/efuse_wb_mem_32x8/efuse_array_32x8.v",
        proj_path / "../ip/efuse_async_mem_1x8/efuse_async_array_1x8.v",
        
        # Custom IP
        proj_path / "../ip/gf180mcu_ws_ip__id/vh/gf180mcu_ws_ip__id.v",
        proj_path / "../ip/gf180mcu_ws_ip__logo/vh/gf180mcu_ws_ip__logo.v",
    ]

    build_args = []

    if sim == "icarus":
        # For debugging
        # build_args = ["-Winfloop", "-pfileline=1"]
        pass

    build_args += add_build_args

    if sim == "verilator":
        build_args = ["--timing", "--trace", "--trace-fst", "--trace-structs"]

    if test != "all":
        tests = [ test ]
    else:
        tests = json.load(open("test_list.json"))
        
    for test in tests:
        
        efuse_hex = ""
        uart = ""

        if "caravel_" in test:
            caravel_test = test[8:]

            # skip PLL tests in GL without SDF (oscillator ring hangs without delays)
            if (caravel_test in ["pll", "self_suff"]) and (not sdf and gl):
                msg = "PLL tests can't be run with gate level netlist without SDF"
                if is_pytest:
                    from pytest import skip
                    skip(msg)
                else:
                    print(msg)
                    continue
            elif (caravel_test == "self_suff"):
                defines.update({"EFUSE_MEMORY_INIT" : 1})
                efuse_hex = hex_prefix + "self_suff_rom.ehex"

            # Add Caravel sim top and Verilog helpers
            sources += (proj_path / "../caravel/sim/common/").glob("*.v")
            top = f"{caravel_test}_tb"
            sources.append(proj_path / f"../caravel/sim/caravel_tb/{top}.v")

            uart = "Hi\n" if caravel_test == "uart" else ""

            testcase = "caravel_test"

        else:
            testcase = f"{test}_test"
            sources.append(proj_path / "../src/sramtest/sim/sramtest_sim_wrapper.v")
            top = "chip_wrapper"

        runner = get_runner(sim)
        runner.build(
            sources=sources,
            hdl_toplevel=top,
            defines=defines,
            always=True,
            includes=includes,
            build_args=build_args,
            build_dir=f"sim_build/{test}" + ("_gl" if gl else ""),
            waves=True,
        )

        plusargs = add_plus_args

        runner.test(
            hdl_toplevel=top,
            test_module="chip_top_tb,",
            plusargs=plusargs,
            waves=True,
            testcase=testcase,
            extra_env={"TEST_NAME" : test, "EXPECT_UART" : uart, "EFUSE_HEX" : efuse_hex}
        )

if __name__ == "__main__":
    test_chip_top_runner(test_env, False)
