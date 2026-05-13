import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { Variable, exec, execAsync } from "astal"

interface Sink   { name: string; desc: string; volume: number; muted: boolean; active: boolean }
interface Source { name: string; desc: string; volume: number; muted: boolean }
interface Stream { id: number; app: string; icon: string; volume: number; muted: boolean }

function tryExec(cmd: string): string {
    try { return exec(cmd) } catch { return "" }
}

function parsePct(s: string): number {
    return parseInt(s.match(/(\d+)%/)?.[1] ?? "0") / 100
}

function friendly(desc: string): string {
    return desc
        .replace(/ Analog Stereo$/i, "")
        .replace(/ Digital Stereo.*$/i, "")
        .replace(/ Mono$/i, "")
        .replace(/^Monitor of /i, "↩ ")
}

function parseSinks(): Sink[] {
    const out = tryExec("pactl list sinks")
    const def = tryExec("pactl get-default-sink").trim()
    return [...out.matchAll(/Sink #\d+([\s\S]*?)(?=Sink #\d|\s*$)/g)].flatMap(m => {
        const b = m[1]
        const name = b.match(/\tName: (.+)/)?.[1]?.trim() ?? ""
        if (!name) return []
        return [{
            name,
            desc:   friendly(b.match(/\tDescription: (.+)/)?.[1]?.trim() ?? name),
            muted:  b.match(/\tMute: (.+)/)?.[1]?.trim() === "yes",
            volume: parsePct(b.match(/\tVolume:.*?(\d+%)/)?.[1] ?? "0%"),
            active: name === def,
        }]
    })
}

function parseSources(): Source[] {
    const out = tryExec("pactl list sources")
    return [...out.matchAll(/Source #\d+([\s\S]*?)(?=Source #\d|\s*$)/g)].flatMap(m => {
        const b = m[1]
        const name = b.match(/\tName: (.+)/)?.[1]?.trim() ?? ""
        if (!name || name.includes(".monitor")) return []
        return [{
            name,
            desc:   friendly(b.match(/\tDescription: (.+)/)?.[1]?.trim() ?? name),
            muted:  b.match(/\tMute: (.+)/)?.[1]?.trim() === "yes",
            volume: parsePct(b.match(/\tVolume:.*?(\d+%)/)?.[1] ?? "0%"),
        }]
    })
}

function parseStreams(): Stream[] {
    const out = tryExec("pactl list sink-inputs")
    return [...out.matchAll(/Sink Input #(\d+)([\s\S]*?)(?=Sink Input #\d|\s*$)/g)].flatMap(m => {
        const b = m[2]
        const app = b.match(/application\.name = "([^"]+)"/)?.[1] ?? ""
        if (!app) return []
        return [{
            id:     parseInt(m[1]),
            app,
            icon:   b.match(/application\.icon_name = "([^"]+)"/)?.[1] ?? "audio-x-generic-symbolic",
            muted:  b.match(/\tMute: (.+)/)?.[1]?.trim() === "yes",
            volume: parsePct(b.match(/\tVolume:.*?(\d+%)/)?.[1] ?? "0%"),
        }]
    })
}

function volIcon(v: number, muted: boolean): string {
    if (muted || v === 0) return "audio-volume-muted-symbolic"
    if (v < 0.33)         return "audio-volume-low-symbolic"
    if (v < 0.66)         return "audio-volume-medium-symbolic"
    return "audio-volume-high-symbolic"
}

function Divider() {
    return <box cssClasses={["divider"]} />
}

function SectionLabel({ label }: { label: string }) {
    return <label
        cssClasses={["section-label"]}
        label={label}
        halign={Gtk.Align.START}
    />
}

function VolumeSlider({ volume, onSet }: {
    volume: number
    onSet: (v: number) => void
}) {
    return <box spacing={8} cssClasses={["slider-row"]}>
        <slider
            hexpand
            min={0} max={1}
            cssClasses={["vol-slider"]}
            value={volume}
            onChangeValue={(_s, _t, value) => {
                onSet(Math.max(0, Math.min(1, value)))
                return false
            }}
        />
        <label cssClasses={["vol-pct"]} label={`${Math.round(volume * 100)}%`} />
    </box>
}

