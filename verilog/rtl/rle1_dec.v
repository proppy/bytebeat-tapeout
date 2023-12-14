module rle1_dec(
  input wire clk,
  input wire reset,
  input wire [5:0] rle1__input_r,
  input wire rle1__input_r_vld,
  input wire rle1__output_s_rdy,
  output wire [1:0] rle1__output_s,
  output wire rle1__output_s_vld,
  output wire rle1__input_r_rdy
);
  wire [5:0] __rle1__input_r_reg_init;
  assign __rle1__input_r_reg_init = {1'h0, 4'h0, 1'h0};
  wire [1:0] __rle1__output_s_reg_init;
  assign __rle1__output_s_reg_init = {1'h0, 1'h0};
  wire [5:0] literal_164;
  assign literal_164 = {1'h0, 4'h0, 1'h0};
  reg [3:0] ____state_1;
  reg ____state_2;
  reg ____state_0;
  reg [5:0] __rle1__input_r_reg;
  reg __rle1__input_r_valid_reg;
  reg [1:0] __rle1__output_s_reg;
  reg __rle1__output_s_valid_reg;
  wire recv_next_symbol;
  wire [5:0] rle1__input_r_select;
  wire or_201;
  wire p0_all_active_states_valid;
  wire rle1__output_s_valid_inv;
  wire __rle1__output_s_vld_buf;
  wire rle1__output_s_valid_load_en;
  wire [3:0] input_count;
  wire rle1__output_s_load_en;
  wire p0_all_active_states_ready;
  wire [3:0] add_173;
  wire p0_stage_done;
  wire [3:0] next_count;
  wire pipeline_enable;
  wire input_last;
  wire done_sending;
  wire rle1__input_r_valid_inv;
  wire input_symbol;
  wire rle1__input_r_valid_load_en;
  wire send_last;
  wire and_195;
  wire nor_197;
  wire rle1__input_r_load_en;
  wire [1:0] __rle1__output_s_buf;
  assign recv_next_symbol = ____state_1 == 4'h0;
  assign rle1__input_r_select = recv_next_symbol ? __rle1__input_r_reg : literal_164;
  assign or_201 = ~recv_next_symbol | __rle1__input_r_valid_reg;
  assign p0_all_active_states_valid = 1'h1;
  assign rle1__output_s_valid_inv = ~__rle1__output_s_valid_reg;
  assign __rle1__output_s_vld_buf = or_201 & p0_all_active_states_valid & 1'h1;
  assign rle1__output_s_valid_load_en = rle1__output_s_rdy | rle1__output_s_valid_inv;
  assign input_count = recv_next_symbol ? rle1__input_r_select[4:1] : ____state_1;
  assign rle1__output_s_load_en = __rle1__output_s_vld_buf & rle1__output_s_valid_load_en;
  assign p0_all_active_states_ready = 1'h1;
  assign add_173 = input_count + 4'hf;
  assign p0_stage_done = p0_all_active_states_valid & or_201 & rle1__output_s_load_en & p0_all_active_states_ready;
  assign next_count = input_count == 4'h0 ? input_count : add_173;
  assign pipeline_enable = p0_stage_done & p0_stage_done;
  assign input_last = recv_next_symbol ? rle1__input_r_select[0:0] : ____state_2;
  assign done_sending = next_count == 4'h0;
  assign rle1__input_r_valid_inv = ~__rle1__input_r_valid_reg;
  assign input_symbol = recv_next_symbol ? rle1__input_r_select[5:5] : ____state_0;
  assign rle1__input_r_valid_load_en = recv_next_symbol & pipeline_enable | rle1__input_r_valid_inv;
  assign send_last = input_last & done_sending;
  assign and_195 = ~(input_last & done_sending) & input_symbol;
  assign nor_197 = ~(~input_last | done_sending);
  assign rle1__input_r_load_en = rle1__input_r_vld & rle1__input_r_valid_load_en;
  assign __rle1__output_s_buf = {input_symbol, send_last};
  always @ (posedge clk) begin
    if (reset) begin
      ____state_1 <= 4'h0;
      ____state_2 <= 1'h0;
      ____state_0 <= 1'h0;
      __rle1__input_r_reg <= __rle1__input_r_reg_init;
      __rle1__input_r_valid_reg <= 1'h0;
      __rle1__output_s_reg <= __rle1__output_s_reg_init;
      __rle1__output_s_valid_reg <= 1'h0;
    end else begin
      ____state_1 <= pipeline_enable ? next_count : ____state_1;
      ____state_2 <= pipeline_enable ? nor_197 : ____state_2;
      ____state_0 <= pipeline_enable ? and_195 : ____state_0;
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
