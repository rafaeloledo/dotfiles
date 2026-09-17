# ddc-slider

Waybar brightness applet for external monitors over **DDC/CI** (`ddcutil`), with a GTK layer-shell slider popup.

## Requirements

| Package | Purpose |
|---------|---------|
| `ddcutil` | DDC/CI over I2C |
| `gtk4-layer-shell` | Popup overlay on Wayland |
| Monitor with DDC/CI enabled | Hardware / cable dependent |
| `i2c` group (typical on Arch) | Access to `/dev/i2c-*` |

Verify DDC works:

```bash
ddcutil detect
ddcutil getvcp 10 --display 1
```

## Install

From the dotfiles root:

```bash
just ddc-slider-install
```

Or locally:

```bash
cargo install --path linux/desktop/waybar/ddc-slider --force
```

## CLI

```bash
ddc-slider waybar              # JSON for Waybar (default)
ddc-slider popup               # toggle slider popup
ddc-slider up [--step 5]       # brighter
ddc-slider down [--step 5]     # dimmer
ddc-slider set 50              # absolute %
ddc-slider --display 2 up      # target another display
```

Display selection: `--display N` or `DDC_DISPLAY=N` (default `1`).

## Waybar

Add to `modules-right` and configure:

```jsonc
"custom/brightness": {
    "exec": "ddc-slider waybar",
    "return-type": "json",
    "interval": "once",
    "signal": 10,
    "exec-on-event": false,
    "cursor": true,
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
| Click | Toggle slider popup |
| Scroll | ±5% brightness |

Reload Waybar after config changes.

## Layout

```
src/
├── main.rs           CLI entry
├── util.rs           runtime paths, background polling
├── ddc/
│   ├── mod.rs        ddcutil client, lock, retry
│   └── cache.rs      $XDG_RUNTIME_DIR/ddc-slider-cache.json
├── waybar.rs         JSON module output + pkill refresh
└── popup/
    ├── mod.rs        popup lifecycle
    ├── ui.rs         GTK window + CSS
    ├── slider.rs     debounced scale → DDC write
    └── instance.rs   single-instance PID toggle
```

Runtime files (under `$XDG_RUNTIME_DIR`):

- `ddc-slider-cache.json` — last known monitor names and brightness
- `ddc-slider.pid` — open popup instance
- `ddc-slider-ddc.lock` — serializes concurrent `ddcutil` calls

## Behavior notes

- The popup shows immediately using cached values; live DDC reads run in the background.
- After you move the slider, stale background reads are ignored so the UI does not snap back.
- Brightness changes refresh Waybar via `pkill -RTMIN+10 waybar` (signal `10` in config).
