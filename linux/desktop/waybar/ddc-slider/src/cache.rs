//! Per-display on-disk cache with atomic writes and inter-process locking.
//!
//!   `~/.cache/ddc-slider/<display>/brightness.json`   payload
//!   `~/.cache/ddc-slider/<display>/.fetch.lock`       flock target

use std::fs::{self, File, OpenOptions};
use std::path::PathBuf;
use std::time::SystemTime;

use fs2::FileExt;
use serde::{Deserialize, Serialize};

use crate::ddc::{Brightness, Monitor};
use crate::error::{AppError, Result};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CachePayload {
    pub monitor: Monitor,
    pub brightness: Brightness,
    pub fetched_at: u64,
}

#[derive(Debug, Clone)]
pub struct Cache {
    dir: PathBuf,
}

impl Cache {
    pub fn for_display(display: u8) -> Result<Self> {
        let base = xdg_cache_dir()?
            .join("ddc-slider")
            .join(display.to_string());
        Ok(Self { dir: base })
    }

    pub fn read(&self) -> Option<CachePayload> {
        let json = fs::read_to_string(self.payload_path()).ok()?;
        serde_json::from_str(&json).ok()
    }

    pub fn write(&self, monitor: &Monitor, brightness: Brightness) -> Result<()> {
        self.ensure_dir()?;
        let payload = CachePayload {
            monitor: monitor.clone(),
            brightness,
            fetched_at: unix_now(),
        };
        let tmp = self.dir.join("brightness.json.tmp");
        let json = serde_json::to_string(&payload)
            .map_err(|e| AppError::message(format!("serialize cache: {e}")))?;
        fs::write(&tmp, json).map_err(|e| AppError::io_at(&tmp, e))?;
        fs::rename(&tmp, self.payload_path()).map_err(|e| AppError::io_at(self.payload_path(), e))
    }

    pub fn acquire_lock(&self) -> Result<File> {
        self.ensure_dir()?;
        let file = OpenOptions::new()
            .create(true)
            .write(true)
            .truncate(false)
            .open(self.lock_path())
            .map_err(|e| AppError::io_at(self.lock_path(), e))?;
        file.lock_exclusive()
            .map_err(|e| AppError::io_at(self.lock_path(), e))?;
        Ok(file)
    }

    fn ensure_dir(&self) -> Result<()> {
        fs::create_dir_all(&self.dir).map_err(|e| AppError::io_at(&self.dir, e))
    }

    fn payload_path(&self) -> PathBuf {
        self.dir.join("brightness.json")
    }

    fn lock_path(&self) -> PathBuf {
        self.dir.join(".fetch.lock")
    }
}

fn xdg_cache_dir() -> Result<PathBuf> {
    if let Ok(dir) = std::env::var("XDG_CACHE_HOME") {
        if !dir.is_empty() {
            return Ok(PathBuf::from(dir));
        }
    }
    std::env::var("HOME")
        .map(|home| PathBuf::from(home).join(".cache"))
        .map_err(|_| AppError::message("$HOME is not set"))
}

fn unix_now() -> u64 {
    SystemTime::now()
        .duration_since(SystemTime::UNIX_EPOCH)
        .map(|d| d.as_secs())
        .unwrap_or(0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip_payload() {
        let dir = std::env::temp_dir().join(format!("ddc-slider-cache-{}", std::process::id()));
        let _ = fs::remove_dir_all(&dir);
        let cache = Cache { dir: dir.clone() };
        let monitor = Monitor {
            display: 1,
            model: "Test Display".into(),
        };
        let brightness = Brightness {
            current: 80,
            max: 100,
        };
        cache.write(&monitor, brightness).unwrap();
        let loaded = cache.read().unwrap();
        assert_eq!(loaded.monitor.model, "Test Display");
        assert_eq!(loaded.brightness.percent(), 80);
        let _ = fs::remove_dir_all(dir);
    }
}
