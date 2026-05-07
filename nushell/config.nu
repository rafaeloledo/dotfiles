# Nushell config based on C:\dotfiles\shell\fish.

$env.config = {
  show_banner: false
  edit_mode: emacs
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: fuzzy
  }
  history: {
    max_size: 100000
    sync_on_enter: false
    file_format: sqlite
    isolation: false
  }
  keybindings: ($env.config.keybindings? | default [])
}

source 'C:\Users\rafael\AppData\Roaming\nushell\zoxide-init.nu'
source 'C:\Users\rafael\AppData\Roaming\nushell\atuin-init.nu'
source 'C:\Users\rafael\AppData\Roaming\nushell\completions\atuin.nu'

alias l = eza -lga --icons
alias ll = eza -lga --icons
alias lt = eza --tree

alias cls = clear
alias cat = bat -p
alias v = nvim

alias t = tmux
alias ta = tmux a
alias td = tmux detach

alias g = git
alias gc = git checkout -b
alias gci = git commit
alias gst = git status
alias gps = git push
alias gpl = git pull
alias gl = git log --graph
alias gw = git worktree
alias gcl = git clone
alias gco = git checkout
alias gbr = git branch
alias gd = git diff
alias gaa = git add .
alias gf = git fetch
alias gs = git stash
alias grm = git rm

alias db = distrobox

def create_left_prompt [] {
  let dir = (pwd | path basename)
  let branch = (do -i { git branch --show-current } | complete | get stdout | str trim)
  let hour = (date now | format date "%H:%M")
  let prompt_parts = (
    [$"(ansi cyan)($hour)(ansi reset)"]
    | append (if ($branch | is-empty) { [] } else { [$"(ansi yellow)($branch)(ansi reset)"] })
    | append (if ("NIX_SHELL" in $env) { [$"(ansi blue)nix(ansi reset)"] } else { [] })
    | append (if ("TMUX" in $env) { [$"(ansi magenta)(tmux)(ansi reset)"] } else { [] })
    | append (if ($dir | is-empty) { [] } else { [$"(ansi white)($dir)(ansi reset)"] })
    | append (if ("WEZTERM_PANE" in $env) { [$"tab ($env.WEZTERM_PANE)"] } else { [] })
  )

  $"($prompt_parts | str join ' ')\n(ansi red);(ansi reset) "
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "
