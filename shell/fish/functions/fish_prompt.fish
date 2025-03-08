function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    set dir (prompt_pwd)
    set parts (string split "/" $dir)
    set trunc_dir (string join "" $parts[-1])
    set fstring (string join " " $trunc_dir)

    set git_branch (git branch --show-current 2>/dev/null)
    set is_nix_shell (echo $NIX_SHELL)
    set is_tmux_session (echo $TMUX)

    if test -n "$git_branch"
        set branch_string "  $git_branch"
    else
        set branch_string ""
    end

    if test -n "$is_nix_shell"
        set nix_string "󱄅"
    else
        set nix_string ""
    end

    if test -n "$is_tmux_session"
        set tmux_string "(tmux)"
    else
        set tmux_string ""
    end

    printf '%s%s%s %s %s %s\n; ' \
        (set_color $fish_color_cwd) "$fstring" (set_color normal) "$branch_string" "$nix_string" "$tmux_string"
end
