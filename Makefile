.PHONY: setup clear keyd config_files wall_and_scripts doom anotacoes archlinux vim-misc firefox

MAKEFLAGS += -s

install:
	@$(MAKE) config
	@$(MAKE) wall_and_scripts
	@$(MAKE) keyd

clean:
	@echo "Cleaning config..."
	@rm ~/.local/scripts ~/wallpapers ~/.config/doom ~/.config/hypr \
	~/.config/i3 ~/.config/yazi ~/.config/picom ~/.config/tmux \
	~/.config/wezterm ~/.config/waybar ~/.config/zshrc ~/.config/ansible ~/.config/fish \
	~/.config/rofi ~/.config/.gitconfig ~/.config/dunst ~/.config/keyd ~/.config/gtk-3.0 ~/.config/ghostty

keyd:
	@echo "Setting up keyd..."
	@sudo ln -nfs ~/dotfiles/keyd/default.conf /etc/keyd/default.conf

SYMLINKS := doom zshrc ansible fish rofi .gitconfig dunst keyd gtk-3.0
SYMLINKS_TERMINAL := wezterm ghostty tmux yazi
SYMLINKS_WLND := hypr waybar
SYMLINKS_XORG := i3 picom
SYMLINKS_SHELL := zshrc fish

config:
	@echo "Setting up config files..."
	@for file in $(SYMLINKS); do \
		ln -nfs ~/dotfiles/$$file ~/.config/$$file; \
	done
	$(MAKE) config/wayland
	$(MAKE) config/xorg
	$(MAKE) config/terminal
	$(MAKE) config/shell
	@ln -nfs ~/dotfiles/.gitconfig ~/.gitconfig

config/terminal:
	@for file in $(SYMLINKS_TERMINAL); do \
		ln -nfs ~/dotfiles/terminal/$$file ~/.config/$$file; \
	done

config/shell:
	@for file in $(SYMLINKS_SHELL); do \
		ln -nfs ~/dotfiles/shell/$$file ~/.config/$$file; \
	done

config/wayland:
	@for file in $(SYMLINKS_WLND); do \
		ln -nfs ~/dotfiles/wayland/$$file ~/.config/$$file; \
	done

config/xorg:
	@for file in $(SYMLINKS_XORG); do \
		ln -nfs ~/dotfiles/xorg/$$file ~/.config/$$file; \
	done

wall_and_scripts:
	@echo "Setting up wallpapers and scripts..."
	@ln -nfs ~/dotfiles/scripts/ ~/.local/scripts
	@ln -nfs ~/dotfiles/wallpapers/ ~/wallpapers

push:
	@git add . && git commit --amend --no-edit && git push -f

DOOM_REPO := https://github.com/doomemacs/doomemacs
DOOM_INSTALL_DIR = $(HOME)/.config/emacs

doom:
	@if [ ! -d "$(DOOM_INSTALL_DIR)" ]; then \
		git clone --depth 1 "$(DOOM_REPO)" "$(DOOM_INSTALL_DIR)"; \
		$(DOOM_INSTALL_DIR)/bin/doom install; \
	else
		@echo "Doom already installed."
	fi

NOTES_DIR := $(HOME)/sync

ARCHLINUX_PACKAGES := \
	neovim google-chrome ani-cli \
	android-tools android-file-transfer \
	arduino-ide bat blueman cloudflared \
	cmake dbeaver discord duf dunst egl-wayland \
	emacs eza fastfetch fd feh fish ghostty git go \
	google-chrome grim helix hyprland hyprpaper hyprpicker \
	i3-wm i3blocks i3lock i3status i7z inkscape intellij-idea-community-edition jq keyd \
	lazygit libvirt lmstudio lua-language-server maim man-db man-pages \
	mariadb maven mission-center mtpfs neovide network-manager-applet \
	ngrok nodejs-live-server noto-fonts-cjk noto-fonts-extra nvtop obs-studio \
	okular pamixer php picom pnpm postgresql postman-bin pyright python-pip qemu-full \
	qt5-tools rofi rustup slurp starship staruml stow swaybg thunar tmux ttf-hack-nerd \
	ttf-ubuntu-nerd typescript-language-server viewnior waybar wezterm wl-clipboard xclip \
	yazi youtube-music zoxide zsh kwave composer obsidian nautilus gnome-tweaks ruby cliphist \
	python-pillow python-pytesseract grimblast-git rofi-wayland flatpak git-lfs plantuml plantuml-server \
	graphviz pavucontrol hyprshot imagemagick tesseract

archlinux:
	@pacman -Qq $(ARCHLINUX_PACKAGES)

set_rust:
	@rustup default stable

flatpak:
	@echo "easyeffects"

vim/vanilla:
	ln -nfs ~/dotfiles/editor/vim ~/.config/nvim

vim/default:
	ln -nfs ~/dotfiles/editor/lazyvim ~/.config/nvim

firefox:
	@echo "Append this file config to the current default profile"
	@echo "To see, type about:profiles in firefox"
	@bat -p "firefox/prefs.js"

clear/nvim:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim
