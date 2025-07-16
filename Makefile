.PHONY: setup clear keyd config_files wall_and_scripts doom anotacoes vim-misc firefox shell

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

keyd/service:
	sudo systemctl enable keyd --now

NOTES_DIR := $(HOME)/sync

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

npm/prefix:
	npm set prefix ~/.npm-global

.PHONY: archlinux archlinux/link

archlinux/link:
	ln -nfs ~/dotfiles/wayland/hypr ~/.config/hypr
	ln -nfs ~/dotfiles/terminal/ghostty ~/.config/ghostty
	ln -nfs ~/dotfiles/terminal/tmux ~/.config/tmux
	ln -nfs ~/dotfiles/terminal/wezterm ~/.config/wezterm
	ln -nfs ~/dotfiles/editor/nvim ~/.config/nvim
	ln -nfs ~/dotfiles/shell/fish ~/.config/fish
	ln -nfs ~/dotfiles/scripts ~/.local/scripts
	ln -nfs ~/dotfiles/wallpapers/ ~/wallpapers
	ln -nfs ~/dotfiles/wayland/waybar ~/.config/waybar
	ln -nfs ~/dotfiles/rofi ~/.config/rofi
	ln -nfs ~/dotfiles/environment.d/ ~/.config/environment.d
	ln -nfs ~/dotfiles/editor/sublime-text ~/.config/sublime-text
	ln -nfs ~/dotfiles/wayland/wofi ~/.config/wofi

# needs admin privileges
windows/setup:
	mklink /D "C:\Users\rafae\.config\autohotkey" "C:\dev\dotfiles\win32\autohotkey"
	mklink /D "C:\Users\rafae\.config\wezterm" "C:\dev\dotfiles\win32\wezterm"

.PHONY: push

push:
	git add . && git commit --amend --no-edit && git push -f
