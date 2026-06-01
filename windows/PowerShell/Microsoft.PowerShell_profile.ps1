$profileScript = if ($target = (Get-Item -LiteralPath $PSCommandPath).Target) { $target } else { $PSCommandPath }
$profileDir = Split-Path -Parent $profileScript

Get-ChildItem -LiteralPath (Join-Path $profileDir 'profile.d') -Filter '*.ps1' |
  Sort-Object Name |
  ForEach-Object { . $_.FullName }

. (Join-Path $profileDir 'zoxide.ps1')
