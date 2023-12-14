module rle1_enc(
  input wire clk,
  input wire reset,
  input wire [1:0] rle1__input_r,
  input wire rle1__input_r_vld,
  input wire rle1__output_s_rdy,
  output wire [5:0] rle1__output_s,
  output wire rle1__output_s_vld,
  output wire rle1__input_r_rdy
);
  wire [1:0] __rle1__input_r_reg_init;
  assign __rle1__input_r_reg_init = {1'h0, 1'h0};
  wire [5:0] __rle1__output_s_reg_init;
  assign __rle1__output_s_reg_init = {1'h0, 4'h0, 1'h0};
  wire [1:0] literal_200;
  assign literal_200 = {1'h0, 1'h0};
  reg ____state_2;
  reg [3:0] ____state_1;
  reg ____state_0;
  reg [1:0] __rle1__input_r_reg;
  reg __rle1__input_r_valid_reg;
  reg [5:0] __rle1__output_s_reg;
  reg __rle1__output_s_valid_reg;
  wire [1:0] rle1__input_r_select;
  wire input_symbol;
  wire prev_symbol_valid;
  wire rle1__input_r_not_pred;
  wire symbol_differ;
  wire overflow;
  wire or_235;
  wire p0_all_active_states_valid;
  wire do_send;
  wire rle1__output_s_valid_inv;
  wire __rle1__output_s_vld_buf;
  wire rle1__output_s_valid_load_en;
  wire rle1__output_s_load_en;
  wire p0_all_active_states_ready;
  wire p0_stage_done;
  wire pipeline_enable;
  wire [3:0] add_218;
  wire rle1__input_r_valid_inv;
  wire rle1__input_r_valid_load_en;
  wire [3:0] count;
  wire last;
  wire rle1__input_r_load_en;
  wire [5:0] __rle1__output_s_buf;
  assign rle1__input_r_select = ~____state_2 ? __rle1__input_r_reg : literal_200;
  assign input_symbol = ~(____state_2 | ~rle1__input_r_select[1:1]);
  assign prev_symbol_valid = ____state_1 != 4'h0;
  assign rle1__input_r_not_pred = ~(~____state_2);
  assign symbol_differ = prev_symbol_valid & (input_symbol ^ ____state_0);
  assign overflow = ____state_1 == 4'hf;
  assign or_235 = rle1__input_r_not_pred | __rle1__input_r_valid_reg;
  assign p0_all_active_states_valid = 1'h1;
  assign do_send = ____state_2 | symbol_differ | overflow;
  assign rle1__output_s_valid_inv = ~__rle1__output_s_valid_reg;
  assign __rle1__output_s_vld_buf = or_235 & p0_all_active_states_valid & 1'h1 & do_send;
  assign rle1__output_s_valid_load_en = rle1__output_s_rdy | rle1__output_s_valid_inv;
  assign rle1__output_s_load_en = __rle1__output_s_vld_buf & rle1__output_s_valid_load_en;
  assign p0_all_active_states_ready = 1'h1;
  assign p0_stage_done = p0_all_active_states_valid & or_235 & (~do_send | rle1__output_s_load_en) & p0_all_active_states_ready;
  assign pipeline_enable = p0_stage_done & p0_stage_done;
  assign add_218 = ____state_1 + 4'h1;
  assign rle1__input_r_valid_inv = ~__rle1__input_r_valid_reg;
  assign rle1__input_r_valid_load_en = ~____state_2 & pipeline_enable | rle1__input_r_valid_inv;
  assign count = (symbol_differ | overflow ? 4'h1 : add_218) & {4{~____state_2}};
  assign last = ~(____state_2 | ~rle1__input_r_select[0:0]);
  assign rle1__input_r_load_en = rle1__input_r_vld & rle1__input_r_valid_load_en;
  assign __rle1__output_s_buf = {____state_0, ____state_1, ____state_2};
  always @ (posedge clk) begin
    if (reset) begin
      ____state_2 <= 1'h0;
      ____state_1 <= 4'h0;
      ____state_0 <= 1'h0;
      __rle1__input_r_reg <= __rle1__input_r_reg_init;
      __rle1__input_r_valid_reg <= 1'h0;
      __rle1__output_s_reg <= __rle1__output_s_reg_init;
      __rle1__output_s_valid_reg <= 1'h0;
    end else begin
      ____state_2 <= pipeline_enable ? last : ____state_2;
      ____state_1 <= pipeline_enable ? count : ____state_1;
      ____state_0 <= pipeline_enable ? input_symbol : ____state_0;
      __rle1__input_r_reg <= rle1__input_r_load_en ? rle1__input_r : __rle1__input_r_reg;
      __rle1__input_r_valid_reg <= rle1__input_r_valid_load_en ? rle1__input_r_vld : __rle1__input_r_valid_reg;
      __rle1__output_s_reg <= rle1__output_s_load_en ? __rle1__output_s_buf : __rle1__output_s_reg;
      __rle1__output_s_valid_reg <= rle1__output_s_valid_load_en ? __rle1__output_s_vld_buf : __rle1__output_s_valid_reg;
    end
  end
  assign rle1__output_s = __rle1__output_s_reg;
  assign rle1__output_s_vld = __rle1__output_s_valid_reg;
  assign rle1__input_r_rdy = rle1__input_r_load_en;
endmodule
