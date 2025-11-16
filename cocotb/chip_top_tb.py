# SPDX-FileCopyrightText: © 2025 Project Template Contributors
# SPDX-License-Identifier: Apache-2.0

import os
import random
import logging
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge, ClockCycles
from cocotb_tools.runner import get_runner

sim = os.getenv("SIM", "icarus")
pdk_root = os.getenv("PDK_ROOT", Path("../gf180mcu").absolute())
pdk = os.getenv("PDK", "gf180mcuD")
scl = os.getenv("SCL", "gf180mcu_fd_sc_mcu7t5v0")
gl = os.getenv("GL", False)
sdf = os.getenv("SDF", False)

async def set_defaults(dut):
    dut.input_PAD.value = 0

async def enable_power(dut):
    dut.VDD.value = 1
    dut.VSS.value = 0

async def start_clock(clock, freq=50):
    """Start the clock @ freq MHz"""
    c = Clock(clock, 1 / freq * 1000, "ns")
    cocotb.start_soon(c.start())


async def reset(reset, active_low=True, time_ns=1000):
    """Reset dut"""
    cocotb.log.info("Reset asserted...")

    reset.value = not active_low
    await Timer(time_ns, "ns")
    reset.value = active_low

    cocotb.log.info("Reset deasserted.")


async def start_up(dut):
    """Startup sequence"""
    await set_defaults(dut)
    if gl:
        await enable_power(dut)
    await start_clock(dut.clk_PAD)
    await reset(dut.rst_n_PAD)


@cocotb.test(timeout_time=10000, timeout_unit="us")
async def test_caravel(dut):
    """Run the Caravel test"""

    # Create a logger for this testbench
    logger = logging.getLogger("testbench")
    
    await RisingEdge(dut.test_success)

    logger.info("Done!")


def chip_top_runner():

    proj_path = Path(__file__).resolve().parent

    sources = []
    defines = {}
    includes = []

    defines.update({
        "SIM" : 1, 
        "HEX_PREFIX" : str(proj_path / "../caravel/sim/caravel_sw") + "/",
        "FINAL_PREFIX" : str(proj_path / "../final") + "/",
        "CARAVEL_FINAL_PREFIX" : str(proj_path / "../caravel/final") + "/",
    })

    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v")
    sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / "primitives.v")

    if gl:
        # SCL models

        # Use the powered netlist
        sources.append(proj_path / "../caravel/ring_osc2x13/final/pnl/ring_osc2x13.pnl.v")
        sources.append(proj_path / "../caravel/final/pnl/caravel_core.pnl.v")
        sources.append(proj_path / "../final/pnl/chip_top.pnl.v")

        defines.update({"USE_POWER_PINS": 1})
        if sdf:
            defines.update({"ENABLE_SDF" : 1})
    else:
        sources.append(proj_path / "../src/chip_top.sv")
        sources.append(proj_path / "../src/chip_core.sv")
        sources.append(proj_path / "../src/wb_counter.v")

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

    if sim == "verilator":
        build_args = ["--timing", "--trace", "--trace-fst", "--trace-structs"]

    # for caravel_test in ["wbcounter", "hkspi", "pll", "mprj_bitbang", "uart"]:
    for caravel_test in ["wbcounter", "hkspi"]:

        top = f"{caravel_test}_tb"

        # print(sources)

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

        plusargs = []

        runner.test(
            hdl_toplevel=top,
            test_module="chip_top_tb,",
            plusargs=plusargs,
            waves=True,
        )


if __name__ == "__main__":
    chip_top_runner()
