#Requires AutoHotkey v2.0
#SingleInstance Force

; komorebi keybinds (replaces whkdrc) + smart Alacritty spawn on focused monitor
; Mod = Alt (matches previous whkd setup)

AlacrittyExe := "C:\scoop\apps\alacritty\current\alacritty.exe"

; --- Spawn Alacritty on the monitor under the mouse (Hyprland-style) ---
SpawnAlacrittyHere() {
    global AlacrittyExe
    MouseGetPos &mx, &my
    monIdx := MonitorFromPoint(mx, my)
    MonitorGetWorkArea(monIdx, &l, &t, &r, &b)
    x := l + 100
    y := t + 100
    Run Format('"{1}" --position {2},{3}', AlacrittyExe, x, y)
}

MonitorFromPoint(x, y) {
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &l, &t, &r, &b)
        if (x >= l && x < r && y >= t && y < b)
            return A_Index
    }
    return MonitorGetPrimary()
}

K(args*) {
    cmd := "komorebic.exe"
    for a in args
        cmd .= " " a
    Run cmd, , "Hide"
}

; --- App / system shortcuts ---
!q::SpawnAlacrittyHere()
!e::Run "explorer.exe"
!r::Send "{LAlt down}{Space}{LAlt up}"   ; PowerToys Run
!b::Run "chrome.exe"
!n::Run 'cmd /c start "" "obsidian://"', , "Hide"
!m::K("stop")

; --- Window management ---
!c::K("close")
!v::K("toggle-float")
!d::K("toggle-float")
!f::K("toggle-maximize")
!p::K("toggle-monocle")
!x::K("flip-layout", "horizontal")
!g::K("toggle-window-container-behaviour")

; --- Focus (hjkl) ---
!h::K("focus", "left")
!j::K("focus", "down")
!k::K("focus", "up")
!l::K("focus", "right")

; --- Move window (alt+ctrl+hjkl) ---
!^h::K("move", "left")
!^j::K("move", "down")
!^k::K("move", "up")
!^l::K("move", "right")
!^m::K("move-to-monitor", "1")

; --- Workspaces 1-10 ---
!1::K("focus-workspace", "0")
!2::K("focus-workspace", "1")
!3::K("focus-workspace", "2")
!4::K("focus-workspace", "3")
!5::K("focus-workspace", "4")
!6::K("focus-workspace", "5")
!7::K("focus-workspace", "6")
!8::K("focus-workspace", "7")
!9::K("focus-workspace", "8")
!0::K("focus-workspace", "9")

; --- Move to workspace ---
!^1::K("move-to-workspace", "0")
!^2::K("move-to-workspace", "1")
!^3::K("move-to-workspace", "2")
!^4::K("move-to-workspace", "3")
!^5::K("move-to-workspace", "4")
!^6::K("move-to-workspace", "5")
!^7::K("move-to-workspace", "6")
!^8::K("move-to-workspace", "7")
!^9::K("move-to-workspace", "8")
!^0::K("move-to-workspace", "9")

; --- Cycle workspaces ---
![::K("cycle-workspace", "previous")
!]::K("cycle-workspace", "next")
!PgUp::K("cycle-workspace", "previous")
!PgDn::K("cycle-workspace", "next")

; --- Reload komorebi config ---
!^r::K("reload-configuration")
