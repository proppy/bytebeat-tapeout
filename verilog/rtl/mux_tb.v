module demux(
 input wire [2:0]   sel,
 input wire [18:0]  bus,
 output wire [18:0] a,
 output wire [18:0] b,
 output wire [18:0] c
);
   assign {a, b, c} = {
      sel[0] ? bus : {19{1'bz}},
      sel[1] ? bus : {19{1'bz}},
      sel[2] ? bus : {19{1'bz}}
   };
endmodule // dexmux

module mux(
 input wire [2:0] sel,
 input wire [7:0] a,
 input wire [7:0] b,
 input wire [7:0] c,
 output wire [7:0]  bus
);
   assign bus = sel[0] ? a : (sel[1] ? b : (sel[2] ? c : {7{1'bz}}));
endmodule // dexmux



module demux_tb;
   reg [2:0] sel;
   reg [18:0] bus;

   wire [18:0] a;
   wire [18:0] b;
   wire [18:0] c;

   demux demux0(
      .sel(sel),
      .bus(bus),
      .a(a),
      .b(b),
      .c(c)
   );

   initial begin
      $monitor("sel = %b, bus = %b\na = %b, b = %b, c = %b", sel, bus, a, b, c);
      $dumpfile("test.vcd");
      $dumpvars(0, demux_tb);

      bus <= 19'd42;
      sel <= 3'b001; #1;
      sel <= 3'b010; #1;
      sel <= 3'b100; #1;
      $finish;
   end
endmodule

module demux3_19_tb;
   reg [2:0] sel;
   reg [18:0] bus;

   wire [18:0] a;
   wire [18:0] b;
   wire [18:0] c;

   demux3_19 demux0(
      .sel(sel),
      .driver(bus),
      .out({a, b, c})
   );

   initial begin
      $monitor("sel = %b, bus = %b\na = %b, b = %b, c = %b", sel, bus, a, b, c);
      $dumpfile("test.vcd");
      $dumpvars(0, demux3_19_tb);

      bus <= 19'd42;
      sel <= 3'b001; #1;
      sel <= 3'b010; #1;
      sel <= 3'b100; #1;
      $finish;
   end
endmodule

module mux_tb;
   reg [2:0] sel;
   reg [7:0] a;
   reg [7:0] b;
   reg [7:0] c;

   wire [7:0] bus;

   mux mux0(
      .sel(sel),
      .a(a),
      .b(b),
      .c(c),
      .bus(bus)
   );

   initial begin
      $monitor("sel = %b, na = %b, b = %b, c = %b\nbus = %b", sel, a, b, c, bus);
      $dumpfile("test.vcd");
      $dumpvars(0, mux_tb);

      a <= 19'd42;
      b <= 19'd43;
      c <= 19'd44;
      sel <= 3'b001; #1;
      sel <= 3'b010; #1;
      sel <= 3'b100; #1;
      $finish;
   end
endmodule

module mux3_8_tb;
   reg [2:0] sel;
   reg [7:0] a;
   reg [7:0] b;
   reg [7:0] c;

   wire [7:0] bus;

   mux3_8 mux0(
      .sel(sel),
      .drivers({a, b, c}),
      .out(bus)
   );

   initial begin
      $monitor("sel = %b, na = %b, b = %b, c = %b\nbus = %b", sel, a, b, c, bus);
      $dumpfile("test.vcd");
      $dumpvars(0, mux3_8_tb);

      a <= 19'd42;
      b <= 19'd43;
      c <= 19'd44;
      sel <= 3'b001; #1;
      sel <= 3'b010; #1;
      sel <= 3'b100; #1;
      $finish;
   end
endmodule
