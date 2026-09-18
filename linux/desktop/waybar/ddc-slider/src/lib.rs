//! Shared core for the Waybar widget and GTK popup.

mod cache;
mod error;
mod panel;
mod theme;
mod util;

pub mod ddc;
pub mod popup;
pub mod waybar;

pub use error::{AppError, Result};
