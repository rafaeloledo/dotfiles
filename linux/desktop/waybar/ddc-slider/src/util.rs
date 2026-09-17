//! Shared helpers for runtime paths and background work.

use gtk4::glib::ControlFlow;
use std::path::PathBuf;
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

/// `$XDG_RUNTIME_DIR`, falling back to `/tmp`.
pub fn runtime_dir() -> PathBuf {
    std::env::var("XDG_RUNTIME_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(|_| PathBuf::from("/tmp"))
}

pub fn runtime_file(name: &str) -> PathBuf {
    runtime_dir().join(name)
}

/// Run `work` on a background thread and invoke `on_result` on the GTK main loop.
pub fn poll_background<T, F, H>(work: F, on_result: H)
where
    T: Send + 'static,
    F: FnOnce() -> T + Send + 'static,
    H: FnMut(T) -> ControlFlow + 'static,
{
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        let _ = tx.send(work());
    });

    glib_timeout_poll(rx, on_result);
}

fn glib_timeout_poll<T, H>(rx: mpsc::Receiver<T>, mut on_result: H)
where
    T: Send + 'static,
    H: FnMut(T) -> ControlFlow + 'static,
{
    gtk4::glib::timeout_add_local(Duration::from_millis(40), move || {
        match rx.try_recv() {
            Ok(value) => on_result(value),
            Err(mpsc::TryRecvError::Empty) => ControlFlow::Continue,
            Err(mpsc::TryRecvError::Disconnected) => ControlFlow::Break,
        }
    });
}
