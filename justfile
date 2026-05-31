dots := env_var('HOME') / "dotfiles"
cfg  := env_var('HOME') / ".config"
home := env_var('HOME')

# Symlink all dotfiles into place.
archlinux-link:
    #!/usr/bin/env bash
    set -eu

    for src in \
        linux/desktop/{hypr,quickshell,wofi,rofi,ags,dunst,gtk-3.0} \
        linux/terminal/{ghostty,alacritty,tmux,wezterm,zellij,yazi,lazygit} \
        linux/editor/{nvim,sublime-text} \
        linux/shell/fish \
        linux/system/environment.d
    do
        ln -nfs "{{dots}}/$src" "{{cfg}}/$(basename "$src")"
    done

    mkdir -p "{{home}}/.local"
    ln -nfs "{{dots}}/linux/system/scripts" "{{home}}/.local/scripts"
    ln -nfs "{{dots}}/linux/wallpapers"     "{{home}}/wallpapers"
    ln -nfs "{{dots}}/.gitconfig"           "{{home}}/.gitconfig"

    # Firefox user.js + userChrome.css into every existing profile.
    for ff_profile in "{{home}}"/.config/mozilla/firefox/*.default* "{{home}}"/.mozilla/firefox/*.default*; do
        [ -d "$ff_profile" ] || continue
        ln -nfs "{{dots}}/linux/apps/firefox/user.js" "$ff_profile/user.js"
        ln -nfs "{{dots}}/linux/apps/firefox/chrome"  "$ff_profile/chrome"
    done
