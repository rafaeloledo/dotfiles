//! XDG runtime paths.

use std::path::PathBuf;

pub fn runtime_file(name: &str) -> PathBuf {
    let dir = std::env::var("XDG_RUNTIME_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from("/tmp"));
    dir.join(name)
}
