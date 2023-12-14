###############################################################################
# Created by write_sdc
# Thu Dec 14 01:22:00 2023
###############################################################################
current_design rle1_enc_wrap
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 50.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {rle1__input_r_rdy}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s_vld}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s[5]}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s[4]}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s[3]}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s[2]}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s[1]}]
set_load -pin_load 0.1900 [get_ports {rle1__output_s[0]}]
set_input_transition 0.6100 [get_ports {clk}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_fanout 4.0000 [current_design]
