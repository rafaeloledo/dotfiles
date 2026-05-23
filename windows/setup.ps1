#Requires -RunAsAdministrator

$dotfiles = Split-Path -Parent $PSScriptRoot

function New-Junction {
    param([string]$Target, [string]$Link)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Link) | Out-Null
    if (Test-Path $Link) {
        Write-Host "Skipped (exists): $Link"
        return
    }
    New-Item -ItemType Junction -Path $Link -Target $Target | Out-Null
    Write-Host "Linked: $Link"
}

function New-FileLink {
    param([string]$Target, [string]$Link)
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Link) | Out-Null
    if (Test-Path $Link) {
        Write-Host "Skipped (exists): $Link"
        return
    }
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
    Write-Host "Linked: $Link"
}

# Editor (shared with Linux)
New-Junction "$dotfiles\linux\editor\nvim" "$env:LOCALAPPDATA\nvim"
New-Junction "$dotfiles\linux\editor\nvim" "$env:USERPROFILE\.config\nvim"

# Terminal (shared with Linux)
New-Junction "$dotfiles\linux\terminal\wezterm" "$env:USERPROFILE\.config\wezterm"

# Windows-specific configs
New-Junction "$dotfiles\windows\autohotkey" "$env:USERPROFILE\.config\autohotkey"
New-Junction "$dotfiles\windows\kanata"     "$env:USERPROFILE\.config\kanata"
New-Junction "$dotfiles\windows\komorebi"   "$env:USERPROFILE\.config\komorebi"

# PowerShell profile
New-FileLink "$dotfiles\windows\PowerShell\Microsoft.PowerShell_profile.ps1" $PROFILE
