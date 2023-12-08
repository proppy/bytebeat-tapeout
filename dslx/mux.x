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

const EXP_SZ = u32:4;
const FRACTION_SZ = u32:3;
type F8 = apfloat::APFloat<EXP_SZ, FRACTION_SZ>;

fn u8_to_f8(a: u8) -> F8 {
  F8{sign: a[7:8], bexp: a[3:7], fraction: a[0:3]}
}

fn f8_to_u8(a: F8) -> u8 {
  a.sign ++ a.bexp ++ a.fraction
}

#[test]
fn u8_f8_test() {
  assert_eq(f8_to_u8(u8_to_f8(u8:0b10101101)), u8:0b10101101);
}

enum Sel: u3 {
  NOOP = 0,
  F8_ADD = 1,
  F8_SUB = 2,
  F8_MUL = 3,
}

struct Arg2 {
  sel: Sel,
  a: u8,
  b: u8,
}

proc Mux {
  input_r: chan<Arg2> in;
  output_s: chan<u8> out;

  init {
    ()
  }

  config(input_r: chan<Arg2> in, output_s: chan<u8> out) {
    (input_r, output_s)
  }

  next(tok: token, state: ()) {
    let (tok, arg2) = recv(tok, input_r);
    let result = match(arg2.sel) {
      Sel::NOOP => arg2.a,
      Sel::F8_ADD => f8_to_u8(apfloat::add(u8_to_f8(arg2.a), u8_to_f8(arg2.b))),
      Sel::F8_SUB => f8_to_u8(apfloat::sub(u8_to_f8(arg2.a), u8_to_f8(arg2.b))),
      Sel::F8_MUL => f8_to_u8(apfloat::mul(u8_to_f8(arg2.a), u8_to_f8(arg2.b))),
      _ => fail!("mux_unsupported_sel", u8:0),
    };
    send(tok, output_s, result);
  }
}

#[test_proc]
proc mux_test {
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
    // noop
    let tok = send(tok, mux_input_s, Arg2{sel: Sel::NOOP, a: u8:42, b: u8:0});
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(result, u8:42);

    // f8
    const f8_a = u8_to_f8(u8:0b01010011);
    const f8_b = u8_to_f8(u8:0b00100001);

    // f8_add
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::F8_ADD,
      a: f8_to_u8(f8_a),
      b: f8_to_u8(f8_b),
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(u8_to_f8(result), apfloat::add(f8_a, f8_b));

    // f8_sub
    let tok = send(tok, mux_input_s, Arg2{
      sel: Sel::F8_SUB,
      a: f8_to_u8(f8_a),
      b: f8_to_u8(f8_b),
    });
    let (tok, result) = recv(tok, mux_output_r);
    assert_eq(u8_to_f8(result), apfloat::sub(f8_a, f8_b));

    // f8_mul
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
