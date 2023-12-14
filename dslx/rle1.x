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

import rle.rle_enc
import rle.rle_dec
import rle.rle_common

const SYMBOL_WIDTH = u32:1;
const COUNT_WIDTH = u32:4;

type Rle1Compressed = rle_common::CompressedData<SYMBOL_WIDTH, COUNT_WIDTH>;
type Rle1Plain = rle_common::PlainData<SYMBOL_WIDTH>;

proc Rle1Encoder {
    init {()}

    config (
        input_r: chan<Rle1Plain> in,
        output_s: chan<Rle1Compressed> out,
    ) {
        spawn rle_enc::RunLengthEncoder<SYMBOL_WIDTH, COUNT_WIDTH>(input_r, output_s);
        ()
    }

    next (tok: token, state: ()) {
        ()
    }
}

proc Rle1Decoder {
    init {()}
    
    config (
        input_r: chan<Rle1Compressed> in,
        output_s: chan<Rle1Plain> out,
    ) {
        spawn rle_dec::RunLengthDecoder<SYMBOL_WIDTH, COUNT_WIDTH>(input_r, output_s);
        ()
    }

    next (tok: token, state: ()) {
        ()
    }
}

#[test_proc]
proc RleEncoderTest {
    rle_input_s: chan<Rle1Plain> out;
    rle_output_r: chan<Rle1Compressed> in;
    terminator: chan<bool> out;
    
    init {
    }
    
    config(terminator: chan<bool> out) {
	let (rle_input_s, rle_input_r) = chan<Rle1Plain>;
	let (rle_output_s, rle_output_r) = chan<Rle1Compressed>;
	spawn Rle1Encoder(rle_input_r, rle_output_s);
	(rle_input_s, rle_output_r, terminator)
    }

    next(tok: token, state: ()) {
	let tok = send(tok, rle_input_s, Rle1Plain{symbol: uN[SYMBOL_WIDTH]:1, last: false});
	let tok = send(tok, rle_input_s, Rle1Plain{symbol: uN[SYMBOL_WIDTH]:1, last: false});
	let tok = send(tok, rle_input_s, Rle1Plain{symbol: uN[SYMBOL_WIDTH]:1, last: true});
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, uN[SYMBOL_WIDTH]:1);
	assert_eq(result.count, uN[COUNT_WIDTH]:3);
	assert_eq(result.last, true);

	send(tok, terminator, true);
    }
}

#[test_proc]
proc RleDecoderTest {
    rle_input_s: chan<Rle1Compressed> out;
    rle_output_r: chan<Rle1Plain> in;
    terminator: chan<bool> out;
    
    init {
    }
    
    config(terminator: chan<bool> out) {
	let (rle_input_s, rle_input_r) = chan<Rle1Compressed>;
	let (rle_output_s, rle_output_r) = chan<Rle1Plain>;
	spawn Rle1Decoder(rle_input_r, rle_output_s);
	(rle_input_s, rle_output_r, terminator)
    }

    next(tok: token, state: ()) {
	let tok = send(tok, rle_input_s, Rle1Compressed{
	    symbol: uN[SYMBOL_WIDTH]:1, count: uN[COUNT_WIDTH]:3, last: true,
	});
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, uN[SYMBOL_WIDTH]:1);
	assert_eq(result.last, false);
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, uN[SYMBOL_WIDTH]:1);
	assert_eq(result.last, false);
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, uN[SYMBOL_WIDTH]:1);
	assert_eq(result.last, true);

	send(tok, terminator, true);
    }
}
