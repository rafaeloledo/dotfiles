# Nushell environment based on C:\dotfiles\shell\fish\config.fish.

$env.EDITOR = "nvim"
$env.XDG_CONFIG_HOME = ($env.USERPROFILE | path join ".config")

let scoop_home = if ("SCOOP" in $env) { $env.SCOOP } else { "C:\\scoop" }

let fish_like_paths = [
  "bin"
  ($env.USERPROFILE | path join "bin")
  ($env.USERPROFILE | path join ".local" "bin")
  "C:\\usr\\local\\bin"
  ($env.XDG_CONFIG_HOME | path join "emacs" "bin")
  ($env.USERPROFILE | path join ".local" "scripts")
  "C:\\dotfiles\\scripts"
  ($env.USERPROFILE | path join ".cargo" "bin")
  ($env.USERPROFILE | path join ".nix-profile" "bin")
  ($env.USERPROFILE | path join ".npm-global" "bin")
  ($env.USERPROFILE | path join "go" "bin")
  ($env.USERPROFILE | path join ".lmstudio" "bin")
  ($scoop_home | path join "shims")
]

$env.PATH = (
  $env.PATH
  | split row (char esep)
  | prepend $fish_like_paths
  | uniq
)
