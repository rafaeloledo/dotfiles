function fish_user_key_bindings
    bind \cq 'fg 2>&1 | tee ~/fg_output.log > /dev/null; commandline -f repaint'
    bind \cf tmux_sessionizer
    # vim like
    bind \el forward-char # alt-l
    bind \co yazi # c-o
    bind \cl 'clear; commandline -f repaint' # c-l
    # ctrl-backspace
    bind \b backward-kill-line
    # ctrl-delete
    bind \e\[3\;5~ kill-word

    ## do not print things with some mapppings
    # c-;
    bind \e\[59\;5u ""
    # c-'
    bind \e\[39\;5u ""
    # c-]
    bind \e\[91\;5u ""
    # c-,
    bind \e\[46\;5u ""
    # c-`
    bind \e\[96\;5u ""
    # c-home
    bind \e\[1\;5H ""
    # c-end
    bind \e\[1\;5F ""
    # c-esc
    bind \e\[27\;5\;27~ ""
end
