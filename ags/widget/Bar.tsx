import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable, execAsync, exec } from "astal"

// Clock variável que atualiza a cada segundo
const time = Variable("").poll(1000, () => {
    const now = new Date()
    const hours = now.getHours().toString().padStart(2, "0")
    const minutes = now.getMinutes().toString().padStart(2, "0")
    const seconds = now.getSeconds().toString().padStart(2, "0")
    const day = now.getDate().toString().padStart(2, "0")
    const month = (now.getMonth() + 1).toString().padStart(2, "0")
    const year = now.getFullYear().toString().slice(-2)
    
    return `${hours}:${minutes}:${seconds} - ${day}/${month}/${year}`
})

// Volume variável
const volume = Variable(0).poll(1000, () => {
    try {
        const output = exec("pamixer --get-volume")
        return parseInt(output.trim())
    } catch {
        return 0
    }
})

const isMuted = Variable(false).poll(1000, () => {
    try {
        const output = exec("pamixer --get-mute")
        return output.trim() === "true"
    } catch {
        return false
    }
})

// Função para obter ícone do volume baseado no nível
function getVolumeIcon(vol) {
    if (isMuted()) return "󰝟"
    if (vol > 66) return "󰕾"
    if (vol > 33) return "󰖀"
    return "󰕿"
}

// Workspaces como componente desacoplado
function Workspaces() {
    const workspaces = Array.from({ length: 9 }, (_, i) => i + 1)
    
    // Poll ativo para verificar a workspace ativa
    const activeWs = Variable(1).poll(500, () => {
        try {
            return exec("hyprctl activewindow -j | jq '.workspace.id'").trim()
        } catch {
            return "1"
        }
    })
    
    return <box className="workspaces">
        {workspaces.map(id => (
            <button 
                className={`workspace-button ${activeWs() == id ? "active" : ""}`}
                onClicked={() => execAsync(`hyprctl dispatch workspace ${id}`)}
            >
                {id}
            </button>
        ))}
    </box>
}

// Componente de Volume com ícones
function Volume() {
    return <button 
        className="audio"
        onClicked="killall .pavucontrol-wrapped || pavucontrol"
        onScrollUp={() => execAsync("sh ~/.local/scripts/volume up")}
        onScrollDown={() => execAsync("sh ~/.local/scripts/volume down")}
        onSecondaryClick={() => execAsync("sh ~/.local/scripts/volume mute")}
    >
        <label label={`${getVolumeIcon(volume())} ${isMuted() ? "Muted" : volume() + "%"} `} />
    </button>
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <centerbox>
            <Workspaces />
            
            <box>
                <button className="clock">
                    <label label={time()} />
                </button>
            </box>
            
            <box>
                <Volume />
            </box>
        </centerbox>
    </window>
}
