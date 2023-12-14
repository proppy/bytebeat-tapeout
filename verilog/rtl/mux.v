module demux3_19(
  input wire [2:0] sel,
  input wire [18:0] driver,
  output wire [56:0] out
);
  assign out = {driver & {19{sel == 3'h1}}, driver & {19{sel == 3'h2}}, driver & {19{sel == 3'h4}}};
endmodule

module mux3_8(
  input wire [2:0] sel,
  input wire [23:0] drivers,
  output wire [7:0] out
);
  wire [2:0] concat_89;
  assign concat_89 = {sel == 3'h4, sel == 3'h2, sel == 3'h1};
  assign out = drivers[23:16] & {8{concat_89[0]}} | drivers[15:8] & {8{concat_89[1]}} | drivers[7:0] & {8{concat_89[2]}};
endmodule
