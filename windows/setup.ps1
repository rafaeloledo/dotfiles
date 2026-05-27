#Requires -RunAsAdministrator

$dotfiles = Split-Path -Parent $PSScriptRoot

function New-Symlink {
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
New-Symlink "$dotfiles\linux\editor\nvim" "$env:LOCALAPPDATA\nvim"
New-Symlink "$dotfiles\linux\editor\nvim" "$env:USERPROFILE\.config\nvim"

# Terminal (shared with Linux)
New-Symlink "$dotfiles\linux\terminal\wezterm" "$env:USERPROFILE\.config\wezterm"

# Windows-specific configs
New-Symlink "$dotfiles\windows\autohotkey" "$env:USERPROFILE\.config\autohotkey"
New-Symlink "$dotfiles\windows\kanata"     "$env:USERPROFILE\.config\kanata"
New-Symlink "$dotfiles\windows\komorebi"   "$env:USERPROFILE\.config\komorebi"

# PowerShell profile
New-Symlink "$dotfiles\windows\PowerShell\Microsoft.PowerShell_profile.ps1" $PROFILE
