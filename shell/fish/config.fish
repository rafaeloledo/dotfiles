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

# not working with nixos projects
set -gx ANDROID_HOME $HOME/Android/Sdk
# set -gx JAVA_HOME /usr/lib/jvm/default 2>/dev/null

alias e "emacsclient -c -n"

# aliases
alias ll "eza -lga --icons"
alias l "eza -lga --icons"
alias lt "eza --tree"

alias cls clear
alias nf neofetch
alias cat "bat -p"

alias v nvim
alias vd neovide

alias lg lazygit
alias view viewnior
alias naut nautilus
alias anime ani-cli

alias t tmux
alias ta "tmux a"
alias td "tmux detach"

alias g git
alias gci "git commit"
alias gst "git status"
alias gps "git push"
alias gpl "git pull"
alias gl "git log --graph"
alias gw "git worktree"
alias gcl "git clone"
alias gc "git checkout -b" # shorthand for checkout to branch creating at same time it if not exist
alias gco "git checkout"
alias gbr "git branch"
alias gd "git diff"
alias gad "git add ."
alias gf "git fetch"
alias gs 'git stash'
alias grm "git rm"

alias db "distrobox"
alias dbl "distrobox list"
alias dbc "distrobox create"
alias dbe "distrobox enter"
alias dbrm "distrobox rm"

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
set -gx PATH ~/.npm-global/bin $PATH 2>/dev/null
set -x PATH ~/go/bin $PATH 2>/dev/null

zoxide init fish | source
#starship init fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/rgnh55/.lmstudio/bin
