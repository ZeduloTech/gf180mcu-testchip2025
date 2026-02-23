### Oscilator SDC (not required actually)

set_load -max 0.1 [all_outputs] 
set_load -min 0.006 [all_outputs] 
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__buf_1 -pin Z -min -from_pin I -input_transition_rise 1.0 -input_transition_fall 1.0 [all_inputs]
