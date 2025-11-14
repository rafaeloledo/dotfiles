set fish_greeting ""

set fish_user_automatic_suggestion_verbose 1

set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME $HOME/.config

# set -gx ANDROID_HOME $HOME/Android/Sdk
# set -gx JAVA_HOME /usr/lib/jvm/default 2>/dev/null

alias l "eza -lga --icons"
alias ll "eza -lga --icons"
alias lt "eza --tree"

alias cls clear
alias cat "bat -p"

alias v "nvim ."

alias t tmux
alias ta "tmux a"
alias td "tmux detach"

alias g git
alias gc "git checkout -b" # shorthand for checkout to branch creating at same time it if not exist
alias gci "git commit"
alias gst "git status"
alias gps "git push"
alias gpl "git pull"
alias gl "git log --graph"
alias gw "git worktree"
alias gcl "git clone"
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

alias cd z

set -gx PATH bin $PATH 2>/dev/null
set -gx PATH ~/bin $PATH 2>/dev/null
set -gx PATH ~/.local/bin $PATH 2>/dev/null
set -gx PATH /usr/local/bin $PATH 2>/dev/null
set -gx PATH ~/.config/emacs/bin $PATH 2>/dev/null
set -gx PATH ~/.local/scripts $PATH 2>/dev/null
set -gx PATH ~/.cargo/bin $PATH 2>/dev/null
set -gx PATH ~/.nix-profile/bin $PATH 2>/dev/null
set -gx PATH ~/.npm-global/bin $PATH 2>/dev/null
set -x PATH ~/go/bin $PATH 2>/dev/null

set -gx PATH $PATH /home/rgnh55/.lmstudio/bin

zoxide init fish | source
