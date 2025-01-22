setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export LANG=en_US.UTF-8
export EDITOR=nvim
export XDG_CONFIG_HOME=$HOME/.config
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.config/emacs/bin:$PATH
export PATH=$HOME/.local/scripts:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.nix-profile/bin:$PATH
export ZDOTDIR=$HOME/.config/zsh
export PATH=$ANDROID_HOME/emulator:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH

alias la=tree
alias cat=bat
alias cls='clear'

alias nf='neofetch'
alias v='nvim'
alias t='tmux'
alias ta='tmux a'
alias td='tmux detach'

# Git
alias g='git'
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza
alias l="eza -l --icons --git -a"
alias ll="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# VI Mode!!!
bindkey jj vi-cmd-mode

eval "$(zoxide init zsh)"
