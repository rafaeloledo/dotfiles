$WarningPreference = "SilentlyContinue"

Import-Module PsFzfUtil
#Import-Module PSFzf

[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

function ExportCurrentPath () {
  $existingPath = [Environment]::GetEnvironmentVariable('Path', 'User')
  ($existingPath -notlike "*$pwd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $pwd, 'User') 2>&1>$null
}

function ExportPath ($PathToAdd) {
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'User')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'User')
}

function GlobalExport ($PathToAdd) {
	$existingPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
	($existingPath -notlike "*$PathToAdd*") -and [Environment]::SetEnvironmentVariable('Path', $env:Path + ";" + $PathToAdd, 'Machine')
}

# Just for registering the Exports, run this only one time in the cli
# Export 'C:\dev\projects\lol_auto_accept\lol_auto_accept\bin\Debug' > $null
# Export 'C:\ProgramData\chocolatey\lib\asmspy\tools' > $null
# Export 'C:\dev\scoop\apps\autohotkey\current\Compiler' > $null
# Export 'C:\dev\scoop\apps\scoop\current\bin' > $null
# Export 'C:\Users\rafae\AppData\Local\Obsidian' > $null
# Export 'C:\dev\scoop\shims' > $null

Remove-Alias cat 2>&1>$null
function cat ($parameter) {
	bat --plain --color=always $parameter
}
Remove-Alias history 2>&1>$null
function history () {
  cat (Get-PSReadlineOption).HistorySavePath
}

function pall () {
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	$back = Get-Location
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Output $dir.FullName
		git pull origin
	}
	Set-Location $back.Path
}

function st () {
	$originalDir = Get-Location
	$dirs = Get-ChildItem -Path . | Where-Object { $_.PSIsContainer }
	foreach ($dir in $dirs) {
		Set-Location $dir.FullName
		Write-Host $dir.BaseName -ForegroundColor green
		git status
	}

	Set-Location $originalDir
}

function phonewithoutplayback () {
  C:\dev\scoop\apps\scrcpy\current\scrcpy-noconsole.vbs --disable-screensaver --turn-screen-off --no-audio-playback -f
}

function phonewithplayback () {
  C:\dev\scoop\apps\scrcpy\current\scrcpy-noconsole.vbs --disable-screensaver --turn-screen-off -f
}

function tree {
  eza -lA --tree --git-ignore --color=always --color-scale=all --color-scale-mode=gradient -F=always --icons=always -I="node_modules" $path
}

function pics () {
  cd 'C:\Users\rafae\OneDrive\Imagens\Capturas de tela'
}

function vids () {
  cd 'C:\Users\rafae\Videos'
}

function roaming () {
  cd 'C:\Users\rafae\AppData\Roaming'
}

function appdata () {
  cd 'C:\Users\rafae\AppData\Local'
}

function config () {
  cd 'C:\Users\rafae\.config'
}

function which ($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function ll ($path) {
  eza -lA --color=always --color-scale=all --color-scale-mode=gradient -F=always --icons=always -I="node_modules" $path
}

function ide {
  Start-Process wt "sp -H -s 0.30 -d $PWD"
  Start-Sleep -Seconds 0.2
  Start-Process wt "sp -V -s 0.65 -d $PWD"
  Start-Sleep -Seconds 0.2
  Start-Process wt "sp -V -s 0.5 -d $PWD"
  Start-Sleep -Seconds 0.2
}

function prompt {
  "$($executionContext.SessionState.Path.CurrentLocation)$(">" * ($nestedPromptLevel + 1)) ";
}

 Invoke-Expression (&starship init powershell)

Set-Alias v 'C:\dev\scoop\apps\neovim\current\bin\nvim.exe'
Set-Alias neo 'neovide.exe'
Set-Alias g git
Set-Alias ex 'explorer.exe'
Set-Alias e emacs
Set-Alias s 'subl.exe'
Set-Alias obs 'Obsidian.exe'
Set-Alias xxd 'C:\dev\scoop\apps\git\current\usr\bin\xxd.exe'
Set-Alias touch 'C:\dev\scoop\apps\git\current\usr\bin\touch.exe'
Set-Alias rm 'C:\dev\scoop\apps\git\current\usr\bin\rm.exe'
Set-Alias bash 'C:\dev\scoop\apps\git\current\usr\bin\bash.exe'
Set-Alias grep 'C:\dev\scoop\apps\git\current\usr\bin\grep.exe'
Set-Alias tig 'C:\dev\scoop\apps\git\current\usr\bin\tig.exe'
Set-Alias less 'C:\dev\scoop\apps\git\current\usr\bin\less.exe'
Set-Alias awk 'C:\dev\scoop\apps\git\current\usr\bin\awk.exe'
Set-Alias mv 'C:\dev\scoop\apps\git\current\usr\bin\mv.exe'
Set-Alias perl 'C:\dev\scoop\apps\git\current\usr\bin\perl.exe'
Set-Alias xargs 'C:\dev\scoop\apps\git\current\usr\bin\xargs.exe'
Set-Alias autoaccepter 'lol_auto_accept.exe'

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord "Alt+l" -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+LeftArrow" -Function BackwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function NextWord
Set-PSReadLineKeyHandler -Chord "Ctrl+n" -Function NextSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+p" -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function SelectAll
Set-PSReadLineKeyHandler -Chord "Ctrl+z" -Function Undo
Set-PSReadLineKeyHandler -Chord "Ctrl+o" -ScriptBlock { MyFzf } > $null
Set-PSReadLineKeyHandler -Chord "Ctrl+r" -ScriptBlock { MyRg  } > $null
Set-PSReadLineKeyHandler -Chord "Ctrl+u" -ScriptBlock { scoop update * }
