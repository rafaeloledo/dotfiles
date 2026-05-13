.PHONY: install clean keyd keyd/service vim/setup firefox clear/nvim npm/prefix archlinux archlinux/link push

MAKEFLAGS += -s

DOTFILES := $(HOME)/dotfiles
CONFIG_HOME := $(HOME)/.config
LOCAL_BIN := $(HOME)/.local/scripts
BACKUP_SUFFIX := backup.$(shell date +%Y%m%d%H%M%S)

define link_path
	@mkdir -p "$(dir $(2))"
	@if [ -e "$(2)" ] && [ ! -L "$(2)" ]; then \
		mv "$(2)" "$(2).$(BACKUP_SUFFIX)"; \
	fi
	@ln -nfs "$(1)" "$(2)"
endef

install:
	@$(MAKE) archlinux/link
	@$(MAKE) keyd

clean:
	@echo "Cleaning config..."
	@rm -f "$(LOCAL_BIN)" "$(HOME)/wallpapers" \
		"$(CONFIG_HOME)/doom" "$(CONFIG_HOME)/hypr" "$(CONFIG_HOME)/yazi" \
		"$(CONFIG_HOME)/tmux" "$(CONFIG_HOME)/wezterm" "$(CONFIG_HOME)/zellij" \
		"$(CONFIG_HOME)/alacritty" \
		"$(CONFIG_HOME)/quickshell" \
		"$(CONFIG_HOME)/fish" "$(CONFIG_HOME)/rofi" "$(CONFIG_HOME)/dunst" \
		"$(CONFIG_HOME)/gtk-3.0" "$(CONFIG_HOME)/ghostty" "$(CONFIG_HOME)/lazygit" \
		"$(CONFIG_HOME)/environment.d" "$(CONFIG_HOME)/sublime-text" "$(CONFIG_HOME)/wofi" \
		"$(CONFIG_HOME)/nvim" "$(HOME)/.gitconfig"

keyd:
	@echo "Setting up keyd..."
	@sudo mkdir -p /etc/keyd
	@sudo ln -nfs "$(DOTFILES)/keyd/default.conf" /etc/keyd/default.conf

keyd/service:
	sudo systemctl enable keyd --now

NOTES_DIR := $(HOME)/sync

vim/setup:
	$(call link_path,$(DOTFILES)/editor/nvim,$(CONFIG_HOME)/nvim)

firefox:
	@echo "Append this file config to the current default profile"
	@echo "To see, type about:profiles in firefox"
	@bat -p "firefox/prefs.js"

clear/nvim:
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
	rm -rf ~/.cache/nvim

npm/prefix:
	npm set prefix ~/.npm-global

archlinux/link:
	$(call link_path,$(DOTFILES)/wayland/hypr,$(CONFIG_HOME)/hypr)
	$(call link_path,$(DOTFILES)/terminal/ghostty,$(CONFIG_HOME)/ghostty)
	$(call link_path,$(DOTFILES)/terminal/alacritty,$(CONFIG_HOME)/alacritty)
	$(call link_path,$(DOTFILES)/terminal/tmux,$(CONFIG_HOME)/tmux)
	$(call link_path,$(DOTFILES)/terminal/wezterm,$(CONFIG_HOME)/wezterm)
	$(call link_path,$(DOTFILES)/terminal/zellij,$(CONFIG_HOME)/zellij)
	$(call link_path,$(DOTFILES)/terminal/yazi,$(CONFIG_HOME)/yazi)
	$(call link_path,$(DOTFILES)/terminal/lazygit,$(CONFIG_HOME)/lazygit)
	$(call link_path,$(DOTFILES)/editor/nvim,$(CONFIG_HOME)/nvim)
	$(call link_path,$(DOTFILES)/shell/fish,$(CONFIG_HOME)/fish)
	$(call link_path,$(DOTFILES)/scripts,$(LOCAL_BIN))
	$(call link_path,$(DOTFILES)/wallpapers,$(HOME)/wallpapers)
	$(call link_path,$(DOTFILES)/wayland/quickshell,$(CONFIG_HOME)/quickshell)
	$(call link_path,$(DOTFILES)/wayland/wofi,$(CONFIG_HOME)/wofi)
	$(call link_path,$(DOTFILES)/rofi,$(CONFIG_HOME)/rofi)
	$(call link_path,$(DOTFILES)/dunst,$(CONFIG_HOME)/dunst)
	$(call link_path,$(DOTFILES)/gtk-3.0,$(CONFIG_HOME)/gtk-3.0)
	$(call link_path,$(DOTFILES)/environment.d,$(CONFIG_HOME)/environment.d)
	$(call link_path,$(DOTFILES)/editor/sublime-text,$(CONFIG_HOME)/sublime-text)
	$(call link_path,$(DOTFILES)/.gitconfig,$(HOME)/.gitconfig)

# needs admin privileges
windows/setup:
	powershell -NoProfile -ExecutionPolicy Bypass -Command "New-Item -ItemType Directory -Force -Path $$env:USERPROFILE\.config | Out-Null; if (-not (Test-Path $$env:USERPROFILE\.config\nvim)) { New-Item -ItemType Junction -Path $$env:USERPROFILE\.config\nvim -Target $$PWD\editor\nvim | Out-Null }; if (-not (Test-Path $$env:LOCALAPPDATA\nvim)) { New-Item -ItemType Junction -Path $$env:LOCALAPPDATA\nvim -Target $$PWD\editor\nvim | Out-Null }; if (-not (Test-Path $$env:USERPROFILE\.config\kanata)) { New-Item -ItemType Junction -Path $$env:USERPROFILE\.config\kanata -Target $$PWD\kanata | Out-Null }"

.PHONY: push

push:
	git add . && git commit --amend --no-edit && git push -f
