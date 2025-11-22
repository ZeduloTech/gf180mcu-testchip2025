################################ DEFINES ############################### 
current_design $::env(DESIGN_NAME)
set_units -time ns

source [file dirname [info script]]/../caravel/librelane/sdc_defs.tcl

set clock_port clk_PAD
set wb_clock_name wb_clk
set period $::env(CLOCK_PERIOD)

set cvl i_chip_core.caravel
set caravel_clk_src $cvl/$caravel_clk_start

# The following variables helps to determine if we're in 
# the "hierarchical" (OpenSTA step with netlists and spefs) 
# or in the "flat" (inside OpenROAD with libs) mode.
set hierarchical_sta [llength [get_pins $caravel_clk_src]]


if {$hierarchical_sta} {
####################### HIER CONSTRAINTS ############################### 
    puts "\[INFO] Using SDC constraints for hierarchical mode (probably running from OpenSTA)..."

    set caravel_clock_src i_chip_core.caravel/clock_ctrl.caravel_clk_buf/Z
    create_clock $caravel_clock_src -name $wb_clock_name -period $::env(CLOCK_PERIOD)
    
} else {
####################### FLAT CONSTRAINTS ############################### 
    puts "\[INFO] Using SDC constraints for flat mode (probably running from OpenROAD)..."
    
    set clk_source [lindex $::env(CLOCK_NET) 0]
    
    # Functions returning input/output pin of std cell connected to macro pin
    proc cell_pin_from_macro {macro_pin} {
        return [get_pins -of_objects [get_nets -of_object $macro_pin] -filter {direction!=output}]
    }
    proc cell_pin_to_macro {macro_pin} {
        return [get_pins -of_objects [get_nets -of_object $macro_pin] -filter {direction!=input}]
    }
    
    # Functions to set delays on macro pins. Ugly, but no other way to do it in OpenROAD as
    # most of macro pins are not timing endpoints.
    proc set_input_delay_from_macro {pins clock ref min_delay max_delay} {
        foreach pin $pins {
            set_input_delay -clock $clock -reference_pin $ref -max $max_delay [cell_pin_from_macro $pin]
            set_input_delay -clock $clock -reference_pin $ref -min $min_delay [cell_pin_from_macro $pin]
        }
    }
    proc set_output_delay_to_macro {pins clock ref min_delay max_delay} {
        foreach pin $pins {
            set_output_delay -clock $clock -reference_pin $ref -max $max_delay [cell_pin_to_macro $pin]
            set_output_delay -clock $clock -reference_pin $ref -min $min_delay [cell_pin_to_macro $pin]
        }
    }
    
    puts "\[INFO] Using clock $clk_source..."
    create_clock [get_pins $clk_source] -name $wb_clock_name -period $period
    
    # in/out related to WB master (Caravel)
    set wb_outputs [get_pins [list $cvl/user_wb_cyc_o $cvl/user_wb_stb_o \
        $cvl/user_wb_we_o $cvl/user_wb_sel_o* $cvl/user_wb_dat_o* $cvl/user_wb_adr_o* ]]
    set wb_inputs [get_pins [list $cvl/user_wb_*_i* ]]
    
    # Set Caravel WB delays
    set delta 0.5
    set_input_delay_from_macro $wb_outputs $wb_clock_name $clk_source \
        [expr $caravel_out_min_delay - $delta] [expr $caravel_period - $caravel_out_max_delay + $delta]
    set_output_delay_to_macro $wb_inputs $wb_clock_name $clk_source \
        [expr $caravel_in_min_delay + $delta] [expr $caravel_period - $caravel_in_max_delay + $delta]
}

###################### GENERAL CONSTRAINTS ############################# 

set_false_path -through [get_pins $cvl/user_wb_rst_o]
#set_case_analysis 0 [get_pins $cvl/user_wb_rst_o]

set clocks [all_clocks]
set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
if { [info exists ::env(MAX_TRANSITION_CONSTRAINT)] } {
    set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]
}
if { [info exists ::env(MAX_CAPACITANCE_CONSTRAINT)] } {
    set_max_capacitance $::env(MAX_CAPACITANCE_CONSTRAINT) [current_design]
}

set cap_load [expr $::env(OUTPUT_CAP_LOAD) / 1000.0]
puts "\[INFO] Setting load to: $cap_load"
set_load $cap_load [all_outputs]

puts "\[INFO] Setting clock uncertainty to: $::env(CLOCK_UNCERTAINTY_CONSTRAINT)"
set_clock_uncertainty $::env(CLOCK_UNCERTAINTY_CONSTRAINT) $clocks

puts "\[INFO] Setting clock transition to: $::env(CLOCK_TRANSITION_CONSTRAINT)"
set_clock_transition $::env(CLOCK_TRANSITION_CONSTRAINT) $clocks

puts "\[INFO] Setting timing derate to: $::env(TIME_DERATING_CONSTRAINT)%"
set_timing_derate -early [expr 1-[expr $::env(TIME_DERATING_CONSTRAINT) / 100]]
set_timing_derate -late [expr 1+[expr $::env(TIME_DERATING_CONSTRAINT) / 100]]

if { [info exists ::env(OPENLANE_SDC_IDEAL_CLOCKS)] && $::env(OPENLANE_SDC_IDEAL_CLOCKS) } {
    unset_propagated_clock [all_clocks]
} else {
    set_propagated_clock [all_clocks]
}
