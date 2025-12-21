import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {
  id: root

  property string timeText: Qt.formatDateTime(new Date(), "ddd dd MMM  HH:mm:ss")
  property string activeTitle: "Hyprland"
  property int currentWorkspace: 1
  property var workspaces: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  property var audioSink: Pipewire.defaultAudioSink
  property bool audioReady: !!(audioSink && audioSink.ready && audioSink.audio)
  property bool fallbackAudioReady: false
  property real fallbackAudioVolume: 0
  property bool fallbackAudioMuted: false
  property bool micReady: false
  property bool micMuted: false
  property string mediaTitle: "No media"
  property string mediaArtist: ""
  property string mediaStatus: ""
  property bool hasAudio: audioReady || fallbackAudioReady
  property real audioVolume: audioReady ? audioSink.audio.volume : fallbackAudioVolume
  property bool audioMuted: audioReady ? audioSink.audio.muted : fallbackAudioMuted
  property string audioName: audioReady ? (audioSink.description || audioSink.nickname || audioSink.name || "Audio") : (fallbackAudioReady ? "Audio" : "Audio indisponivel")
  property string volumeText: hasAudio ? Math.round(audioVolume * 100) + "%" : "--"

  function setAudioVolume(volume) {
    volume = Math.max(0, Math.min(1, volume))

    if (!audioReady) {
      if (fallbackAudioReady) {
        fallbackAudioMuted = false
        fallbackAudioVolume = volume
        root.run(["pamixer", "--set-volume", String(Math.round(volume * 100)), "--unmute"])
      }
      return
    }

    audioSink.audio.muted = false
    audioSink.audio.volume = volume
  }

  function changeAudioVolume(delta) {
    setAudioVolume(audioVolume + delta)
  }

  function toggleAudioMute() {
    if (!audioReady) {
      if (fallbackAudioReady) {
        fallbackAudioMuted = !fallbackAudioMuted
        root.run(["pamixer", "--toggle-mute"])
      }
      return
    }

    audioSink.audio.muted = !audioSink.audio.muted
  }

  function setAudioPreset(percent) {
    setAudioVolume(percent / 100)
  }

  function audioIcon() {
    if (!hasAudio) return "󰝟"
    if (audioMuted || audioVolume <= 0.01) return "󰖁"
    if (audioVolume < 0.35) return "󰕿"
    if (audioVolume < 0.7) return "󰖀"
    return "󰕾"
  }

  PwObjectTracker {
    objects: [root.audioSink, Pipewire.defaultAudioSource]
  }

  function run(command) {
    if (runner.running)
      runner.running = false

    runner.command = command
    runner.running = true
  }

  function refreshFallbackAudio() {
    if (!audioReady && !fallbackAudio.running)
      fallbackAudio.running = true
  }

  function refreshMediaInfo() {
    if (!mediaInfo.running)
      mediaInfo.running = true
  }

  function refreshWorkspaces() {
    if (!workspaceInfo.running)
      workspaceInfo.running = true
  }

  function setWorkspace(workspace) {
    root.currentWorkspace = workspace
    root.run(["hyprctl", "dispatch", "workspace", String(workspace)])
    workspaceRefreshDelay.restart()
  }

  Process {
    id: runner
  }

  Process {
    id: activeWindow
    command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // \"Hyprland\"'"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.activeTitle = this.text.trim() || "Hyprland"
    }
  }

  Process {
    id: fallbackAudio
    command: ["sh", "-c", "command -v pamixer >/dev/null 2>&1 && printf '%s %s %s\\n' \"$(pamixer --get-mute)\" \"$(pamixer --get-volume)\" \"$(pamixer --default-source --get-mute 2>/dev/null || echo unknown)\""]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split(/\s+/)
        const volume = Number(parts[1])
        root.fallbackAudioReady = parts.length >= 2 && !isNaN(volume)
        root.fallbackAudioMuted = root.fallbackAudioReady && parts[0] === "true"
        root.fallbackAudioVolume = root.fallbackAudioReady ? Math.max(0, Math.min(1, volume / 100)) : 0
        root.micReady = parts.length >= 3 && parts[2] !== "unknown"
        root.micMuted = root.micReady && parts[2] === "true"
      }
    }
  }

  Process {
    id: mediaInfo
    command: ["sh", "-c", "command -v playerctl >/dev/null 2>&1 && playerctl metadata --format '{{status}}|{{artist}}|{{title}}' 2>/dev/null"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split("|")
        root.mediaStatus = parts[0] || ""
        root.mediaArtist = parts[1] || ""
        root.mediaTitle = parts[2] || "No media"
      }
    }
  }

  Process {
    id: workspaceInfo
    command: ["sh", "-c", "printf '%s|' \"$(hyprctl activeworkspace -j | jq -r '.id // 1')\"; hyprctl workspaces -j | jq -r '[.[].id] | sort | unique | @csv'"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split("|")
        const active = Number(parts[0])
        const parsedWorkspaces = parts.length > 1 && parts[1].length > 0
          ? parts[1].split(",").map(value => Number(value)).filter(value => !isNaN(value) && value > 0)
          : []
        const visibleWorkspaces = root.workspaces.slice()

        for (const workspace of parsedWorkspaces) {
          if (!visibleWorkspaces.includes(workspace))
            visibleWorkspaces.push(workspace)
        }

        if (!isNaN(active) && active > 0)
          root.currentWorkspace = active

        if (!visibleWorkspaces.includes(root.currentWorkspace))
          visibleWorkspaces.push(root.currentWorkspace)

        visibleWorkspaces.sort((left, right) => left - right)
        root.workspaces = visibleWorkspaces
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.timeText = Qt.formatDateTime(new Date(), "ddd dd MMM  HH:mm:ss")
  }

  Timer {
    interval: 1500
    running: true
    repeat: true
    onTriggered: activeWindow.running = true
  }

  Timer {
    interval: 250
    running: true
    repeat: true
    onTriggered: root.refreshWorkspaces()
  }

  Timer {
    id: workspaceRefreshDelay
    interval: 150
    repeat: false
    onTriggered: root.refreshWorkspaces()
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: root.refreshFallbackAudio()
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: {
      if (audioPopup.visible)
        root.refreshMediaInfo()
    }
  }

  PanelWindow {
    id: barWindow

    anchors {
      top: true
      left: true
      right: true
    }

    implicitHeight: 42
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      color: "#101419"

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        Row {
          Layout.alignment: Qt.AlignVCenter
          spacing: 6

          Repeater {
            model: root.workspaces

            Rectangle {
              property bool active: modelData === root.currentWorkspace

              width: 28
              height: 24
              radius: 6
              color: active ? "#a8c7fa" : (workspaceMouse.containsMouse ? "#27313c" : "#1d252e")
              border.color: active ? "#dce3ea" : "transparent"
              border.width: active ? 1 : 0

              Text {
                anchors.centerIn: parent
                text: String(modelData)
                color: parent.active ? "#101419" : "#dce3ea"
                font.pixelSize: 13
                font.bold: parent.active
                font.family: "BlexMono Nerd Font"
              }

              MouseArea {
                id: workspaceMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.setWorkspace(modelData)
              }
            }
          }
        }

        Text {
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignVCenter
          text: root.activeTitle
          color: "#dce3ea"
          elide: Text.ElideRight
          font.pixelSize: 14
          font.family: "BlexMono Nerd Font"
        }

        RowLayout {
          Layout.alignment: Qt.AlignVCenter
          spacing: 8

          Item {
            Layout.preferredWidth: 60
            Layout.preferredHeight: 28
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
              anchors.fill: parent
              radius: 6
              color: audioMouse.containsMouse || audioPopup.visible ? "#1d252e" : "transparent"

              Row {
                anchors.centerIn: parent
                spacing: 6

                Text {
                  text: root.audioIcon()
                  color: root.audioMuted ? "#ffb4ab" : "#a8c7fa"
                  font.pixelSize: 16
                  font.family: "BlexMono Nerd Font"
                }

                Text {
                  text: root.volumeText
                  color: "#dce3ea"
                  font.pixelSize: 14
                  font.family: "BlexMono Nerd Font"
                }
              }

              MouseArea {
                id: audioMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                cursorShape: Qt.PointingHandCursor

                onClicked: event => {
                  if (event.button === Qt.LeftButton) {
                    audioPopup.visible = !audioPopup.visible
                  } else if (event.button === Qt.RightButton) {
                    root.toggleAudioMute()
                  } else if (event.button === Qt.MiddleButton) {
                    root.run(["sh", "-c", "(pwvucontrol || pavucontrol) >/dev/null 2>&1 &"])
                  }
                }

                onWheel: wheel => {
                  if (wheel.angleDelta.y > 0)
                    root.changeAudioVolume(0.05)
                  else
                    root.changeAudioVolume(-0.05)
                }
              }
            }

            PopupWindow {
              id: audioPopup
              visible: false
              onVisibleChanged: {
                if (visible) {
                  root.refreshFallbackAudio()
                  root.refreshMediaInfo()
                }
              }
              anchor.window: barWindow
              anchor.rect.x: barWindow.width - width - 12
              anchor.rect.y: 42
              implicitWidth: 380
              implicitHeight: 360
              color: "transparent"

              Rectangle {
                anchors.fill: parent
                radius: 8
                color: "#151b22"
                border.color: "#3a4654"
                border.width: 1

                ColumnLayout {
                  anchors.fill: parent
                  anchors.margins: 18
                  spacing: 14

                  RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                      text: root.audioIcon()
                      color: root.audioMuted ? "#ffb4ab" : "#a8c7fa"
                      font.pixelSize: 26
                      font.family: "BlexMono Nerd Font"
                    }

                    ColumnLayout {
                      Layout.fillWidth: true
                      spacing: 2

                      Text {
                        Layout.fillWidth: true
                        text: root.audioName
                        color: "#dce3ea"
                        elide: Text.ElideRight
                        font.pixelSize: 15
                        font.family: "BlexMono Nerd Font"
                      }

                      Text {
                        text: root.audioMuted ? "Muted" : root.volumeText
                        color: "#b7c3cf"
                        font.pixelSize: 13
                        font.family: "BlexMono Nerd Font"
                      }
                    }

                    Rectangle {
                      width: 40
                      height: 34
                      radius: 6
                      color: muteMouse.containsMouse ? "#27313c" : "#202832"

                      Text {
                        anchors.centerIn: parent
                        text: root.audioMuted ? "󰖁" : "󰕾"
                        color: "#dce3ea"
                        font.pixelSize: 18
                        font.family: "BlexMono Nerd Font"
                      }

                      MouseArea {
                        id: muteMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.toggleAudioMute()
                      }
                    }
                  }

                  Slider {
                    id: volumeSlider
                    Layout.fillWidth: true
                    Layout.preferredHeight: 28
                    implicitHeight: 28
                    from: 0
                    to: 1
                    stepSize: 0.01
                    value: root.audioVolume
                    enabled: root.hasAudio
                    live: true
                    onMoved: root.setAudioVolume(value)

                    background: Rectangle {
                      x: volumeSlider.leftPadding
                      y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                      width: volumeSlider.availableWidth
                      height: 6
                      radius: 3
                      color: "#202832"

                      Rectangle {
                        width: volumeSlider.visualPosition * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: "#a8c7fa"
                      }
                    }

                    handle: Rectangle {
                      x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                      y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                      implicitWidth: 18
                      implicitHeight: 18
                      width: implicitWidth
                      height: implicitHeight
                      radius: width / 2
                      color: volumeSlider.pressed ? "#dce3ea" : "#a8c7fa"
                      border.color: "#151b22"
                      border.width: 2
                    }
                  }

                  RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Repeater {
                      model: [25, 50, 75, 100]

                      Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 38
                        radius: 6
                        color: presetMouse.containsMouse ? "#27313c" : "#202832"
                        opacity: root.hasAudio ? 1 : 0.45

                        Text {
                          anchors.centerIn: parent
                          text: modelData + "%"
                          color: "#dce3ea"
                          font.pixelSize: 14
                          font.family: "BlexMono Nerd Font"
                        }

                        MouseArea {
                          id: presetMouse
                          anchors.fill: parent
                          enabled: root.hasAudio
                          hoverEnabled: true
                          cursorShape: Qt.PointingHandCursor
                          onClicked: root.setAudioPreset(modelData)
                        }
                      }
                    }
                  }

                  RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                      Layout.fillWidth: true
                      Layout.preferredHeight: 44
                      radius: 6
                      color: micMouse.containsMouse ? "#27313c" : "#202832"
                      opacity: root.micReady ? 1 : 0.45

                      Row {
                        anchors.centerIn: parent
                        spacing: 7

                        Text {
                          text: root.micMuted ? "󰍭" : "󰍬"
                          color: root.micMuted ? "#ffb4ab" : "#a8c7fa"
                          font.pixelSize: 17
                          font.family: "BlexMono Nerd Font"
                        }

                        Text {
                          text: root.micMuted ? "Mic muted" : "Mic on"
                          color: "#dce3ea"
                          font.pixelSize: 14
                          font.family: "BlexMono Nerd Font"
                        }
                      }

                      MouseArea {
                        id: micMouse
                        anchors.fill: parent
                        enabled: root.micReady
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                          root.micMuted = !root.micMuted
                          root.run(["pamixer", "--default-source", "--toggle-mute"])
                        }
                      }
                    }

                    Rectangle {
                      Layout.fillWidth: true
                      Layout.preferredHeight: 44
                      radius: 6
                      color: mixerMouse.containsMouse ? "#27313c" : "#202832"

                      Row {
                        anchors.centerIn: parent
                        spacing: 7

                        Text {
                          text: "󰓃"
                          color: "#a8c7fa"
                          font.pixelSize: 17
                          font.family: "BlexMono Nerd Font"
                        }

                        Text {
                          text: "Mixer"
                          color: "#dce3ea"
                          font.pixelSize: 14
                          font.family: "BlexMono Nerd Font"
                        }
                      }

                      MouseArea {
                        id: mixerMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.run(["sh", "-c", "(pwvucontrol || pavucontrol) >/dev/null 2>&1 &"])
                      }
                    }

                    Rectangle {
                      Layout.fillWidth: true
                      Layout.preferredHeight: 44
                      radius: 6
                      color: effectsMouse.containsMouse ? "#27313c" : "#202832"

                      Row {
                        anchors.centerIn: parent
                        spacing: 7

                        Text {
                          text: "󰛩"
                          color: "#a8c7fa"
                          font.pixelSize: 17
                          font.family: "BlexMono Nerd Font"
                        }

                        Text {
                          text: "FX"
                          color: "#dce3ea"
                          font.pixelSize: 14
                          font.family: "BlexMono Nerd Font"
                        }
                      }

                      MouseArea {
                        id: effectsMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.run(["sh", "-c", "(~/.local/scripts/easyeffects || easyeffects) >/dev/null 2>&1 &"])
                      }
                    }
                  }

                  Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 74
                    radius: 6
                    color: "#101419"
                    border.color: "#3a4654"
                    border.width: 1

                    RowLayout {
                      anchors.fill: parent
                      anchors.margins: 12
                      spacing: 10

                      Rectangle {
                        Layout.preferredWidth: 42
                        Layout.preferredHeight: 42
                        radius: 6
                        color: "#202832"

                        Text {
                          anchors.centerIn: parent
                          text: root.mediaStatus === "Playing" ? "󰏤" : "󰐊"
                          color: "#a8c7fa"
                          font.pixelSize: 20
                          font.family: "BlexMono Nerd Font"
                        }

                        MouseArea {
                          anchors.fill: parent
                          cursorShape: Qt.PointingHandCursor
                          onClicked: {
                            root.mediaStatus = root.mediaStatus === "Playing" ? "Paused" : "Playing"
                            root.run(["playerctl", "play-pause"])
                          }
                        }
                      }

                      ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                          Layout.fillWidth: true
                          text: root.mediaTitle
                          color: "#dce3ea"
                          elide: Text.ElideRight
                          font.pixelSize: 14
                          font.family: "BlexMono Nerd Font"
                        }

                        Text {
                          Layout.fillWidth: true
                          text: root.mediaArtist || root.mediaStatus || "playerctl"
                          color: "#b7c3cf"
                          elide: Text.ElideRight
                          font.pixelSize: 12
                          font.family: "BlexMono Nerd Font"
                        }
                      }

                      Rectangle {
                        Layout.preferredWidth: 38
                        Layout.preferredHeight: 38
                        radius: 6
                        color: prevMouse.containsMouse ? "#27313c" : "#202832"

                        Text {
                          anchors.centerIn: parent
                          text: "󰒮"
                          color: "#dce3ea"
                          font.pixelSize: 18
                          font.family: "BlexMono Nerd Font"
                        }

                        MouseArea {
                          id: prevMouse
                          anchors.fill: parent
                          hoverEnabled: true
                          cursorShape: Qt.PointingHandCursor
                          onClicked: {
                            root.run(["playerctl", "previous"])
                            root.refreshMediaInfo()
                          }
                        }
                      }

                      Rectangle {
                        Layout.preferredWidth: 38
                        Layout.preferredHeight: 38
                        radius: 6
                        color: nextMouse.containsMouse ? "#27313c" : "#202832"

                        Text {
                          anchors.centerIn: parent
                          text: "󰒭"
                          color: "#dce3ea"
                          font.pixelSize: 18
                          font.family: "BlexMono Nerd Font"
                        }

                        MouseArea {
                          id: nextMouse
                          anchors.fill: parent
                          hoverEnabled: true
                          cursorShape: Qt.PointingHandCursor
                          onClicked: {
                            root.run(["playerctl", "next"])
                            root.refreshMediaInfo()
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 18
            Layout.preferredHeight: 28

            Text {
              anchors.centerIn: parent
              text: "󰖩"
              color: "#a8c7fa"
              font.pixelSize: 16
              font.family: "BlexMono Nerd Font"
            }
          }

          Text {
            Layout.alignment: Qt.AlignVCenter
            text: root.timeText
            color: "#dce3ea"
            font.pixelSize: 14
            font.family: "BlexMono Nerd Font"
          }
        }
      }
    }
  }
}
