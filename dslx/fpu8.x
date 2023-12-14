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

enum Op : u3 {
    ADD = 1,
    SUB = 2,
    MUL = 4,
}

fn u8_to_f8(a: u8) -> F8 { F8 { sign: a[7:8], bexp: a[3:7], fraction: a[0:3] } }

fn fpu8(op: Op, a: F8, b: F8) -> F8 {
    match (op) {
        Op::ADD => apfloat::add<EXP_SZ, FRACTION_SZ>(a, b),
        Op::SUB => apfloat::sub<EXP_SZ, FRACTION_SZ>(a, b),
        Op::MUL => apfloat::mul<EXP_SZ, FRACTION_SZ>(a, b),
        _ => fail!("fpu8_unsupported_op", apfloat::qnan<EXP_SZ, FRACTION_SZ>()),
    }
}

#[test]
fn fpu8_test() {
    const f8_a = u8_to_f8(u8:0b01010011);
    const f8_b = u8_to_f8(u8:0b00100001);

    assert_eq(fpu8(Op::ADD, f8_a, f8_b), apfloat::add<EXP_SZ, FRACTION_SZ>(f8_a, f8_b));
    assert_eq(fpu8(Op::SUB, f8_a, f8_b), apfloat::sub<EXP_SZ, FRACTION_SZ>(f8_a, f8_b));
    assert_eq(fpu8(Op::MUL, f8_a, f8_b), apfloat::mul<EXP_SZ, FRACTION_SZ>(f8_a, f8_b));
}
