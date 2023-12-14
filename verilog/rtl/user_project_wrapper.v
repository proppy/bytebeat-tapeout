// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [63:0] la_data_in,
    output [63:0] la_data_out,
    input  [63:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

   wire [18:0] bus_fpu8_in;
   wire [7:0]  bus_fpu8_out;
   wire [18:0] bus_rle1_enc_in;
   wire [7:0]  bus_rle1_enc_out;
   wire [18:0] bus_rle1_dec_in;
   wire [7:0]  bus_rle1_dec_out;

   demux3_19 demux_0(
       .sel(io_in[7:5]),
       .driver(io_in[26:8]),
       .out({bus_fpu8_in, bus_rle1_enc_in, bus_rle1_dec_in})
   );

   mux3_8 mux_0(
       .sel(io_in[7:5]),
       .drivers({bus_fpu8_out, bus_rle1_enc_out, bus_rle1_dec_out}),
       .out(io_out[34:27])
   );

fpu8_wrap fpu8_wrap_0 (
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
	.op(bus_fpu8_in[2:0]),
	.a(bus_fpu8_in[10:3]),
	.b(bus_fpu8_in[18:11]),
	.out(bus_fpu8_out)
);

rle1_enc_wrap rle1_enc_wrap_0 (
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
	.clk(bus_rle1_enc_in[0]),
	.reset(bus_rle1_enc_in[1]),
	.rle1__input_r(bus_rle1_enc_in[3:2]),
	.rle1__input_r_vld(bus_rle1_enc_in[4]),
	.rle1__output_s_rdy(bus_rle1_enc_in[5]),
	.rle1__output_s(bus_rle1_enc_out[5:0]),
	.rle1__output_s_vld(bus_rle1_enc_out[6]),
	.rle1__input_r_rdy(bus_rle1_enc_out[7])
);

rle1_dec_wrap rle1_dec_wrap_0(
`ifdef USE_POWER_PINS
	.vdd(vdd),	// User area 1 1.8V power
	.vss(vss),	// User area 1 digital ground
`endif
	.clk(bus_rle1_dec_in[0]),
	.reset(bus_rle1_dec_in[1]),
	.rle1__input_r(bus_rle1_dec_in[7:2]),
	.rle1__input_r_vld(bus_rle1_dec_in[8]),
	.rle1__output_s_rdy(bus_rle1_dec_in[9]),
	.rle1__output_s(bus_rle1_dec_out[1:0]),
	.rle1__output_s_vld(bus_rle1_dec_out[2]),
	.rle1__input_r_rdy(bus_rle1_dec_out[3])
);

assign io_oeb[34:27] = 8'b00000000;

endmodule	// user_project_wrapper

`default_nettype wire
