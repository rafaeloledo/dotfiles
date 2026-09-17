//! Debounced brightness slider wired to DDC writes and Waybar refresh.

use crate::ddc::{self, Brightness};
use crate::waybar;
use gtk4::glib::{ControlFlow, SourceId};
use gtk4::prelude::*;
use gtk4::{Label, Scale};
use std::cell::RefCell;
use std::rc::Rc;
use std::time::Duration;

const DEBOUNCE_MS: u64 = 180;

pub struct Slider {
    display: u8,
    max: Rc<RefCell<u16>>,
    debounce: Rc<RefCell<Option<SourceId>>>,
    suppress: Rc<RefCell<bool>>,
    pub user_edited: Rc<RefCell<bool>>,
}

impl Slider {
    pub fn new(display: u8) -> Rc<Self> {
        Rc::new(Self {
            display,
            max: Rc::new(RefCell::new(100)),
            debounce: Rc::new(RefCell::new(None)),
            suppress: Rc::new(RefCell::new(false)),
            user_edited: Rc::new(RefCell::new(false)),
        })
    }

    pub fn wire(self: &Rc<Self>, scale: &Scale, value_label: &Label) {
        let slider = self.clone();
        let value_label = value_label.clone();
        let scale = scale.clone();

        scale.connect_value_changed(move |scale| {
            if *slider.suppress.borrow() {
                return;
            }
            *slider.user_edited.borrow_mut() = true;

            let max = *slider.max.borrow();
            let value = scale.value().round() as u16;
            let percent = if max == 0 {
                0
            } else {
                ((value as u32 * 100) / max as u32).min(100) as u8
            };
            value_label.set_text(&format!("{percent}%"));

            if let Some(source) = slider.debounce.borrow_mut().take() {
                source.remove();
            }

            let display = slider.display;
            let scale = scale.clone();
            let debounce = slider.debounce.clone();
            *debounce.borrow_mut() = Some(gtk4::glib::timeout_add_local(
                Duration::from_millis(DEBOUNCE_MS),
                move || {
                    let value = scale.value().round() as u16;
                    if let Err(err) = ddc::set_brightness(display, value) {
                        eprintln!("ddc-slider: {err:#}");
                    } else {
                        waybar::refresh();
                    }
                    ControlFlow::Break
                },
            ));
        });
    }

    pub fn apply(self: &Rc<Self>, scale: &Scale, value_label: &Label, brightness: Brightness) {
        *self.max.borrow_mut() = brightness.max;
        *self.suppress.borrow_mut() = true;

        scale.set_adjustment(&adjustment_for(brightness));
        value_label.set_text(&format!("{}%", brightness.percent()));
        scale.set_sensitive(true);

        *self.suppress.borrow_mut() = false;
    }
}

pub fn adjustment_for(brightness: Brightness) -> gtk4::Adjustment {
    gtk4::Adjustment::builder()
        .lower(0.0)
        .upper(brightness.max as f64)
        .value(brightness.current as f64)
        .step_increment(1.0)
        .page_increment(5.0)
        .build()
}
