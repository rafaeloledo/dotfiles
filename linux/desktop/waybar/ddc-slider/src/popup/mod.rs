//! GTK brightness slider popup (toggle via Waybar click). Native overlay, not a terminal.

mod slider;

use crate::ddc::{self, Brightness, Monitor};
use crate::panel::{Panel, PanelInput, PANEL_HEIGHT_PX, PANEL_INNER_WIDTH, PANEL_WIDTH_PX};
use crate::theme::Theme;
use crate::util;
use anyhow::{Context, Result};
use gtk4::glib::{self, ControlFlow, MainLoop};
use gtk4::prelude::*;
use gtk4::{Box as GtkBox, Label, Orientation, Window};
use gtk4_layer_shell::{Edge, KeyboardMode, Layer, LayerShell};
use std::cell::{Cell, RefCell};
use std::fs;
use std::process::Command;
use std::rc::Rc;
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

const PID_FILE: &str = "ddc-slider.pid";

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

    let (window, widgets) = build_window(display);
    let slider = slider::Slider::new(display);
    slider.wire(&window, &widgets);

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

    let had_cache = widgets.brightness.borrow().is_some();
    window.present();

    if !had_cache {
        refresh_brightness(window.clone(), widgets.clone(), slider.clone(), display);
    }
    if ddc::cached_monitor(display).is_none() {
        refresh_monitor_name(window, widgets, display);
    }

    loop_.run();
    remove_pid();
    Ok(())
}

pub(crate) struct Widgets {
    header: Label,
    slider_label: Label,
    footer: Label,
    monitor: RefCell<Monitor>,
    brightness: RefCell<Option<Brightness>>,
    stale: Cell<bool>,
    error: RefCell<Option<String>>,
}

impl Widgets {
    fn paint(&self) {
        let monitor = self.monitor.borrow();
        let brightness = *self.brightness.borrow();
        let error = self.error.borrow();
        let panel = Panel::build(PanelInput {
            monitor: &monitor,
            brightness,
            stale: self.stale.get(),
            error: error.as_deref(),
        });
        let lines = panel.lines(PANEL_INNER_WIDTH);
        let theme = Theme::default();
        self.header.set_markup(&lines.header_pango(&theme));
        self.slider_label.set_markup(&lines.slider_pango(&theme));
        self.footer.set_markup(&lines.footer_pango(&theme));
        self.slider_label.set_sensitive(panel.slider.available);
    }

    pub(crate) fn set_brightness(&self, brightness: Brightness, stale: bool) {
        *self.brightness.borrow_mut() = Some(brightness);
        self.stale.set(stale);
        *self.error.borrow_mut() = None;
        self.paint();
    }
}

fn build_window(display: u8) -> (Window, Rc<Widgets>) {
    let theme = Theme::default();
    let (monitor, brightness) = ddc::cached_state(display);

    let window = Window::builder()
        .title("Brightness")
        .default_width(PANEL_WIDTH_PX)
        .default_height(PANEL_HEIGHT_PX)
        .decorated(false)
        .resizable(false)
        .build();

    window.init_layer_shell();
    window.set_namespace(Some("ddc-slider"));
    window.set_layer(Layer::Top);
    window.set_anchor(Edge::Top, true);
    window.set_anchor(Edge::Right, true);
    window.set_margin(Edge::Top, 38);
    window.set_margin(Edge::Right, 16);
    window.set_keyboard_mode(KeyboardMode::OnDemand);
    window.set_exclusive_zone(0);
    apply_css(&window, &theme);

    let header = row_label("header");
    let slider_label = row_label("slider");
    let footer = row_label("hint");

    let root = GtkBox::builder()
        .orientation(Orientation::Vertical)
        .spacing(0)
        .margin_top(10)
        .margin_bottom(10)
        .margin_start(12)
        .margin_end(12)
        .build();
    root.append(&header);
    root.append(&slider_label);
    root.append(&footer);
    window.set_child(Some(&root));

    let widgets = Rc::new(Widgets {
        header,
        slider_label,
        footer,
        monitor: RefCell::new(monitor),
        brightness: RefCell::new(brightness),
        stale: Cell::new(brightness.is_some()),
        error: RefCell::new(None),
    });
    widgets.paint();
    bind_escape(&window);

    (window, widgets)
}

fn row_label(class: &str) -> Label {
    let label = Label::builder()
        .halign(gtk4::Align::Start)
        .xalign(0.0)
        .hexpand(true)
        .use_markup(true)
        .single_line_mode(class != "hint")
        .width_chars(PANEL_INNER_WIDTH as i32)
        .max_width_chars(PANEL_INNER_WIDTH as i32)
        .build();
    label.add_css_class(class);
    label
}

fn apply_css(window: &Window, theme: &Theme) {
    let provider = gtk4::CssProvider::new();
    provider.load_from_data(&theme.popup_css());
    gtk4::style_context_add_provider_for_display(
        &gtk4::prelude::RootExt::display(window),
        &provider,
        gtk4::STYLE_PROVIDER_PRIORITY_APPLICATION,
    );
}

fn bind_escape(window: &Window) {
    let controller = gtk4::EventControllerKey::new();
    let target = window.clone();
    controller.connect_key_pressed(move |_, key, _, _| {
        if key == gtk4::gdk::Key::Escape {
            target.close();
            gtk4::glib::Propagation::Stop
        } else {
            gtk4::glib::Propagation::Proceed
        }
    });
    window.add_controller(controller);
}

fn refresh_brightness(
    window: gtk4::Window,
    widgets: Rc<Widgets>,
    slider: Rc<slider::Slider>,
    display: u8,
) {
    poll_background(
        move || ddc::get_brightness(display).map_err(|e| e.to_string()),
        move |result| {
            if !window.is_visible() {
                return ControlFlow::Break;
            }
            match result {
                Ok(brightness) if !slider.user_has_edited() => {
                    widgets.set_brightness(brightness, false);
                }
                Ok(_) => {}
                Err(err) => {
                    eprintln!("ddc-slider popup: {err}");
                    if ddc::cached_brightness(display).is_none() {
                        *widgets.error.borrow_mut() = Some(err);
                        widgets.paint();
                    }
                }
            }
            ControlFlow::Break
        },
    );
}

fn refresh_monitor_name(window: gtk4::Window, widgets: Rc<Widgets>, display: u8) {
    poll_background(
        move || ddc::monitor_label(display),
        move |name| {
            if window.is_visible() {
                widgets.monitor.borrow_mut().model = name;
                widgets.paint();
            }
            ControlFlow::Break
        },
    );
}

fn poll_background<T, F, H>(work: F, mut on_result: H)
where
    T: Send + 'static,
    F: FnOnce() -> T + Send + 'static,
    H: FnMut(T) -> ControlFlow + 'static,
{
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        let _ = tx.send(work());
    });

    gtk4::glib::timeout_add_local(Duration::from_millis(40), move || match rx.try_recv() {
        Ok(value) => on_result(value),
        Err(mpsc::TryRecvError::Empty) => ControlFlow::Continue,
        Err(mpsc::TryRecvError::Disconnected) => ControlFlow::Break,
    });
}

fn close_existing() -> Result<bool> {
    let path = util::runtime_file(PID_FILE);
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

fn write_pid() {
    let _ = fs::write(util::runtime_file(PID_FILE), std::process::id().to_string());
}

fn remove_pid() {
    let _ = fs::remove_file(util::runtime_file(PID_FILE));
}
