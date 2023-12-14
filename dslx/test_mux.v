module __mux__mux2x19_8(
  input wire [2:0] sel,
  input wire [18:0] input_a,
  input wire [18:0] input_b,
  input wire [18:0] input_c,
  input wire [7:0] output_a,
  input wire [7:0] output_b,
  input wire [7:0] output_c,
  output wire [26:0] out
);
  wire [2:0] concat_91;
  assign concat_91 = {sel == 3'h4, sel == 3'h2, sel == 3'h1};
  assign out = {input_a & {19{concat_91[0]}} | input_b & {19{concat_91[1]}} | input_c & {19{concat_91[2]}}, output_a & {8{concat_91[0]}} | output_b & {8{concat_91[1]}} | output_c & {8{concat_91[2]}}};
endmodule

module __mux__mux2x19_8_tb;
   reg [2:0] sel;
   reg [18:0] input_bus;
   reg [7:0]  output_bus;
   
   wire [18:0] input_a;
   wire [18:0] input_b;
   wire [18:0] input_c;
   wire [7:0]  output_a;
   wire [7:0]  output_b;
   wire [7:0]  output_c;
   
   __mux__mux2x19_8_tb mux0(
      .sel(sel),
      .input_a(input_a),
      .input_b(input_b),
      .input_c(input_c),
      .output_a(output_a),
      .output_b(output_b),
      .output_c(output_c),
      .out({input_bus, output_bus})
   );

   initial begin
      $dumpfile("test.vcd");
      $dumpvars(0,__mux__mux2x19_8_tb);

      input_bus <= 19'd42;
      output_bus <= 8'd43;
      sel <= 3'b001;
      #10 sel <= 3'b010;
      #10 sel <= 3'b100;
      #10 $finish;
   end
endmodule
			     
