MAKEFLAGS += -s

DOTFILES := $(HOME)/dotfiles
CONFIG_HOME := $(HOME)/.config
LOCAL_BIN := $(HOME)/.local/scripts
BACKUP_SUFFIX := backup.$(shell date +%Y%m%d%H%M%S)

define symlink_path
	@mkdir -p "$(dir $(2))"
	@if [ -e "$(2)" ] && [ ! -L "$(2)" ]; then \
		mv "$(2)" "$(2).$(BACKUP_SUFFIX)"; \
	fi
	@ln -nfs "$(1)" "$(2)"
endef

archlinux/link:
	$(call symlink_path,$(DOTFILES)/linux/desktop/hypr,$(CONFIG_HOME)/hypr)
	$(call symlink_path,$(DOTFILES)/linux/terminal/ghostty,$(CONFIG_HOME)/ghostty)
	$(call symlink_path,$(DOTFILES)/linux/terminal/alacritty,$(CONFIG_HOME)/alacritty)
	$(call symlink_path,$(DOTFILES)/linux/terminal/tmux,$(CONFIG_HOME)/tmux)
	$(call symlink_path,$(DOTFILES)/linux/terminal/wezterm,$(CONFIG_HOME)/wezterm)
	$(call symlink_path,$(DOTFILES)/linux/terminal/zellij,$(CONFIG_HOME)/zellij)
	$(call symlink_path,$(DOTFILES)/linux/terminal/yazi,$(CONFIG_HOME)/yazi)
	$(call symlink_path,$(DOTFILES)/linux/terminal/lazygit,$(CONFIG_HOME)/lazygit)
	$(call symlink_path,$(DOTFILES)/linux/editor/nvim,$(CONFIG_HOME)/nvim)
	$(call symlink_path,$(DOTFILES)/linux/shell/fish,$(CONFIG_HOME)/fish)
	$(call symlink_path,$(DOTFILES)/linux/system/scripts,$(LOCAL_BIN))
	$(call symlink_path,$(DOTFILES)/linux/wallpapers,$(HOME)/wallpapers)
	$(call symlink_path,$(DOTFILES)/linux/desktop/quickshell,$(CONFIG_HOME)/quickshell)
	$(call symlink_path,$(DOTFILES)/linux/desktop/wofi,$(CONFIG_HOME)/wofi)
	$(call symlink_path,$(DOTFILES)/linux/desktop/rofi,$(CONFIG_HOME)/rofi)
	$(call symlink_path,$(DOTFILES)/linux/desktop/ags,$(CONFIG_HOME)/ags)
	$(call symlink_path,$(DOTFILES)/linux/desktop/dunst,$(CONFIG_HOME)/dunst)
	$(call symlink_path,$(DOTFILES)/linux/desktop/gtk-3.0,$(CONFIG_HOME)/gtk-3.0)
	$(call symlink_path,$(DOTFILES)/linux/system/environment.d,$(CONFIG_HOME)/environment.d)
	$(call symlink_path,$(DOTFILES)/linux/editor/sublime-text,$(CONFIG_HOME)/sublime-text)
	$(call symlink_path,$(DOTFILES)/.gitconfig,$(HOME)/.gitconfig)
