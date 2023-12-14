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
  reg p0_____state_2__1;
  reg p0_not_196;
  reg p0_input_symbol;
  reg [3:0] ____state_1;
  reg ____state_0;
  reg p0_valid;
  reg [1:0] __rle1__input_r_reg;
  reg __rle1__input_r_valid_reg;
  reg [5:0] __rle1__output_s_reg;
  reg __rle1__output_s_valid_reg;
  wire prev_symbol_valid;
  wire p1_all_active_states_valid;
  wire symbol_differ;
  wire overflow;
  wire p1_all_active_inputs_valid;
  wire p1_stage_valid;
  wire do_send;
  wire rle1__output_s_valid_inv;
  wire __rle1__output_s_vld_buf;
  wire rle1__output_s_valid_load_en;
  wire rle1__output_s_load_en;
  wire not_196;
  wire p1_all_active_states_ready;
  wire rle1__input_r_not_pred;
  wire p1_stage_done;
  wire p1_not_valid;
  wire p0_all_active_states_valid;
  wire p0_all_active_outputs_ready;
  wire p0_all_active_states_ready;
  wire p0_enable;
  wire p0_stage_done;
  wire [1:0] rle1__input_r_select;
  wire p0_data_enable;
  wire [3:0] add_231;
  wire rle1__input_r_valid_inv;
  wire rle1__input_r_valid_load_en;
  wire input_symbol;
  wire [3:0] count;
  wire last;
  wire rle1__input_r_load_en;
  wire [5:0] __rle1__output_s_buf;
  assign prev_symbol_valid = ____state_1 != 4'h0;
  assign p1_all_active_states_valid = 1'h1;
  assign symbol_differ = prev_symbol_valid & (p0_input_symbol ^ ____state_0);
  assign overflow = ____state_1 == 4'hf;
  assign p1_all_active_inputs_valid = 1'h1;
  assign p1_stage_valid = p1_all_active_states_valid & p0_valid;
  assign do_send = p0_____state_2__1 | symbol_differ | overflow;
  assign rle1__output_s_valid_inv = ~__rle1__output_s_valid_reg;
  assign __rle1__output_s_vld_buf = p1_all_active_inputs_valid & p1_stage_valid & 1'h1 & do_send;
  assign rle1__output_s_valid_load_en = rle1__output_s_rdy | rle1__output_s_valid_inv;
  assign rle1__output_s_load_en = __rle1__output_s_vld_buf & rle1__output_s_valid_load_en;
  assign not_196 = ~____state_2;
  assign p1_all_active_states_ready = 1'h1;
  assign rle1__input_r_not_pred = ~not_196;
  assign p1_stage_done = p1_stage_valid & p1_all_active_inputs_valid & (~do_send | rle1__output_s_load_en) & p1_all_active_states_ready;
  assign p1_not_valid = ~p0_valid;
  assign p0_all_active_states_valid = 1'h1;
  assign p0_all_active_outputs_ready = 1'h1;
  assign p0_all_active_states_ready = 1'h1;
  assign p0_enable = p1_stage_done | p1_not_valid;
  assign p0_stage_done = p0_all_active_states_valid & (rle1__input_r_not_pred | __rle1__input_r_valid_reg) & p0_all_active_outputs_ready & p0_all_active_states_ready;
  assign rle1__input_r_select = not_196 ? __rle1__input_r_reg : literal_200;
  assign p0_data_enable = p0_enable & p0_stage_done;
  assign add_231 = ____state_1 + 4'h1;
  assign rle1__input_r_valid_inv = ~__rle1__input_r_valid_reg;
  assign rle1__input_r_valid_load_en = not_196 & p0_data_enable | rle1__input_r_valid_inv;
  assign input_symbol = ~(____state_2 | ~rle1__input_r_select[1:1]);
  assign count = (symbol_differ | overflow ? 4'h1 : add_231) & {4{p0_not_196}};
  assign last = ~(____state_2 | ~rle1__input_r_select[0:0]);
  assign rle1__input_r_load_en = rle1__input_r_vld & rle1__input_r_valid_load_en;
  assign __rle1__output_s_buf = {____state_0, ____state_1, p0_____state_2__1};
  always_ff @ (posedge clk) begin
    if (reset) begin
      ____state_2 <= 1'h0;
      p0_____state_2__1 <= 1'h0;
      p0_not_196 <= 1'h0;
      p0_input_symbol <= 1'h0;
      ____state_1 <= 4'h0;
      ____state_0 <= 1'h0;
      p0_valid <= 1'h0;
      __rle1__input_r_reg <= __rle1__input_r_reg_init;
      __rle1__input_r_valid_reg <= 1'h0;
      __rle1__output_s_reg <= __rle1__output_s_reg_init;
      __rle1__output_s_valid_reg <= 1'h0;
    end else begin
      ____state_2 <= p0_data_enable ? last : ____state_2;
      p0_____state_2__1 <= p0_data_enable ? ____state_2 : p0_____state_2__1;
      p0_not_196 <= p0_data_enable ? not_196 : p0_not_196;
      p0_input_symbol <= p0_data_enable ? input_symbol : p0_input_symbol;
      ____state_1 <= p1_stage_done ? count : ____state_1;
      ____state_0 <= p1_stage_done ? p0_input_symbol : ____state_0;
      p0_valid <= p0_enable ? p0_stage_done : p0_valid;
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
