########################################################################
### Caravel base SDC
########################################################################

## DEFINES

set clk_period $::env(CLOCK_PERIOD)
set hkspi_clk_period [expr $clk_period * 2]

# if set to 1 - analyse housekeeping registers clocking from SPI, 0 - from WB (can't have both in CTS)
set analyse_hkspi 0

# sometimes clock muxes are considered as clock gating by STA - disable it
set sta_gated_clock_checks_enabled 0

proc get_driver {net_pattern} {
    return [get_pins -of_objects [get_nets $net_pattern] -filter {direction!=input}]
}

## CLOCKS

# MASTER CLOCK (start from the pin of caravel_clocking)
create_clock -name clk -period $clk_period [get_pins {clock_ctrl.caravel_clk_buf/Z}] 
create_generated_clock -name wbbd_sck -source [get_pins {clock_ctrl.caravel_clk_buf/Z}] -divide_by 2 -master_clock clk [get_driver {housekeeping.wbbd_sck}]

# Housekeeping SPI clock (do not confuse with hk_serial)
create_clock -name hkspi_clk -period $hkspi_clk_period [get_pins {housekeeping.hkspi_clk_buf/Z}] 

if {$analyse_hkspi == 1} {
    set_case_analysis 0 [get_driver {housekeeping.wbbd_busy}]
    create_generated_clock -name hk_csclk -source [get_pins {housekeeping.hkspi_clk_buf/Z}] -divide_by 1 -master_clock hkspi_clk [get_driver {housekeeping.csclk}]
}

# Oscilator clocks
create_clock -name osc_clk0 -period $clk_period [get_pins {pll.ringosc0_clk_buf/Z}] 
create_clock -name osc_clk1 -period $clk_period [get_pins {pll.ringosc1_clk_buf/Z}] 

# hk_serial_clk period is x2 core clock
create_generated_clock -name hk_serial_clk -source [get_pins serial_clk_buf/I] -divide_by 2 -master clk [get_pins serial_clk_buf/Z]
create_generated_clock -name hk_serial_load -source [get_pins serial_load_clk_buf/I] -divide_by 20 -master clk [get_pins serial_load_clk_buf/Z]

## Flash & WB generated clocks
create_generated_clock -name flash_clk -source [get_pins flash_clk_buf/Z] -divide_by 4 [get_ports flash_clk_frame]
create_generated_clock -name user_wb_clk -source [get_pins user_wb_clk_buf/Z] -divide_by 1 [get_ports user_wb_clk_o]

set_clock_uncertainty 1 [get_clocks {hk_serial_clk hk_serial_load}]
set_clock_uncertainty 1 [get_clocks {flash_clk}]

set_clock_groups \
   -name clock_group_async \
   -asynchronous \
   -group [get_clocks [list clk flash_clk user_wb_clk wbbd_sck]] \
   -group [get_clocks hk_serial_clk]\
   -group [get_clocks hk_serial_load]\
   -group [get_clocks [list hkspi_clk hk_csclk]]\
   -group [get_clocks [list osc_clk0 osc_clk1]]
   
if { [info exists ::env(OPENLANE_SDC_IDEAL_CLOCKS)] && $::env(OPENLANE_SDC_IDEAL_CLOCKS) } {
    unset_propagated_clock [all_clocks]
} else {
    set_propagated_clock [all_clocks]
}

## PLL (without set_disable_timing PLL breaks CTS)
set_disable_timing [get_pins pll.ringosc/trim*]
set_disable_timing [get_pins pll.ringosc/clock*]
set_disable_timing [get_cells housekeeping.spi_is_active_clk_buf]
set_disable_timing [get_driver {clock_ctrl.divider*.out}]

## INPUT/OUTPUT DELAYS
set input_delay_value [expr $clk_period * 0.1]
set output_delay_value [expr $clk_period * 0.25]

puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"

# Wishbone IO constraints
set_output_delay $output_delay_value -clock [get_clocks {user_wb_clk}] -reference [get_ports user_wb_clk_o] [get_ports [list user_wb_adr_o* user_wb_sel_o* user_wb_dat_o* user_wb_cyc_o user_wb_stb_o user_wb_we_o]]
set_input_delay $input_delay_value -clock [get_clocks {user_wb_clk}] -reference [get_ports user_wb_clk_o] [get_ports user_wb*_i*]

## Flash IO constraints, flash clock period is 4x of system and strobed at falling edge
set_output_delay -min [expr $clk_period * 0.3] -clock [get_clocks {flash_clk}] -reference [get_ports flash_clk_frame] [get_ports [list flash_csb* flash_io*_do flash_io*_*e]]
set_output_delay -max [expr $clk_period * 0.6] -clock [get_clocks {flash_clk}] -reference [get_ports flash_clk_frame] [get_ports [list flash_csb* flash_io*_do flash_io*_*e]]
set_input_delay  $input_delay_value -clock [get_clocks {flash_clk}] -reference [get_ports flash_clk_frame] [get_ports flash_io*_di]

## MAX FANOUT
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]

## FALSE PATHS 
set_false_path -from [get_ports {rstb}]

set_false_path -through [get_ports {user_gpio*}]
set_false_path -through [get_ports user_clock2]
set_false_path -through [get_ports user_irq_core]
set_false_path -through [get_ports user_wb_rst_o]
set_false_path -through [get_ports gpio*]
# No meaningfull sync paths from clk to caravel_io 
set_false_path -from [get_clock clk] -through [get_ports caravel_io*]

## PIN loads

# Add loads for output ports
set min_cap 0.002
set max_cap 0.5
puts "\[INFO\]: Cap load range: $min_cap : $max_cap"
set_load $max_cap [all_outputs] 

# Input transitions
set min_in_tran 0.2
set max_in_tran 1.0

# Input driving cells
set user_inputs [get_ports [list flash_io*_di user_wb_dat_i* user_wb_ack_i user_gpio_out* user_gpio_oeb* user_irq_core]]
set pad_inputs [get_ports [list caravel_io_in* rstb clock_core gpio_in_core]]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__buf_16 -pin Z -min -from_pin I -input_transition_rise $min_in_tran -input_transition_fall $min_in_tran $user_inputs
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__buf_1 -pin Z -max -from_pin I -input_transition_rise $max_in_tran -input_transition_fall $min_in_tran $user_inputs
set_driving_cell -lib_cell gf180mcu_fd_io__bi_24t -pin Y -from_pin PAD -input_transition_rise $max_in_tran -input_transition_fall $max_in_tran $pad_inputs

# Derates
set derate 0.05
puts "\[INFO\]: Setting derate factor to: [expr $derate * 100] %"
set_timing_derate -early [expr 1-$derate]
set_timing_derate -late [expr 1+$derate]

## MAX transition/cap
set_max_trans 1.5 [current_design]
set_max_cap $max_cap [current_design]
