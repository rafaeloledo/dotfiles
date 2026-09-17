//! GTK layer-shell popup layout and styling.

use crate::ddc::{self, Brightness};
use crate::popup::slider::adjustment_for;
use gtk4::prelude::*;
use gtk4::{Box as GtkBox, Label, Orientation, Scale, Window};
use gtk4_layer_shell::{Edge, KeyboardMode, Layer, LayerShell};
use std::rc::Rc;

const POPUP_CSS: &str = r#"
window {
    background-color: #13131a;
    border: 1px solid #1d1d26;
    border-radius: 0;
}
label.title {
    color: #dcdce8;
    font-family: "JetBrains Mono Nerd Font", "JetBrains Mono", monospace;
    font-size: 13px;
    font-weight: 700;
}
label.value {
    color: #4fc8c8;
    font-family: "JetBrains Mono Nerd Font", "JetBrains Mono", monospace;
    font-size: 13px;
    font-weight: 700;
}
scale.brightness-scale {
    color: #dcdce8;
    min-height: 24px;
}
scale.brightness-scale trough {
    background-color: #1d1d26;
    min-height: 6px;
    border-radius: 0;
}
scale.brightness-scale highlight {
    background-color: #4fc8c8;
    border-radius: 0;
}
scale.brightness-scale slider {
    background-color: #c8a86a;
    border: 1px solid #c8a86a;
    border-radius: 0;
    min-width: 14px;
    min-height: 14px;
}
"#;

pub struct Widgets {
    pub title: Label,
    pub value_label: Label,
    pub scale: Scale,
}

pub fn build_window(display: u8) -> (Window, Rc<Widgets>) {
    let cached = ddc::cached_brightness(display);
    let window = Window::builder()
        .title("Brightness")
        .default_width(320)
        .default_height(96)
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
    apply_css(&window);

    let title = label(
        "title",
        &ddc::cached_monitor_name(display).unwrap_or_else(|| format!("Display {display}")),
        gtk4::Align::Start,
    );
    let value_label = label(
        "value",
        &percent_label(cached),
        gtk4::Align::End,
    );

    let header = GtkBox::builder()
        .orientation(Orientation::Horizontal)
        .spacing(8)
        .build();
    header.append(&title);
    header.append(&value_label);

    let adjustment = cached
        .map(adjustment_for)
        .unwrap_or_else(default_adjustment);

    let scale = Scale::builder()
        .orientation(Orientation::Horizontal)
        .adjustment(&adjustment)
        .draw_value(false)
        .hexpand(true)
        .sensitive(cached.is_some())
        .build();
    scale.add_css_class("brightness-scale");

    let root = GtkBox::builder()
        .orientation(Orientation::Vertical)
        .spacing(10)
        .margin_top(14)
        .margin_bottom(14)
        .margin_start(16)
        .margin_end(16)
        .build();
    root.append(&header);
    root.append(&scale);
    window.set_child(Some(&root));

    bind_escape(&window);

    (
        window,
        Rc::new(Widgets {
            title,
            value_label,
            scale,
        }),
    )
}

fn label(class: &str, text: &str, halign: gtk4::Align) -> Label {
    let label = Label::builder().label(text).halign(halign).build();
    label.add_css_class(class);
    label
}

fn percent_label(brightness: Option<Brightness>) -> String {
    brightness
        .map(|b| format!("{}%", b.percent()))
        .unwrap_or_else(|| "--%".into())
}

fn default_adjustment() -> gtk4::Adjustment {
    gtk4::Adjustment::builder()
        .lower(0.0)
        .upper(100.0)
        .value(0.0)
        .step_increment(1.0)
        .page_increment(5.0)
        .build()
}

fn apply_css(window: &Window) {
    let provider = gtk4::CssProvider::new();
    provider.load_from_data(POPUP_CSS);
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
