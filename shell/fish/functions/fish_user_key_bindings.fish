function fish_user_key_bindings
    bind ctrl-q 'fg 2>&1 | tee ~/fg_output.log > /dev/null; commandline -f repaint'
    bind crtl-f tmux_sessionizer

    bind alt-l forward-char
    bind ctrl-o yazi
    bind ctrl-l 'clear; commandline -f repaint'

    bind \b backward-kill-line
    bind \e\[3\;5~ kill-word

    bind --erase --key ctrl-_

    bind --erase \;
    bind --erase \'
    bind --erase \]
    bind --erase \,
    bind --erase \`
    bind --erase \home
    bind --erase \end

    bind \e\[27\;5\;27~ ""
end
