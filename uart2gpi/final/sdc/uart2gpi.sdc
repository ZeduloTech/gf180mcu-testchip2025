###############################################################################
# Created by write_sdc
###############################################################################
current_design uart2gpi
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 50.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_i[0]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_i[1]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_i[2]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_i[3]}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {i2c_scl_i}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {i2c_sda_i}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_ni}]
set_input_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {uart_rx_i}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_o[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_o[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_o[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_o[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_oe[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_oe[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_oe[2]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_oe[3]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {i2c_scl_o}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {i2c_scl_oe}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {i2c_sda_o}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {i2c_sda_oe}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pwm_o[0]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {pwm_o[1]}]
set_output_delay 10.0000 -clock [get_clocks {clk}] -add_delay [get_ports {uart_tx_o}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0729 [get_ports {i2c_scl_o}]
set_load -pin_load 0.0729 [get_ports {i2c_scl_oe}]
set_load -pin_load 0.0729 [get_ports {i2c_sda_o}]
set_load -pin_load 0.0729 [get_ports {i2c_sda_oe}]
set_load -pin_load 0.0729 [get_ports {uart_tx_o}]
set_load -pin_load 0.0729 [get_ports {gpio_o[3]}]
set_load -pin_load 0.0729 [get_ports {gpio_o[2]}]
set_load -pin_load 0.0729 [get_ports {gpio_o[1]}]
set_load -pin_load 0.0729 [get_ports {gpio_o[0]}]
set_load -pin_load 0.0729 [get_ports {gpio_oe[3]}]
set_load -pin_load 0.0729 [get_ports {gpio_oe[2]}]
set_load -pin_load 0.0729 [get_ports {gpio_oe[1]}]
set_load -pin_load 0.0729 [get_ports {gpio_oe[0]}]
set_load -pin_load 0.0729 [get_ports {pwm_o[1]}]
set_load -pin_load 0.0729 [get_ports {pwm_o[0]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_4 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {i2c_scl_i}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {i2c_sda_i}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_ni}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uart_rx_i}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {gpio_i[3]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {gpio_i[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {gpio_i[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {gpio_i[0]}]
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_capacitance 0.2000 [current_design]
set_max_fanout 10.0000 [current_design]
