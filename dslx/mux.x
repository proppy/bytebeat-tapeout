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

enum Sel: u3 {
  NOOP = 0,
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

    send(tok, terminator, true);
  }
}
