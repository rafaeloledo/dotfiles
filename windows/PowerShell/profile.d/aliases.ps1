Set-Alias v 'nvim.exe'
Set-Alias t 'tmux.exe'
Set-Alias neo 'neovide.exe'
Set-Alias g git

function l { eza -lga --icons @args }
function lt { eza --tree @args }
function ta { tmux a @args }
function td { tmux detach @args }
# Set-Alias xxd 'C:\dev\scoop\apps\git\current\usr\bin\xxd.exe'
# Set-Alias touch 'C:\dev\scoop\apps\git\current\usr\bin\touch.exe'
# Set-Alias rm 'C:\dev\scoop\apps\git\current\usr\bin\rm.exe'
# Set-Alias bash 'C:\dev\scoop\apps\git\current\usr\bin\bash.exe'
# Set-Alias grep 'C:\dev\scoop\apps\git\current\usr\bin\grep.exe'
# Set-Alias tig 'C:\dev\scoop\apps\git\current\usr\bin\tig.exe'
# Set-Alias less 'C:\dev\scoop\apps\git\current\usr\bin\less.exe'
# Set-Alias awk 'C:\dev\scoop\apps\git\current\usr\bin\awk.exe'
# Set-Alias mv 'C:\dev\scoop\apps\git\current\usr\bin\mv.exe'
# Set-Alias perl 'C:\dev\scoop\apps\git\current\usr\bin\perl.exe'
# Set-Alias xargs 'C:\dev\scoop\apps\git\current\usr\bin\xargs.exe'
