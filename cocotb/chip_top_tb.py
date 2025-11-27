# SPDX-FileCopyrightText: © 2025 Project Template Contributors
# SPDX-License-Identifier: Apache-2.0

import os
import sys
import random
import logging
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge, ClockCycles
from cocotbext.uart import UartSink
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
async def test_caravel(dut):
    """Run the Caravel test"""

    # Create a logger for this testbench
    logger = logging.getLogger("testbench")

    # Connect UART
    uart_sink = UartSink(dut.uart_tx, baud=19200, bits=8)
    cocotb.start_soon(uart_monitor(uart_sink))
    
    await RisingEdge(dut.test_success)

    uart = os.getenv("EXPECT_UART")
    if uart:
        while len(uart_recv) < len(uart):
            logger.warning("Waiting for UART data to arrive...")
            await Timer(100, "us")
        logger.warning(f"Checking received UART data: got {uart_recv}, expected {uart}")
        assert(uart == uart_recv)

    logger.info("Done!")


def test_chip_top_runner(test : str, is_pytest : bool = True):

    proj_path = Path(__file__).resolve().parent

    sources = []
    defines = {}
    includes = []

    defines.update({
        "SIM" : 1, 
        "HEX_PREFIX" : str(proj_path / "../caravel/sim/caravel_sw") + "/",
        "FINAL_PREFIX" : str(proj_path / "../final") + "/",
        "CARAVEL_FINAL_PREFIX" : str(proj_path / "../caravel/final") + "/",
        "OSC_FINAL_PREFIX" : str(proj_path / "../caravel/ring_osc2x13/final") + "/"
    })

    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v")
    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / "primitives.v")

    if gl:
        # SCL models

        # Use the powered netlist
        sources.append(proj_path / "../caravel/ring_osc2x13/final/pnl/ring_osc2x13.pnl.v")
        sources.append(proj_path / "../caravel/final/pnl/caravel_core.pnl.v")
        sources.append(proj_path / "../final/pnl/chip_top.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_32x8/efuse_wb_mem_32x8.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_128x8/efuse_wb_mem_128x8.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_64x32/efuse_wb_mem_64x32.pnl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_1024x32/efuse_wb_mem_1024x32.pnl.v")

        defines.update({"USE_POWER_PINS": 1})
        if sdf:
            defines.update({"ENABLE_SDF" : 1})
    else:
        sources.append(proj_path / "../src/chip_top.sv")
        sources.append(proj_path / "../src/chip_core.sv")
        sources.append(proj_path / "../src/wb_mux_4.v")
        sources.append(proj_path / "../src/wb_reg.v")
        sources.append(proj_path / "../src/wb_switch.v")
        sources.append(proj_path / "../src/wb_efuses.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_32x8/efuse_wb_mem_32x8.nl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_128x8/efuse_wb_mem_128x8.nl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_64x32/efuse_wb_mem_64x32.nl.v")
        sources.append(proj_path / "../ip/efuse_wb_mem_1024x32/efuse_wb_mem_1024x32.nl.v")
        # sources.append(proj_path / "/home/egor/proj/waferspace/gf180_efuse_compiler/src/digital/efuse_wb_mem.v")

        sources += (proj_path / "../caravel/verilog/").glob("*.v")

        defines.update({"FUNCTIONAL": 1})

    includes.append(proj_path / "../src")
    includes.append(proj_path / "../caravel/verilog/")

    sources += [
        # IO pad models
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_io/verilog/gf180mcu_fd_io.v",
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_io/verilog/gf180mcu_ws_io.v",
        
        # SRAM macros
        Path(pdk_root) / pdk / "libs.ref/gf180mcu_fd_ip_sram/verilog/gf180mcu_fd_ip_sram__sram512x8m8wm1.v",

        # Caravel IP
        proj_path / "../ip/sram/gf180_ram_512x8_wrapper.v",
        proj_path / "../ip/simple_por/verilog/simple_por.v",

        # eFuse array model
        proj_path / "../ip/efuse_wb_mem_1024x32/efuse_array_64x32.v",    # for 1024x32 & 64x32
        proj_path / "../ip/efuse_wb_mem_128x8/efuse_array_64x8.v",
        proj_path / "../ip/efuse_wb_mem_32x8/efuse_array_32x8.v",
        
        # Custom IP
        proj_path / "../ip/gf180mcu_ws_ip__id/vh/gf180mcu_ws_ip__id.v",
        proj_path / "../ip/gf180mcu_ws_ip__logo/vh/gf180mcu_ws_ip__logo.v",
    ]

    # Add Caravel sim Verilog helpers
    sources += (proj_path / "../caravel/sim/common/").glob("*.v")

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
        tests = ["efuse_rw", "hkspi", "mprj_bitbang", "uart", "pll"]
        
    for caravel_test in tests:
        
        # skip PLL test in GL without SDF (oscillator ring obviously hangs without delays)
        if (caravel_test == "pll") and (not sdf and gl):
            if is_pytest:
                from pytest import skip
                skip("PLL test can't be run with gate level netlist without SDF")
            else:
                print("PLL test can't be run with gate level netlist without SDF", is_pytest)
                continue

        top = f"{caravel_test}_tb"

        uart = "Hi\n" if caravel_test == "uart" else ""

        runner = get_runner(sim)
        runner.build(
            sources=sources + [proj_path / f"../caravel/sim/caravel_tb/{top}.v"],
            hdl_toplevel=top,
            defines=defines,
            always=True,
            includes=includes,
            build_args=build_args,
            waves=True,
        )

        plusargs = add_plus_args

        runner.test(
            hdl_toplevel=top,
            test_module="chip_top_tb,",
            plusargs=plusargs,
            waves=True,
            extra_env = {"EXPECT_UART" : uart}
        )

if __name__ == "__main__":
    test_chip_top_runner(test_env, False)