export default function VolumePopup() {
    const { TOP, RIGHT } = Astal.WindowAnchor

    const sinks   = Variable(parseSinks()).poll(1000, parseSinks)
    const sources = Variable(parseSources()).poll(1000, parseSources)
    const streams = Variable(parseStreams()).poll(2000, parseStreams)

    return <window
        name="volume-popup"
        application={App}
        visible={false}
        layer={Astal.Layer.OVERLAY}
        anchor={TOP | RIGHT}
        margin_top={42}
        margin_right={6}
        keymode={Astal.Keymode.ON_DEMAND}
        cssClasses={["volume-window"]}
        onKeyPressed={(_, keyval) => {
            if (keyval === Gdk.KEY_Escape)
                App.toggle_window("volume-popup")
        }}
    >
        <box vertical cssClasses={["volume-box"]}>

            {/* ── header ── */}
            <label cssClasses={["header-label"]} label="AUDIO SYS" halign={Gtk.Align.START} />

            <Divider />

            {/* ── output ── */}
            <SectionLabel label="OUTPUT" />

            {sinks(list => <box vertical cssClasses={["section-body"]}>
                {list.map(sink => <box vertical spacing={4}>
                    <box spacing={6} cssClasses={["device-row"]}>
                        <button
                            hexpand
                            cssClasses={sink.active ? ["device-select", "active"] : ["device-select"]}
                            onClicked={() =>
                                execAsync(`pactl set-default-sink ${sink.name}`)
                                    .then(() => sinks.set(parseSinks()))
                            }
                        >
                            <box spacing={8}>
                                <label cssClasses={["dot"]} label={sink.active ? "◉" : "○"} />
                                <label
                                    cssClasses={["device-name"]}
                                    label={sink.desc}
                                    halign={Gtk.Align.START}
                                    ellipsize={3}
                                    maxWidthChars={24}
                                />
                            </box>
                        </button>
                        <button
                            cssClasses={sink.muted ? ["mute-btn", "muted"] : ["mute-btn"]}
                            onClicked={() =>
                                execAsync(`pactl set-sink-mute ${sink.name} toggle`)
                                    .then(() => sinks.set(parseSinks()))
                            }
                        >
                            <image iconName={volIcon(sink.volume, sink.muted)} iconSize={Gtk.IconSize.NORMAL} />
                        </button>
                    </box>
                    {sink.active && <VolumeSlider
                        volume={sink.volume}
                        onSet={v => execAsync(`pactl set-sink-volume ${sink.name} ${Math.round(v * 100)}%`)
                            .then(() => sinks.set(parseSinks()))}
                    />}
                </box>)}
            </box>)}

            <Divider />

            {/* ── input ── */}
            <SectionLabel label="INPUT" />

            {sources(list => <box vertical cssClasses={["section-body"]}>
                {list.map(src => <box vertical spacing={4}>
                    <box spacing={6} cssClasses={["device-row"]}>
                        <image
                            cssClasses={["device-icon"]}
                            iconName={src.muted ? "microphone-sensitivity-muted-symbolic" : "audio-input-microphone-symbolic"}
                            iconSize={Gtk.IconSize.NORMAL}
                        />
                        <label
                            cssClasses={["device-name"]}
                            label={src.desc}
                            hexpand
                            halign={Gtk.Align.START}
                            ellipsize={3}
                            maxWidthChars={24}
                        />
                        <button
                            cssClasses={src.muted ? ["mute-btn", "muted"] : ["mute-btn"]}
                            onClicked={() =>
                                execAsync(`pactl set-source-mute ${src.name} toggle`)
                                    .then(() => sources.set(parseSources()))
                            }
                        >
                            <image
                                iconName={src.muted ? "microphone-sensitivity-muted-symbolic" : "microphone-sensitivity-high-symbolic"}
                                iconSize={Gtk.IconSize.NORMAL}
                            />
                        </button>
                    </box>
                    <VolumeSlider
                        volume={src.volume}
                        onSet={v => execAsync(`pactl set-source-volume ${src.name} ${Math.round(v * 100)}%`)
                            .then(() => sources.set(parseSources()))}
                    />
                </box>)}
            </box>)}

            {/* ── streams (conditional) ── */}
            {streams(list => list.length === 0 ? <box /> : <box vertical>
                <Divider />
                <SectionLabel label="STREAMS" />
                <box vertical cssClasses={["section-body"]}>
                    {list.map(s => <box vertical spacing={4}>
                        <box spacing={6} cssClasses={["device-row"]}>
                            <image
                                cssClasses={["app-icon"]}
                                iconName={s.icon}
                                iconSize={Gtk.IconSize.NORMAL}
                            />
                            <label
                                cssClasses={["device-name"]}
                                label={s.app}
                                hexpand
                                halign={Gtk.Align.START}
                            />
                            <button
                                cssClasses={s.muted ? ["mute-btn", "muted"] : ["mute-btn"]}
                                onClicked={() =>
                                    execAsync(`pactl set-sink-input-mute ${s.id} toggle`)
                                        .then(() => streams.set(parseStreams()))
                                }
                            >
                                <image
                                    iconName={s.muted ? "audio-volume-muted-symbolic" : "audio-volume-medium-symbolic"}
                                    iconSize={Gtk.IconSize.NORMAL}
                                />
                            </button>
                        </box>
                        <VolumeSlider
                            volume={s.volume}
                            onSet={v => execAsync(`pactl set-sink-input-volume ${s.id} ${Math.round(v * 100)}%`)
                                .then(() => streams.set(parseStreams()))}
                        />
                    </box>)}
                </box>
            </box>)}

        </box>
    </window>
}
