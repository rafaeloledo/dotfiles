//! Waybar DDC/CI brightness control.

use std::io::IsTerminal;

use clap::{Parser, Subcommand};
use ddc_slider::ddc;
use ddc_slider::popup;
use ddc_slider::waybar;

fn main() {
    let cli = Cli::parse();
    let display = cli.display;
    let as_json = cli.output_json();
    let watch = cli.watch;
    let code = match cli.command.unwrap_or(Command::Waybar) {
        Command::Waybar => waybar::emit(display, as_json, watch),
        Command::Detect { json } => ddc::run_detect(json),
        Command::Popup => report(popup::run(display)),
        Command::Up { step } => report(waybar::adjust(display, step as i32)),
        Command::Down { step } => report(waybar::adjust(display, -(step as i32))),
        Command::Set { value } => report(waybar::set_percent(display, value)),
    };
    std::process::exit(code);
}

fn report(result: anyhow::Result<()>) -> i32 {
    match result {
        Ok(()) => 0,
        Err(err) => {
            eprintln!("ddc-slider: {err:#}");
            1
        }
    }
}

#[derive(Parser, Debug)]
#[command(
    name = "ddc-slider",
    about = "Waybar DDC/CI brightness control",
    long_about = "\
Waybar brightness widget.

Output modes (default / waybar subcommand):
  - Piped stdout → Waybar JSON ({text, tooltip, class}). Always exits 0.
  - TTY stdout → --pretty: same three-row panel as the popup, as text.
  - --json: force JSON even on a TTY.
  - --watch N: refresh the pretty view every N seconds.

Interactive control:
  - popup: GTK layer-shell overlay (Waybar click)."
)]
struct Cli {
    /// DDC display number (`ddcutil detect`). Env: `DDC_DISPLAY`.
    #[arg(long, env = "DDC_DISPLAY", default_value_t = 1)]
    display: u8,

    /// Human-readable terminal output (auto on TTY unless --json).
    #[arg(long)]
    pretty: bool,

    /// Force Waybar JSON even when stdout is a TTY.
    #[arg(long)]
    json: bool,

    /// Re-render every N seconds (TTY only; Ctrl-C to exit).
    #[arg(long, value_name = "SECS")]
    watch: Option<u64>,

    #[command(subcommand)]
    command: Option<Command>,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// Print output for a Waybar custom module (default).
    Waybar,
    /// Open or close the native brightness overlay.
    Popup,
    /// List DDC/CI displays (`ddcutil detect`).
    Detect {
        #[arg(long)]
        json: bool,
    },
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
    Set { value: u8 },
}

impl Cli {
    fn output_json(&self) -> bool {
        if self.json {
            return true;
        }
        if self.pretty || self.watch.is_some() {
            return false;
        }
        !std::io::stdout().is_terminal()
    }
}
