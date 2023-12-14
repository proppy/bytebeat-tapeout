`default_nettype none

module fpu8_wrap(
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif
  input wire [2:0] op,
  input wire [7:0] a,
  input wire [7:0] b,
  output wire [7:0] out
);

fpu8 fpu8_0(
	.op(op),
	.a(a),
	.b(b),
	.out(out)
);
   
endmodule // fpu8
`default_nettype wire
