set fish_greeting ""

# options
set fish_user_automatic_suggestion_verbose 1

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# my env variables
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx JAVA_HOME /usr/lib/jvm/default 2>/dev/null

# aliases
alias g git
alias ll "eza -lga --icons"
alias l "eza -lga --icons"
alias lt "eza --tree"
alias cls clear
alias phone "scrcpy --disabel-screensaver --turn-screen-off --no-audio-playback -f"
alias nf neofetch
alias v nvim
alias t tmux
alias ta "tmux a"
alias td "tmux detach"
alias cat "bat -p"
alias gci "git commit"
alias gst "git status"
alias gps "git push"
alias gpl "git pull"
alias glg "git log"
alias gcl "git clone"
alias gco "git checkout"
alias gbr "git branch"
alias gd "git diff"
alias gaa "git add ."
alias gf "git fetch"

# exporting PATHs
# set -gx PATH /home/rgnh55/.local/share/nvim/mason/bin $PATH 2>/dev/null
set -gx PATH bin $PATH 2>/dev/null
set -gx PATH ~/bin $PATH 2>/dev/null
set -gx PATH ~/.local/bin $PATH 2>/dev/null
set -gx PATH /usr/local/bin $PATH 2>/dev/null
set -gx PATH ~/.config/emacs/bin $PATH 2>/dev/null
set -gx PATH ~/.local/scripts $PATH 2>/dev/null
set -gx PATH ~/.cargo/bin $PATH 2>/dev/null
set -gx PATH $ANDROID_HOME/emulator $PATH 2>/dev/null
set -gx PATH $ANDROID_HOME/platform-tools $PATH 2>/dev/null
set -gx PATH ~/.nix-profile/bin $PATH 2>/dev/null

zoxide init fish | source
#starship init fish | source
