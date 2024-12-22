function fish_user_key_bindings
    bind \cq 'fg 2>&1 | tee ~/fg_output.log > /dev/null; commandline -f repaint'
    bind \cf tmux_sessionizer
    # vim like
    bind \el forward-char
    bind \co yazi
    bind \cl 'clear; commandline -f repaint'
    # ctrl-backspace
    bind \b backward-kill-word
    # ctrl-delete
    bind \e\[3\;5~ kill-word
end
