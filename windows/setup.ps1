#Requires -RunAsAdministrator

$dotfiles = Split-Path -Parent $PSScriptRoot
$config   = "$env:USERPROFILE\.config"

if (-not (Test-Path $config)) { throw ".config not found: $config" }

function ln($t, $l) { New-Item -ItemType SymbolicLink -Path $l -Target $t -Force | Out-Null }

ln "$dotfiles\linux\editor\nvim"                                    "$env:LOCALAPPDATA\nvim"
ln "$dotfiles\linux\editor\nvim"                                    "$config\nvim"
ln "$dotfiles\linux\terminal\wezterm"                               "$config\wezterm"
ln "$dotfiles\windows\autohotkey"                                   "$config\autohotkey"
ln "$dotfiles\windows\kanata"                                       "$config\kanata"
ln "$dotfiles\windows\komorebi"                                     "$config\komorebi"
ln "$dotfiles\windows\PowerShell\Microsoft.PowerShell_profile.ps1"  $PROFILE
