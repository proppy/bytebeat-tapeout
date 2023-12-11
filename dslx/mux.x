// Copyright 2023 The XLS Authors
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

import apfloat
import rle.rle_common
import rle.rle_dec
import rle.rle_enc

const EXP_SZ = u32:4;
const FRACTION_SZ = u32:3;
type F8 = apfloat::APFloat<EXP_SZ, FRACTION_SZ>;

const SYMBOL_WIDTH = u32:1;
const COUNT_WIDTH = u32:6;
type RleCompressed = rle_common::CompressedData<SYMBOL_WIDTH, COUNT_WIDTH>;
type RlePlain = rle_common::PlainData<SYMBOL_WIDTH>;

enum Sel: u3 {
  NOOP = 0,
  F8_ADD = 1,
  F8_SUB = 2,
  F8_MUL = 3,
  RLE_OP = 4,
}

struct Arg2 {
  sel: Sel,
  a: u8,
  b: u8,
}

fn u8_to_f8(a: u8) -> F8 {
  F8{sign: a[7:8], bexp: a[3:7], fraction: a[0:3]}
}

fn f8_to_u8(a: F8) -> u8 {
  a.sign ++ a.bexp ++ a.fraction
}

#[test]
fn u8_to_f8_test() {
  assert_eq(f8_to_u8(u8_to_f8(u8:0b10101101)), u8:0b10101101);
}

enum RleOp: u2 {
    RLE_ENC_READ = 0,
    RLE_ENC_WRITE = 1,
    RLE_DEC_READ = 2,
    RLE_DEC_WRITE = 3,
}

proc Mux {
  input_r: chan<Arg2> in;
  output_s: chan<u8> out;
  rle_enc_input_s: chan<RlePlain> out;
  rle_enc_output_r: chan<RleCompressed> in;
  rle_dec_input_s: chan<RleCompressed> out;
  rle_dec_output_r: chan<RlePlain> in;

  init {
    ()
  }

  config(input_r: chan<Arg2> in, output_s: chan<u8> out) {
    let (rle_enc_input_s, rle_enc_input_r) = chan<RlePlain>;
    let (rle_enc_output_s, rle_enc_output_r) = chan<RleCompressed>;
    let (rle_dec_input_s, rle_dec_input_r) = chan<RleCompressed>;
    let (rle_dec_output_s, rle_dec_output_r) = chan<RlePlain>;

    spawn rle_enc::RunLengthEncoder<SYMBOL_WIDTH, COUNT_WIDTH>(rle_enc_input_r, rle_enc_output_s);
    spawn rle_dec::RunLengthDecoder<SYMBOL_WIDTH, COUNT_WIDTH>(rle_dec_input_r, rle_dec_output_s);
    (input_r, output_s, rle_enc_input_s, rle_enc_output_r, rle_dec_input_s, rle_dec_output_r)
  }

  next(tok: token, state: ()) {
    let (tok, arg2) = recv(tok, input_r);
    match(arg2.sel) {
      Sel::NOOP => {send(tok, output_s, arg2.a);},
      Sel::F8_ADD => {send(tok, output_s, f8_to_u8(apfloat::add(u8_to_f8(arg2.a), u8_to_f8(arg2.b))));},
      Sel::F8_SUB => {send(tok, output_s, f8_to_u8(apfloat::sub(u8_to_f8(arg2.a), u8_to_f8(arg2.b))));},
      Sel::F8_MUL => {send(tok, output_s, f8_to_u8(apfloat::mul(u8_to_f8(arg2.a), u8_to_f8(arg2.b))));},
      Sel::RLE_OP => {
	match(arg2.a[0+:u2] as RleOp) {
	  RleOp::RLE_ENC_WRITE => {
	    send(tok, rle_enc_input_s, RlePlain{
	      symbol: arg2.b[0+:uN[SYMBOL_WIDTH]],
	      last: arg2.b[SYMBOL_WIDTH+COUNT_WIDTH+:u1],
	    });
	  },
	  RleOp::RLE_ENC_READ => {
	    let (tok, enc_output) = recv(tok, rle_enc_output_r);
	    send(tok, output_s, (enc_output.last ++ enc_output.count ++ enc_output.symbol) as u8);
	  },
	  RleOp::RLE_DEC_WRITE => {
	    send(tok, rle_dec_input_s, RleCompressed{
	      symbol: arg2.b[0+:uN[SYMBOL_WIDTH]],
	      count: arg2.b[SYMBOL_WIDTH+:uN[COUNT_WIDTH]],
	      last: arg2.b[SYMBOL_WIDTH+COUNT_WIDTH+:u1]
	    });
	  },
	  RleOp::RLE_DEC_READ => {
	    let (tok, dec_output) = recv(tok, rle_dec_output_r);
	    send(tok, output_s, (dec_output.last ++ uN[COUNT_WIDTH]:0 ++ dec_output.symbol) as u8);
	  },
	  _ => fail!("mux_unsupported_rle_op", ()),
	}
      },
      _ => fail!("mux_unsupported_sel", ()),
    };
  }
}

