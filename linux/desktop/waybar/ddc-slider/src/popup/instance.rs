//! Single-instance toggle via a PID file in `$XDG_RUNTIME_DIR`.

use anyhow::{Context, Result};
use crate::util::runtime_file;
use std::fs;
use std::process::Command;
use std::thread;
use std::time::Duration;

const PID_FILE: &str = "ddc-slider.pid";

pub fn close_existing() -> Result<bool> {
    let path = runtime_file(PID_FILE);
    if !path.exists() {
        return Ok(false);
    }

    let pid = fs::read_to_string(&path)
        .context("read popup pid file")?
        .trim()
        .parse::<i32>()
        .context("parse popup pid")?;

    if pid == std::process::id() as i32 {
        return Ok(false);
    }

    let alive = Command::new("kill")
        .args(["-0", &pid.to_string()])
        .status()
        .map(|s| s.success())
        .unwrap_or(false);

    let _ = fs::remove_file(&path);

    if !alive {
        return Ok(false);
    }

    let _ = Command::new("kill").arg(pid.to_string()).status();
    thread::sleep(Duration::from_millis(80));
    Ok(true)
}

pub fn write_pid() {
    let _ = fs::write(runtime_file(PID_FILE), std::process::id().to_string());
}

pub fn remove_pid() {
    let _ = fs::remove_file(runtime_file(PID_FILE));
}
