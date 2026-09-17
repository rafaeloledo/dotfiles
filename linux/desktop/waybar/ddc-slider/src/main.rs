//! Waybar DDC/CI brightness control CLI.
//!
//! Subcommands integrate with a Waybar custom module and an optional GTK popup.

mod ddc;
mod popup;
mod util;
mod waybar;

use anyhow::Result;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "ddc-slider", about = "Waybar DDC/CI brightness control")]
struct Cli {
    /// DDC display number (`ddcutil detect`). Env: `DDC_DISPLAY`.
    #[arg(long, env = "DDC_DISPLAY", default_value_t = 1)]
    display: u8,

    #[command(subcommand)]
    command: Option<Command>,
}

#[derive(Subcommand)]
enum Command {
    /// Print JSON for a Waybar custom module (default).
    Waybar,
    /// Open or close the brightness slider popup.
    Popup,
    /// Increase brightness by step (default 5).
    Up {
        #[arg(long, default_value_t = 5)]
        step: u32,
    },
    /// Decrease brightness by step (default 5).
    Down {
        #[arg(long, default_value_t = 5)]
        step: u32,
    },
    /// Set brightness to an absolute percentage (0–100).
    Set {
        value: u8,
    },
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.command.unwrap_or(Command::Waybar) {
        Command::Waybar => waybar::print_status(cli.display),
        Command::Popup => popup::run(cli.display),
        Command::Up { step } => change_brightness(cli.display, step as i32),
        Command::Down { step } => change_brightness(cli.display, -(step as i32)),
        Command::Set { value } => set_percent(cli.display, value),
    }
}

fn change_brightness(display: u8, delta: i32) -> Result<()> {
    ddc::adjust_brightness(display, delta)?;
    waybar::refresh();
    Ok(())
}

fn set_percent(display: u8, percent: u8) -> Result<()> {
    let brightness = ddc::get_brightness(display)?;
    let target = ((percent as u32 * brightness.max as u32) / 100).min(brightness.max as u32) as u16;
    ddc::set_brightness(display, target)?;
    waybar::refresh();
    Ok(())
}
