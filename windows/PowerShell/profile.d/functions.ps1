Remove-Alias cat 2>&1>$null
function cat ($parameter) {
	bat --plain --color=always $parameter
}

Remove-Alias history 2>&1>$null
function history () {
  cat (Get-PSReadlineOption).HistorySavePath
}

function tree {
  eza -lA --tree --git-ignore --color=always --color-scale=all --color-scale-mode=gradient -F=always --icons=always -I="node_modules" $path
}

function ll ($path) {
  eza -lA --color=always --color-scale=all --color-scale-mode=gradient -F=always --icons=always -I="node_modules" $path
}

function which ($command) {
  Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
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

# Run yazi in the current Alacritty window at 2x font size.
# Uses `alacritty msg config` to live-update the running instance, then resets on exit.
function yazi {
  try {
    alacritty msg config "font.size=24" 2>$null
    yazi.exe @args
  } finally {
    alacritty msg config --reset 2>$null
  }
}

function ide {
  Start-Process wt "sp -H -s 0.30 -d $PWD"
  Start-Sleep -Seconds 0.2
  Start-Process wt "sp -V -s 0.65 -d $PWD"
  Start-Sleep -Seconds 0.2
  Start-Process wt "sp -V -s 0.5 -d $PWD"
  Start-Sleep -Seconds 0.2
}