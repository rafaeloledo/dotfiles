setup:
	ln -n -f -s ~/dotfiles/scripts/ ~/.local/scripts
	ln -n -f -s ~/dotfiles/wallpapers/ ~/wallpapers
	ln -n -f -s ~/dotfiles/.gitconfig ~/.gitconfig
	ln -n -f -s ~/dotfiles/hypr ~/.config/hypr
	ln -n -f -s ~/dotfiles/i3 ~/.config/i3
	ln -n -f -s ~/dotfiles/doom ~/.config/doom
	ln -n -f -s ~/dotfiles/yazi ~/.config/yazi
	ln -n -f -s ~/dotfiles/picom ~/.config/picom
	ln -n -f -s ~/dotfiles/nvim ~/.config/nvim
	ln -n -f -s ~/dotfiles/tmux ~/.config/tmux
	ln -n -f -s ~/dotfiles/wezterm ~/.config/wezterm
	ln -n -f -s ~/dotfiles/waybar ~/.config/waybar
	ln -n -f -s ~/dotfiles/zshrc ~/.config/zshrc
	ln -n -f -s ~/dotfiles/ansible ~/.config/ansible
	ln -n -f -s ~/dotfiles/fish ~/.config/fish
	ln -n -f -s ~/dotfiles/rofi ~/.config/rofi
	ln -n -f -s ~/dotfiles/fish ~/.config/fish
	ln -n -f -s ~/dotfiles/dunst ~/.config/dunst
	ln -n -f -s ~/dotfiles/keyd ~/.config/keyd
	ln -n -f -s ~/dotfiles/gtk-3.0 ~/.config/gtk-3.0
clear:
	rm ~/.local/scripts
	rm ~/wallpapers
	rm ~/.gitconfig
	rm ~/.config/hypr
	rm ~/.config/i3
	rm ~/.config/doom
	rm ~/.config/yazi
	rm ~/.config/picom
	rm ~/.config/nvim
	rm ~/.config/tmux
	rm ~/.config/wezterm
	rm ~/.config/waybar
	rm ~/.config/zshrc
	rm ~/.config/ansible
	rm ~/.config/fish
	rm ~/.config/rofi
	rm ~/.config/fish
	rm ~/.config/dunst
	rm ~/.config/keyd
	rm ~/.config/gtk-3.0
