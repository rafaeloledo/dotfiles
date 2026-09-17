//! JSON cache of monitor names and brightness under `$XDG_RUNTIME_DIR`.

use super::{Brightness, Monitor};
use crate::util::runtime_file;
use std::collections::HashMap;
use std::fs;

const CACHE_FILE: &str = "ddc-slider-cache.json";

#[derive(Debug, Default, serde::Deserialize, serde::Serialize)]
struct Cache {
    monitors: Vec<Monitor>,
    brightness: HashMap<u8, Brightness>,
}

pub fn monitor_name(display: u8) -> Option<String> {
    load()
        .monitors
        .into_iter()
        .find(|m| m.display == display)
        .map(|m| m.model)
}

pub fn brightness(display: u8) -> Option<Brightness> {
    load().brightness.get(&display).copied()
}

pub fn store_monitors(monitors: &[Monitor]) {
    let mut cache = load();
    cache.monitors = monitors.to_vec();
    save(&cache);
}

pub fn store_brightness(display: u8, brightness: Brightness) {
    let mut cache = load();
    cache.brightness.insert(display, brightness);
    save(&cache);
}

fn load() -> Cache {
    fs::read_to_string(runtime_file(CACHE_FILE))
        .ok()
        .and_then(|json| serde_json::from_str(&json).ok())
        .unwrap_or_default()
}

fn save(cache: &Cache) {
    if let Ok(json) = serde_json::to_string(cache) {
        let _ = fs::write(runtime_file(CACHE_FILE), json);
    }
}
