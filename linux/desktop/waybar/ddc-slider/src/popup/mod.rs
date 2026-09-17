//! GTK brightness slider popup (toggle via Waybar click).

mod instance;
mod slider;
mod ui;

use crate::ddc;
use crate::util;
use anyhow::{Context, Result};
use gtk4::glib::{self, ControlFlow, MainLoop};
use gtk4::prelude::*;
use std::rc::Rc;

pub use instance::{close_existing, remove_pid, write_pid};

/// Open the popup, or close it when already running.
pub fn run(display: u8) -> Result<()> {
    if close_existing()? {
        return Ok(());
    }

    gtk4::init().context("initialize GTK")?;
    if !gtk4_layer_shell::is_supported() {
        anyhow::bail!("gtk-layer-shell is not supported on this compositor");
    }

    write_pid();

    let (window, widgets) = ui::build_window(display);
    let slider = slider::Slider::new(display);
    slider.wire(&widgets.scale, &widgets.value_label);

    let loop_ = MainLoop::new(None, false);
    let loop_stop = loop_.clone();
    window.connect_destroy(move |_| {
        remove_pid();
        loop_stop.quit();
    });

    glib::idle_add_local_once({
        let window = window.clone();
        move || {
            window.grab_focus();
        }
    });

    let had_cache = seed_from_cache(&slider, &widgets, display);
    window.present();

    if !had_cache {
        refresh_brightness(window.clone(), widgets.clone(), slider.clone(), display);
    }
    if ddc::cached_monitor_name(display).is_none() {
        refresh_monitor_name(window, widgets.title.clone(), display);
    }

    loop_.run();
    remove_pid();
    Ok(())
}

fn seed_from_cache(slider: &Rc<slider::Slider>, widgets: &Rc<ui::Widgets>, display: u8) -> bool {
    let Some(brightness) = ddc::cached_brightness(display) else {
        return false;
    };
    slider.apply(&widgets.scale, &widgets.value_label, brightness);
    true
}

fn refresh_brightness(
    window: gtk4::Window,
    widgets: Rc<ui::Widgets>,
    slider: Rc<slider::Slider>,
    display: u8,
) {
    util::poll_background(
        move || ddc::get_brightness(display),
        move |result| {
            if !window.is_visible() {
                return ControlFlow::Break;
            }
            match result {
                Ok(brightness) if !*slider.user_edited.borrow() => {
                    slider.apply(&widgets.scale, &widgets.value_label, brightness);
                }
                Ok(_) => {}
                Err(err) => {
                    eprintln!("ddc-slider popup: {err:#}");
                    if ddc::cached_brightness(display).is_none() {
                        widgets.value_label.set_text("n/a");
                    }
                }
            }
            ControlFlow::Break
        },
    );
}

fn refresh_monitor_name(window: gtk4::Window, title: gtk4::Label, display: u8) {
    util::poll_background(
        move || ddc::monitor_label(display),
        move |name| {
            if window.is_visible() {
                title.set_text(&name);
            }
            ControlFlow::Break
        },
    );
}
