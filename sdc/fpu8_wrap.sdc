###############################################################################
# Created by write_sdc
# Thu Dec 14 01:20:36 2023
###############################################################################
current_design fpu8_wrap
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name __VIRTUAL_CLK__ -period 50.0000 
set_clock_uncertainty 0.2500 __VIRTUAL_CLK__
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[0]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[1]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[2]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[3]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[4]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[5]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[6]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {a[7]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[0]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[1]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[2]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[3]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[4]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[5]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[6]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {b[7]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {op[0]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {op[1]}]
set_input_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {op[2]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[0]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[1]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[2]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[3]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[4]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[5]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[6]}]
set_output_delay 10.0000 -clock [get_clocks {__VIRTUAL_CLK__}] -add_delay [get_ports {out[7]}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0729 [get_ports {out[7]}]
set_load -pin_load 0.0729 [get_ports {out[6]}]
set_load -pin_load 0.0729 [get_ports {out[5]}]
set_load -pin_load 0.0729 [get_ports {out[4]}]
set_load -pin_load 0.0729 [get_ports {out[3]}]
set_load -pin_load 0.0729 [get_ports {out[2]}]
set_load -pin_load 0.0729 [get_ports {out[1]}]
set_load -pin_load 0.0729 [get_ports {out[0]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[7]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[6]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[5]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[4]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[3]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {a[0]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[7]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[6]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[5]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[4]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[3]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {b[0]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {op[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {op[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {op[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_fanout 10.0000 [current_design]