#[test_proc]
proc mux_noop_test {
  mux_input_s: chan<Arg2> out;
  mux_output_r: chan<u8> in;
  terminator: chan<bool> out;

  init { () }

  config(terminator: chan<bool> out) {
    let (mux_input_s, mux_input_r) = chan<Arg2>;
    let (mux_output_s, mux_output_r) = chan<u8>;
    spawn Mux(mux_input_r, mux_output_s);
    (mux_input_s, mux_output_r, terminator)
  }

  next(tok: token, state: ()) {
    let tok = send(tok, mux_input_s, Arg2{sel: Sel::NOOP, a: u8:42, b: u8:0});
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(result, u8:42);

    send(tok, terminator, true);
  }
}

#[test_proc]
proc mux_f8_test {
  mux_input_s: chan<Arg2> out;
  mux_output_r: chan<u8> in;
  terminator: chan<bool> out;

  init { () }

  config(terminator: chan<bool> out) {
    let (mux_input_s, mux_input_r) = chan<Arg2>;
    let (mux_output_s, mux_output_r) = chan<u8>;
    spawn Mux(mux_input_r, mux_output_s);
    (mux_input_s, mux_output_r, terminator)
  }

  next(tok: token, state: ()) {
    const f8_a = u8_to_f8(u8:0b01010011);
    const f8_b = u8_to_f8(u8:0b00100001);

    // add
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::F8_ADD,
      a: f8_to_u8(f8_a),
      b: f8_to_u8(f8_b),
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(u8_to_f8(result), apfloat::add(f8_a, f8_b));

    // sub
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::F8_SUB,
      a: f8_to_u8(f8_a),
      b: f8_to_u8(f8_b),
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(u8_to_f8(result), apfloat::sub(f8_a, f8_b));

    // mul
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::F8_MUL,
      a: f8_to_u8(f8_a),
      b: f8_to_u8(f8_b),
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(u8_to_f8(result), apfloat::mul(f8_a, f8_b));

    send(tok, terminator, true);
  }
}


#[test_proc]
proc mux_rle_test {
  mux_input_s: chan<Arg2> out;
  mux_output_r: chan<u8> in;
  terminator: chan<bool> out;

  init { () }

  config(terminator: chan<bool> out) {
    let (mux_input_s, mux_input_r) = chan<Arg2>;
    let (mux_output_s, mux_output_r) = chan<u8>;
    spawn Mux(mux_input_r, mux_output_s);
    (mux_input_s, mux_output_r, terminator)
  }

  next(tok: token, state: ()) {
    // rle enc
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_ENC_WRITE as u8,
      b: u8:0b0_000000_1, // symbol: 1, last: false
    });
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_ENC_WRITE as u8, 
      b: u8:0b0_000000_1, // symbol: 1, last: false
    });
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_ENC_WRITE as u8,
      b: u8:0b1_000000_1, // symbol: 1, last: false
    });
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_ENC_READ as u8,
      b: u8:0,
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(result, u8:0b1_000011_1);  // last: true, count: 3, symbol: 1

    // rle dec
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_DEC_WRITE as u8,
      b: u8:0b1_000011_1,  // last: true, count: 3, symbol: 1
    });
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_DEC_READ as u8,
      b: u8:0,
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(result, u8:1);
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_DEC_READ as u8,
      b: u8:0,
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(result, u8:1);
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::RLE_OP,
      a: RleOp::RLE_DEC_READ as u8,
      b: u8:0,
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(result, u8:0b1_000000_1);  // last: true, symbol: 1

    send(tok, terminator, true);
  }
}
