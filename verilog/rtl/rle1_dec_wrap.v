`default_nettype none

module rle1_dec_wrap(
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif
  input wire clk,
  input wire reset,
  input wire [1:0] rle1__input_r,
  input wire rle1__input_r_vld,
  input wire rle1__output_s_rdy,
  output wire [5:0] rle1__output_s,
  output wire rle1__output_s_vld,
  output wire rle1__input_r_rdy
);

rle1_dec rle1_dec_0(
        .clk(clk),
	.reset(reset),
        .rle1__input_r(rle1__input_r),
        .rle1__input_r_vld(rle1__input_r_vld),
        .rle1__output_s_rdy(rle1__output_s_rdy),
        .rle1__output_s(rle1__output_s),
        .rle1__output_s_vld(rle1__output_s_vld),
        .rle1__input_r_rdy(rle1__input_r_rdy)
);
   
endmodule // rle1_enc_wrap
`default_nettype wire
