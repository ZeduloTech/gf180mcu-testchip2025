#!/bin/bash
#=======================================================
# uart2gpi Testbench Build Script
# Compiles all RTL sources and runs simulation 
#=======================================================

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}===================================${NC}"
echo -e "${YELLOW}  uart2gpi Testbench   ${NC}"
echo -e "${YELLOW}===================================${NC}"

# output directory
mkdir -p sim_out

# rtl location
RTL_DIR=../src/

# source files
UART_SOURCES="
    $RTL_DIR/otUART.03/prim_util_pkg.sv
    $RTL_DIR/otUART.03/prim_count_pkg.sv
    $RTL_DIR/otUART.03/uart_reg_pkg.sv
    $RTL_DIR/otUART.03/prim_flop.sv
    $RTL_DIR/otUART.03/prim_flop_2sync.sv
    $RTL_DIR/otUART.03/prim_count.sv
    $RTL_DIR/otUART.03/prim_fifo_sync_cnt.sv
    $RTL_DIR/otUART.03/prim_fifo_sync.sv
    $RTL_DIR/otUART.03/uart_tx.sv
    $RTL_DIR/otUART.03/uart_rx.sv
    $RTL_DIR/otUART.03/uart_core.sv
    $RTL_DIR/otUART.03/uart_reg_top.sv
"

GPIO_SOURCES="
    $RTL_DIR/otGPIO.04/gpio_reg_pkg.sv
    $RTL_DIR/otGPIO.04/gpio_reg_lite.sv
    $RTL_DIR/otGPIO.04/gpio.sv
"

PWM_SOURCES="
    $RTL_DIR/otPWM.04/pwm_reg_pkg.sv
    $RTL_DIR/otPWM.04/pwm_core.sv
    $RTL_DIR/otPWM.04/pwm_chan.sv
    $RTL_DIR/otPWM.04/pwm_reg_lite.sv
"

I2C_SOURCES="
    $RTL_DIR/otI2C.05/i2c_reg_pkg.sv
    $RTL_DIR/otI2C.05/i2c_fifo_sync_sram_adapter.sv
    $RTL_DIR/otI2C.05/i2c_controller_fsm.sv
    $RTL_DIR/otI2C.05/i2c_fifos.sv
    $RTL_DIR/otI2C.05/i2c_core.sv
    $RTL_DIR/otI2C.05/i2c_reg_top.sv
"

TOP_SOURCES="
    $RTL_DIR/uart2gpi.sv
"

TB_SOURCES="
    uart2gpi_tb.sv
"

ALL_SOURCES="${UART_SOURCES} ${GPIO_SOURCES} ${PWM_SOURCES} ${I2C_SOURCES} ${TOP_SOURCES} ${TB_SOURCES}"

echo -e "\n${GREEN}[1/3] Compiling sources...${NC}"

# COMPILE FILES
iverilog -g2012 \
    -Wall \
    -o sim_out/uart2gpi_tb.vvp \
    -s uart2gpi_tb \
    ${ALL_SOURCES}

echo -e "${GREEN}[2/3] Running simulation...${NC}"
echo -e "${GREEN} Using more clock cycles to allow uart to fully initialize...${NC}"

# Run simulation
cd sim_out
vvp uart2gpi_tb.vvp | tee simulation.log
cd ..

echo -e "\n${GREEN}[3/3] Simulation complete!${NC}"

echo -e "\n${YELLOW}==================================${NC}"
echo -e "${YELLOW}  Build Complete                        ${NC}"
echo -e "${YELLOW}====================================${NC}"
