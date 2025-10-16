### Caravel base SDC

set clk_period $::env(CLOCK_PERIOD)

## MASTER CLOCK (start from the pin of caravel_clocking)
create_clock -name clk -period $clk_period [get_pins {caravel_clk_buf/Z}] 
#create_clock -name clk -period $clk_period [get_pins -of_objects [get_nets {user_wb_clk_o}] -filter {direction!=input}] 

# hk_serial_clk period is x2 core clock
# Crashes CTS :(
#create_generated_clock -name hk_serial_clk -source [get_pins serial_clk_buf/I] -divide_by 2 [get_pins serial_clk_buf/Z]
#create_generated_clock -name hk_serial_clk -source [get_pins serial_load_clk_buf/I] -divide_by 20 [get_pins serial_load_clk_buf/Z]

## Flash & WB generated clocks
create_generated_clock -name flash_clk -source [get_pins flash_clk_buf/Z] -divide_by 4 [get_ports flash_clk_frame]
create_generated_clock -name user_wb_clk -source [get_pins user_wb_clk_buf/Z] -divide_by 1 [get_ports user_wb_clk_o]

#set_clock_uncertainty 1 [get_clocks {hk_serial_clk hk_serial_load}]
set_clock_uncertainty 1 [get_clocks {flash_clk}]

set_clock_groups \
   -name clock_group \
   -logically_exclusive \
   -group [get_clocks [list clk flash_clk user_wb_clk]] \
   -group [get_clocks {hk_serial_clk}]\
   -group [get_clocks {hk_serial_load}]
   
set_propagated_clock [all_clocks]

## PLL (without set_disable_timing PLL breaks CTS)
set_disable_timing [get_cells pll_in_clk_buf]

## INPUT/OUTPUT DELAYS
set input_delay_value [expr $clk_period * 0.1]
set output_delay_value [expr $clk_period * 0.25]

puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"

# Set default delays for all IOs
#set_input_delay $input_delay_value  -clock [get_clocks {clk}] -add_delay [all_inputs]
#set_output_delay $output_delay_value  -clock [get_clocks {clk}] -add_delay [all_outputs]

# Wishbone IO constraints
set_output_delay $output_delay_value -clock [get_clocks {user_wb_clk}] -reference [get_ports user_wb_clk_o] [get_ports [list user_wb_adr_o* user_wb_sel_o* user_wb_dat_o* user_wb_cyc_o user_wb_stb_o user_wb_we_o]]
set_input_delay $input_delay_value -clock [get_clocks {user_wb_clk}] -reference [get_ports user_wb_clk_o] [get_ports user_wb*_i*]

## Flash IO constraints, flash clock is 4x of system and strobed at falling edge
set_output_delay -min [expr $clk_period * 0.5] -clock [get_clocks {flash_clk}] -reference [get_ports flash_clk_frame] [get_ports [list flash_csb* flash_io*_do flash_io*_*e]]
set_output_delay -max [expr $clk_period * 0.8] -clock [get_clocks {flash_clk}] -reference [get_ports flash_clk_frame] [get_ports [list flash_csb* flash_io*_do flash_io*_*e]]
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
# No valid sync paths from clk to caravel_io & gpio besides QSPI, but ignore it for now
set_false_path -from [get_clock clk] -through [get_ports caravel_io*]

# Add loads for output ports (pads)
set min_cap 5
set max_cap 10
puts "\[INFO\]: Cap load range: $min_cap : $max_cap"
set_load -min $min_cap [all_outputs] 
set_load -max $max_cap [all_outputs] 

set min_in_tran 1
set max_in_tran 4.5
puts "\[INFO\]: Input transition range: $min_in_tran : $max_in_tran"
set_input_transition -min $min_in_tran [all_inputs] 
set_input_transition -min 0 [get_ports V*]
set_input_transition -max $max_in_tran [all_inputs]
set_input_transition -max 0 [get_ports V*]

# Derates
set derate 0.05
puts "\[INFO\]: Setting derate factor to: [expr $derate * 100] %"
set_timing_derate -early [expr 1-$derate]
set_timing_derate -late [expr 1+$derate]

## MAX transition/cap
set_max_trans 1.5 [current_design]
set_max_cap 0.5 [current_design]
