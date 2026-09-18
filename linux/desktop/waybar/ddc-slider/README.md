# ddc-slider

Waybar brightness applet for external monitors over **DDC/CI** (`ddcutil`).

Hover shows a three-row tooltip; click opens a native GTK overlay with the same panel. On a TTY, `ddc-slider` prints that panel as text.

## Requirements

| Package | Purpose |
|---------|---------|
| `ddcutil` | DDC/CI over I2C |
| `gtk4-layer-shell` | Native overlay on Wayland |
| Monitor with DDC/CI enabled | Hardware / cable dependent |
| `i2c` group (typical on Arch) | Access to `/dev/i2c-*` |

```bash
ddcutil detect
ddcutil getvcp 10 --display 1
```

## Install

```bash
just ddc-slider-install
```

## CLI

```bash
ddc-slider waybar              # JSON for Waybar (default, always exits 0)
ddc-slider                     # TTY: same three-row panel as the popup
ddc-slider popup               # native overlay (Waybar click)
ddc-slider up / down / set 50
ddc-slider detect
```

## Waybar

```jsonc
"custom/brightness": {
    "exec": "ddc-slider waybar",
    "return-type": "json",
    "interval": "once",
    "signal": 10,
    "exec-on-event": false,
    "cursor": false,
    "format": "{text}",
    "on-click": "sh -c 'ddc-slider popup >/dev/null 2>&1 &'",
    "on-scroll-up": "ddc-slider up",
    "on-scroll-down": "ddc-slider down",
    "tooltip": true
}
```

| Action | Effect |
|--------|--------|
| Show | Icon + brightness % |
| Hover | Bordered tooltip |
| Click | Native overlay |
| Scroll | ±5 brightness |
