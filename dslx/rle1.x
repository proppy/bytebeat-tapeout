import rle.rle_enc
import rle.rle_dec
import rle.rle_common

const SYMBOL_WIDTH = u32:1;
const COUNT_WIDTH = u32:7;

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
	let tok = send(tok, rle_input_s, Rle1Plain{symbol: u1:1, last: false});
	let tok = send(tok, rle_input_s, Rle1Plain{symbol: u1:1, last: false});
	let tok = send(tok, rle_input_s, Rle1Plain{symbol: u1:1, last: true});
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, u1:1);
	assert_eq(result.count, u7:3);
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
	    symbol: u1:1, count: u7:3, last: true,
	});
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, u1:1);
	assert_eq(result.last, false);
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, u1:1);
	assert_eq(result.last, false);
	let (tok, result) = recv(tok, rle_output_r);
	assert_eq(result.symbol, u1:1);
	assert_eq(result.last, true);

	send(tok, terminator, true);
    }
}
