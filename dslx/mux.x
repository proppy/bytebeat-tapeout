fn demux3<N: u32, SN: u32 = {u32:3}>(sel: uN[SN], driver: uN[N]) -> (uN[N], uN[N], uN[N]) {
    // TODO(proppy): find out how to emit tri-state logic: 1'bz.
    const zzz = uN[N]:0;
    match(sel) {
	uN[SN]:0b001 => (driver, zzz, zzz),
	uN[SN]:0b010 => (zzz, driver, zzz),
	uN[SN]:0b100 => (zzz, zzz, driver),
	_ => (zzz, zzz, zzz),
    }
}

fn mux3<N: u32, SN: u32 = {u32:3}>(sel: uN[SN], drivers: (uN[N], uN[N], uN[N])) -> uN[N] {
    // TODO(proppy): find out how to emit tri-state logic: 1'bz.
    const zzz = uN[N]:0;
    match(sel) {
	uN[SN]:0b001 => drivers.0,
	uN[SN]:0b010 => drivers.1,
	uN[SN]:0b100 => drivers.2,
	_ => zzz,
    }
}

#[test]
fn demux_test() {
   const zzz = uN[6]:0b000000;
    assert_eq((u6:0b101010, zzz, zzz), demux3<6>(u3:0b001, u6:0b101010));
    assert_eq((zzz, u6:0b101010, zzz), demux3<6>(u3:0b010, u6:0b101010));
    assert_eq((zzz, zzz, u6:0b101010), demux3<6>(u3:0b100, u6:0b101010));
}

#[test]
fn mux_test() {
    assert_eq(u6:0b101010, mux3<6>(u3:0b001, (u6:0b101010, u6:0b110011, u6:0b010101)));
    assert_eq(u6:0b110011, mux3<6>(u3:0b010, (u6:0b101010, u6:0b110011, u6:0b010101)));
    assert_eq(u6:0b010101, mux3<6>(u3:0b100, (u6:0b101010, u6:0b110011, u6:0b010101)));	  		    
}

fn demux3_19(sel: u3, driver: u19) -> (u19, u19, u19) {
    demux3(sel, driver)
}

fn mux3_8(sel: u3, drivers: (u8, u8, u8)) -> u8 {
    mux3(sel, drivers)
}
