#Requires -RunAsAdministrator

$dotfiles = Split-Path -Parent $PSScriptRoot
$config   = "$env:USERPROFILE\.config"

if (-not (Test-Path $config)) { throw ".config not found: $config" }

function ln($t, $l) { New-Item -ItemType SymbolicLink -Path $l -Target $t -Force | Out-Null }

ln "$dotfiles\shared\editor\nvim"                                   "$env:LOCALAPPDATA\nvim"
ln "$dotfiles\shared\terminal\wezterm"                              "$config\wezterm"
ln "$dotfiles\windows\autohotkey"                                   "$config\autohotkey"
ln "$dotfiles\windows\kanata"                                       "$config\kanata"
ln "$dotfiles\windows\komorebi"                                     "$config\komorebi"
ln "$dotfiles\windows\PowerShell\Microsoft.PowerShell_profile.ps1"  $PROFILE
ln "$dotfiles\windows\terminal\psmux"                               "$config\psmux"
ln "$dotfiles\shared\terminal\yazi"                                 "$env:APPDATA\yazi\config"
ln "$dotfiles\shared\terminal\alacritty"                            "$env:APPDATA\alacritty"

# Windows Terminal — settings.json under the Store package's LocalState.
# Match any WT variant (Microsoft.WindowsTerminal_*, Microsoft.WindowsTerminalPreview_*, …).
Get-ChildItem "$env:LOCALAPPDATA\Packages" -Directory -Filter "Microsoft.WindowsTerminal*" |
    ForEach-Object {
        $wtState = Join-Path $_.FullName "LocalState"
        if (Test-Path $wtState) {
            ln "$dotfiles\windows\terminal\windows-terminal\settings.json" "$wtState\settings.json"
        }
    }

# Firefox user.js into every existing profile.
# Match standard Firefox profile dirs (<8+ alnum id>.<name>) — skips Crash Reports, Pending Pings, etc.
$ffRoot = "$env:APPDATA\Mozilla\Firefox\Profiles"
if (Test-Path $ffRoot) {
    Get-ChildItem $ffRoot -Directory |
        Where-Object { $_.Name -match '\.default-release$' } |
        ForEach-Object {
            ln "$dotfiles\linux\apps\firefox\user.js" "$($_.FullName)\user.js"
            ln "$dotfiles\linux\apps\firefox\chrome"  "$($_.FullName)\chrome"
        }
}

# Firefox enterprise policy — auto-installs uBlock Origin into every profile.
# Lives next to firefox.exe under a "distribution" folder.
foreach ($ffDir in @("$env:ProgramFiles\Mozilla Firefox", "${env:ProgramFiles(x86)}\Mozilla Firefox")) {
    if (Test-Path "$ffDir\firefox.exe") {
        $dist = Join-Path $ffDir 'distribution'
        New-Item -ItemType Directory -Force -Path $dist | Out-Null
        ln "$dotfiles\linux\apps\firefox\policies.json" "$dist\policies.json"
    }
}

