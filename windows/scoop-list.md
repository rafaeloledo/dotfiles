Set system env vars
```
SCOOP = C:\dev\scoop
SCOOP_GLOBAL = C:\dev\scoopg
```

Install scoop
``` sh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
Installing list of programs
``` sh
scoop install git fzf ripgrep fd
```

``` sh
scoop bucket add extras
scoop bucket add java
scoop bucket add nerd-fonts
```
``` sh
scoop install wezterm android-studio arduino bat cacert ccache clangd cmake cmder cpu-z crystaldiskinfo crystaldiskmark ctags curl cutter dark discord emacs eza fd ffmpeg firacode-nf firacode-nf-mono fzf gcc ghidra gimp go gpu-z gzip hack-nf robotomono-nf hwinfo hwmonitor innounp jq llvm lua-language-server make maven miktex msiafterburner nano neovide neovim ninja nodejs ntop obs-studio openjdk17 pandoc postman pwsh python qemu revouninstaller rust rust-analyzer rustup scrcpy sqlite starship steam stylua sudo tar unzip ventoy vim wget x64dbg yt-dlp zoxide
```
