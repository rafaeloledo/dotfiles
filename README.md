_Obs: This README is both for helping me documenting and synthetically showing my setup/dotfiles_

If you're curious, enter on my repos and filter for `config files` to get all
the repos related to my dotfiles

## Setup Ingredients

- `obsidian` - Markdown editor
  - I do not use vim mode, it have a bunch of shortcut conflicts
- `alacritty` - GPU accelerated terminal emulator
  - Only for GNU/Linux
- `fish` - User-friendly shell
  - I don't use tide, just override fish_prompt
- `hyprland` - Wayland compositor
  - `waybar` - Wayland customizable bar
  - `rofi` - Launcher
  - `swaylock` - Locker
- `vscode` - Microsoft editor
  - I do not use vim mode, it have a bunch of shortcut conflicts
- `neovim` - Extensible editor

  - Only here the _vim's mode_; i follow the "knife" vim philosophy and do not try to apply on other places, so much maintenance and conflicts to lead, only use the _vim mode_ in `vim`. My brain is prepared to only use the respective shortcuts inside it.

  ```
  Commit date plugins

  wbthomason/packer.nvim
  nvim-lua/plenary.nvim
  onsails/lspking.nvim
  hrsh7th/cmp-buffer
  hrsh7th/cmp-nvim-lsp
  hrsh7th/nvim-cmp
  neovim/nvim-lspconfig
  jose-elias-alvarez/null-ls.nvim
  williamboman/mason.nvim
  williamboman/mason-lspconfig.nvim
  glepnir/lspsaga.nvim
  L3MON4D3/LuaSnip
  nvim-treesitter/nvim-treesitter
  kyazdani42/nvim-web-devicons
  nvim-telescope/telescope.nvim
  nvim-telescope/telescope-file-browser.nvim
  windwp/nvim-autopairs
  norcalli/nvim-colorizer.lua
  iamcco/markdown-preview.nvim
  akinsho/nvim-bufferline.lua
  lewis6991/gitsigns.nvim
  dinhhuy258/git.nvim
  rose-pine/neovim
  folke/zen-mode.nvim
  ```

- `tmux` - Terminal multiplexer

## Configurations

- `PowerShell profile`
- `Firefox profile`
  - Based on `yokoffing/Betterfox` and `ericmurphyxyz/userChrome.css`
- `Keyboard schemes`
  - For storing `eclipse-like` maps

## Other

- `scripts`

## OS

- Windows
  - WSL
    - Ubuntu - _For outdated repos or unsupported apps_
    - Arch
- GNU/Linux
  - Arch

## General tools

- `msys2` - Linux subsystem integrated with windows
- `scoop` - Windows installer
- `winget` - Windows package manager

## Workflow

- `peco` - Filtering tool
- `commitizen` - For human readable commit template
  - Only use for repos following the pattern

## Preferred themes

- `Rosé pine` - General applications
- `One Dark Pro` - For applications that not have the above theme

## Cloud on linux

- `astrada/google-drive-ocamlfuse` - Google drive
- `jstaf/onedriver` - One drive

## Aiming to use/test

- `emacs` - An operating system
- `ghq` - Remote repository manager

> I won't post any images for the sake of reduce maintenance and not bloating this repo. If u're curious, my setup visual may change over time and there is a list of channels that i watch on free time. You don't have to copy me.

_Obs: this list is extensive and one or more channels may not exist in the date of you're reading_

_ThePrimeagen_, _devaslife_, _DistroTube_, _Chris Titus Tech_, _Fabio Akita_, _Eric Murphy_, _TechLead_, _Dave's Garage_, _strager_, _The Cherno_
and so on...
