//! Debounced brightness control for the shared character slider.

use crate::ddc::{self, Brightness};
use crate::panel::SCROLL_STEP;
use crate::popup::Widgets;
use crate::waybar;
use gtk4::glib::{ControlFlow, SourceId};
use gtk4::prelude::*;
use gtk4::{EventControllerScroll, EventControllerScrollFlags, GestureDrag};
use std::cell::RefCell;
use std::rc::Rc;
use std::time::Duration;

const DEBOUNCE_MS: u64 = 180;

pub struct Slider {
    display: u8,
    debounce: Rc<RefCell<Option<SourceId>>>,
    user_edited: Rc<RefCell<bool>>,
}

impl Slider {
    pub fn new(display: u8) -> Rc<Self> {
        Rc::new(Self {
            display,
            debounce: Rc::new(RefCell::new(None)),
            user_edited: Rc::new(RefCell::new(false)),
        })
    }

    pub fn user_has_edited(&self) -> bool {
        *self.user_edited.borrow()
    }

    pub fn wire(self: &Rc<Self>, window: &gtk4::Window, widgets: &Rc<Widgets>) {
        self.wire_drag(widgets);
        self.wire_scroll(window, widgets);
        self.wire_keys(window, widgets);
    }

    fn wire_drag(self: &Rc<Self>, widgets: &Rc<Widgets>) {
        let drag = GestureDrag::new();
        drag.set_button(1);

        let slider = self.clone();
        let widgets_begin = widgets.clone();
        drag.connect_drag_begin(move |_, x, _| {
            slider.set_from_x(&widgets_begin, x);
        });

        let slider = self.clone();
        let widgets_update = widgets.clone();
        drag.connect_drag_update(move |gesture, dx, _| {
            let Some((start_x, _)) = gesture.start_point() else {
                return;
            };
            slider.set_from_x(&widgets_update, start_x + dx);
        });

        widgets.slider_label.add_controller(drag);
    }

    fn wire_scroll(self: &Rc<Self>, window: &gtk4::Window, widgets: &Rc<Widgets>) {
        let scroll = EventControllerScroll::new(
            EventControllerScrollFlags::VERTICAL | EventControllerScrollFlags::DISCRETE,
        );
        let slider = self.clone();
        let widgets = widgets.clone();
        scroll.connect_scroll(move |_, _, dy| {
            if dy == 0.0 {
                return gtk4::glib::Propagation::Proceed;
            }
            let delta = if dy < 0.0 { SCROLL_STEP } else { -SCROLL_STEP };
            slider.nudge(&widgets, delta);
            gtk4::glib::Propagation::Stop
        });
        window.add_controller(scroll);
    }

    fn wire_keys(self: &Rc<Self>, window: &gtk4::Window, widgets: &Rc<Widgets>) {
        let controller = gtk4::EventControllerKey::new();
        let slider = self.clone();
        let widgets = widgets.clone();
        controller.connect_key_pressed(move |_, key, _, _| {
            if key == gtk4::gdk::Key::Left || key == gtk4::gdk::Key::Down {
                slider.nudge(&widgets, -SCROLL_STEP);
                gtk4::glib::Propagation::Stop
            } else if key == gtk4::gdk::Key::Right || key == gtk4::gdk::Key::Up {
                slider.nudge(&widgets, SCROLL_STEP);
                gtk4::glib::Propagation::Stop
            } else {
                gtk4::glib::Propagation::Proceed
            }
        });
        window.add_controller(controller);
    }

    fn set_from_x(&self, widgets: &Widgets, x: f64) {
        let Some(current) = *widgets.brightness.borrow() else {
            return;
        };
        let width = widgets.slider_label.width().max(1) as f64;
        let fraction = (x / width).clamp(0.0, 1.0);
        let value = (fraction * current.max as f64).round() as u16;
        self.commit(
            widgets,
            Brightness {
                current: value.min(current.max),
                max: current.max,
            },
        );
    }

    fn nudge(&self, widgets: &Widgets, delta: i32) {
        let Some(current) = *widgets.brightness.borrow() else {
            return;
        };
        let next = (current.current as i32 + delta).clamp(0, current.max as i32) as u16;
        self.commit(
            widgets,
            Brightness {
                current: next,
                max: current.max,
            },
        );
    }

    fn commit(&self, widgets: &Widgets, brightness: Brightness) {
        *self.user_edited.borrow_mut() = true;
        widgets.set_brightness(brightness, false);
        self.schedule_write(brightness.current);
    }

    fn schedule_write(&self, value: u16) {
        if let Some(source) = self.debounce.borrow_mut().take() {
            source.remove();
        }
        let display = self.display;
        let debounce = self.debounce.clone();
        *debounce.borrow_mut() = Some(gtk4::glib::timeout_add_local(
            Duration::from_millis(DEBOUNCE_MS),
            move || {
                if let Err(err) = ddc::set_brightness(display, value) {
                    eprintln!("ddc-slider: {err}");
                } else {
                    waybar::request_refresh();
                }
                ControlFlow::Break
            },
        ));
    }
}
