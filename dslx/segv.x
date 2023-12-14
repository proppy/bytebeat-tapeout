proc Segv {
  init {()}
  config() {}
  next(tok: token, state: ()) {
    let (tok, _) = match(u8:0) {
      u8:0 => (tok, u8:0),
      _ => fail!("segv_unsupported_case", (tok, u8:0)),
    };
  }
}
